using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Utilities.Logger;
using System;
using System.IO;
using System.Net;
using System.Xml;
using System.Xml.Serialization;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.Business.XCBL.HelperClasses
{
    public static class ElectroluxHelper
    {
        public static DeliveryUpdateResponse SendDeliveryUpdateRequestToElectrolux(ActiveUser activeUser, DeliveryUpdate deliveryUpdate, long jobId)
        {
            DeliveryUpdateResponse deliveryUpdateResponse = null;
            string deliveryUpdateResponseString = string.Empty;
            string deliveryUpdateXml = string.Empty;
            string deliveryUpdateURL = string.Empty;
            string deliveryUpdateUserName = string.Empty;
            string deliveryUpdatePassword = string.Empty;
            if (!M4PBusinessContext.ComponentSettings.IsElectroluxDeliveryUpdateProduction)
            {
                deliveryUpdateURL = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateTestAPIUrl;
                deliveryUpdateUserName = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateTestAPIUsername;
                deliveryUpdatePassword = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateTestAPIPassword;
            }
            else
            {
                deliveryUpdateURL = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateProductionAPIUrl;
                deliveryUpdateUserName = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateProductionAPIUsername;
                deliveryUpdatePassword = M4PBusinessContext.ComponentSettings.ElectroluxDeliveryUpdateProductionAPIPassword;
            }

            try
            {
                NetworkCredential networkCredential = new NetworkCredential(deliveryUpdateUserName, deliveryUpdatePassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(deliveryUpdateURL);
                request.Credentials = networkCredential;
                request.KeepAlive = false;
                request.ContentType = "application/xml";
                request.Method = "POST";
                using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                {
                    deliveryUpdateXml = CreateDeliveryUpdateRequestXml(deliveryUpdate);
                    streamWriter.Write(deliveryUpdateXml);
                }

                WebResponse response = request.GetResponse();

                using (Stream electroluxDeliveryUpdateResponseStream = response.GetResponseStream())
                {
                    using (TextReader electroluxDeliveryUpdateResponseReader = new StreamReader(electroluxDeliveryUpdateResponseStream))
                    {
                        string electroluxDeliveryUpdateResponseString = electroluxDeliveryUpdateResponseReader.ReadToEnd();

                        using (var stringReader = new StringReader(electroluxDeliveryUpdateResponseString))
                        {
                            deliveryUpdateResponseString = electroluxDeliveryUpdateResponseString;
                            deliveryUpdateResponse = GenerateDeliveryUpdateResponseFromString(electroluxDeliveryUpdateResponseString);
                        }
                    }
                }

                if (!string.IsNullOrEmpty(deliveryUpdateResponseString))
                {
                    M4PL.DataAccess.Job.JobEDIXcblCommands.Post(activeUser, new JobEDIXcbl()
                    {
                        JobId = jobId,
                        EdtCode = "Delivery Update",
                        EdtTypeId = M4PBusinessContext.ComponentSettings.XCBLEDTType,
                        EdtData = deliveryUpdateXml,
                        TransactionDate = Utilities.TimeUtility.GetPacificDateTime(),
                        EdtTitle = "Delivery Update"
                    });
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, string.Format("Error is occuring while Sending the Delivery Update To Electrolux: Request Url is: {0}, Request body xml was {1}", deliveryUpdateURL, deliveryUpdateXml), string.Format("Electrolux delivery update for JobId: {0}", jobId), LogType.Error);
            }

            InsertJobDeliveryUpdateLog(deliveryUpdateXml, deliveryUpdateResponseString, jobId);
            return deliveryUpdateResponse;
        }
        public static DeliveryUpdate GetDeliveryUpdateModel(DeliveryUpdate deliveryUpdateModel, ActiveUser activeUser)
        {
            if (deliveryUpdateModel == null) { return null; }

            DeliveryUpdate deliveryUpdate = new DeliveryUpdate()
            {
                ServiceProvider = deliveryUpdateModel.ServiceProvider,
                ServiceProviderID = deliveryUpdateModel.ServiceProviderID,
                OrderNumber = deliveryUpdateModel.OrderNumber,
                OrderDate = deliveryUpdateModel.OrderDate,
                SPTransactionID = deliveryUpdateModel.SPTransactionID,
                InstallStatus = deliveryUpdateModel.InstallStatus,
                InstallStatusTS = deliveryUpdateModel.InstallStatusTS,
                PlannedInstallDate = deliveryUpdateModel.PlannedInstallDate,
                ScheduledInstallDate = deliveryUpdateModel.ScheduledInstallDate,
                ActualInstallDate = deliveryUpdateModel.ActualInstallDate,
                RescheduledInstallDate = deliveryUpdateModel.RescheduledInstallDate,
                RescheduleReason = deliveryUpdateModel.RescheduleReason,
                CancelDate = deliveryUpdateModel.CancelDate,
                CancelReason = deliveryUpdateModel.CancelReason,
                Exceptions = deliveryUpdateModel.Exceptions,
                UserNotes = deliveryUpdateModel.UserNotes,
                AdditionalComments = deliveryUpdateModel.AdditionalComments,
                OrderURL = string.Format("<![CDATA[{0}?jobId={1}]]>", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID),
                OrderLineDetail = deliveryUpdateModel.OrderLineDetail
            };

            deliveryUpdate.POD = deliveryUpdateModel.POD == null ? new POD() : deliveryUpdateModel.POD;
            deliveryUpdate.POD.DeliveryImages = deliveryUpdateModel.POD.DeliveryImages == null ? new DeliveryImages() : deliveryUpdateModel.POD.DeliveryImages;
            deliveryUpdate.POD.DeliveryImages.ImageURL = string.Format("<![CDATA[{0}?jobId={1}&tabName=POD]]>", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID);
            deliveryUpdate.POD.DeliverySignature = deliveryUpdateModel.POD.DeliverySignature == null ? new DeliverySignature() : deliveryUpdateModel.POD.DeliverySignature;
            deliveryUpdate.POD.DeliverySignature.ImageURL = string.Format("<![CDATA[{0}?jobId={1}&tabName=POD]]>", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID);

            return deliveryUpdate;
        }

        private static string CreateDeliveryUpdateRequestXml(DeliveryUpdate deliveryUpdate)
        {
            string xmlString = string.Empty;
            XmlDocument xmlDoc = new XmlDocument();
            XmlSerializer xmlSerializer = new XmlSerializer(deliveryUpdate.GetType());
            using (MemoryStream xmlStream = new MemoryStream())
            {
                xmlSerializer.Serialize(xmlStream, deliveryUpdate);
                xmlStream.Position = 0;
                xmlDoc.Load(xmlStream);
                xmlString = string.Format(format: "{0} {1} {2}", arg0: "<ns:DeliveryUpdate xmlns:ns=\"http://esb.electrolux.com/FinalMile/Delivery\">", arg1: xmlDoc.DocumentElement.InnerXml, arg2: "</ns:DeliveryUpdate>");
            }

            xmlString = !string.IsNullOrEmpty(xmlString) ? xmlString.Replace("&amp;", "&") : xmlString;
            xmlString = !string.IsNullOrEmpty(xmlString) ? xmlString.Replace("&lt;", "<") : xmlString;
            xmlString = !string.IsNullOrEmpty(xmlString) ? xmlString.Replace("&gt;", ">") : xmlString;

            return xmlString;
        }
        private static DeliveryUpdateResponse GenerateDeliveryUpdateResponseFromString(string updateResponseString)
        {
            updateResponseString = updateResponseString.Replace("NS1:DeliveryUpdateResponse", "DeliveryUpdateResponse");
            DeliveryUpdateResponse deliveryUpdateResponse = null;
            XmlSerializer serializer = new XmlSerializer(typeof(DeliveryUpdateResponse));
            using (var stringReader = new StringReader(updateResponseString))
            {
                deliveryUpdateResponse = (DeliveryUpdateResponse)serializer.Deserialize(stringReader);
            }

            return deliveryUpdateResponse;
        }

        private static void InsertJobDeliveryUpdateLog(string deliveryUpdateXml, string deliveryUpdateResponseString, long jobId)
        {
            _commands.InsertJobDeliveryUpdateLog(deliveryUpdateXml, deliveryUpdateResponseString, jobId);
        }
    }
}
