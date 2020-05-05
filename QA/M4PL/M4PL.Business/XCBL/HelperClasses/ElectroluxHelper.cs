using M4PL.Entities.Support;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Utilities.Logger;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _commands = M4PL.DataAccess.XCBL.XCBLCommands;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using M4PL.Utilities;

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
			return new DeliveryUpdate()
			{
				ServiceProvider = deliveryUpdateModel.ServiceProvider,
				ServiceProviderID = deliveryUpdateModel.ServiceProviderID,
				OrderNumber = deliveryUpdateModel.OrderNumber,
				OrderDate = !deliveryUpdateModel.OrderDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}", deliveryUpdateModel.OrderDate.ToDateTime().Year, deliveryUpdateModel.OrderDate.ToDateTime().Month, deliveryUpdateModel.OrderDate.ToDateTime().Day),
				SPTransactionID = deliveryUpdateModel.SPTransactionID,
				InstallStatus = deliveryUpdateModel.InstallStatus,
				InstallStatusTS = !deliveryUpdateModel.InstallStatusTS.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}{5}", deliveryUpdateModel.InstallStatusTS.ToDateTime().Year, deliveryUpdateModel.InstallStatusTS.ToDateTime().Month, deliveryUpdateModel.InstallStatusTS.ToDateTime().Day, deliveryUpdateModel.InstallStatusTS.ToDateTime().Hour, deliveryUpdateModel.InstallStatusTS.ToDateTime().Minute, deliveryUpdateModel.InstallStatusTS.ToDateTime().Second),
				PlannedInstallDate = !deliveryUpdateModel.PlannedInstallDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}", deliveryUpdateModel.PlannedInstallDate.ToDateTime().Year, deliveryUpdateModel.PlannedInstallDate.ToDateTime().Month, deliveryUpdateModel.PlannedInstallDate.ToDateTime().Day, deliveryUpdateModel.PlannedInstallDate.ToDateTime().Hour, deliveryUpdateModel.PlannedInstallDate.ToDateTime().Minute),
				ScheduledInstallDate = !deliveryUpdateModel.ScheduledInstallDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}", deliveryUpdateModel.ScheduledInstallDate.ToDateTime().Year, deliveryUpdateModel.ScheduledInstallDate.ToDateTime().Month, deliveryUpdateModel.ScheduledInstallDate.ToDateTime().Day, deliveryUpdateModel.ScheduledInstallDate.ToDateTime().Hour, deliveryUpdateModel.ScheduledInstallDate.ToDateTime().Minute),
				ActualInstallDate = !deliveryUpdateModel.ActualInstallDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}{5}", deliveryUpdateModel.ActualInstallDate.ToDateTime().Year, deliveryUpdateModel.ActualInstallDate.ToDateTime().Month, deliveryUpdateModel.ActualInstallDate.ToDateTime().Day, deliveryUpdateModel.ActualInstallDate.ToDateTime().Hour, deliveryUpdateModel.ActualInstallDate.ToDateTime().Minute, deliveryUpdateModel.ActualInstallDate.ToDateTime().Second),
				RescheduledInstallDate = !deliveryUpdateModel.RescheduledInstallDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}", deliveryUpdateModel.RescheduledInstallDate.ToDateTime().Year, deliveryUpdateModel.RescheduledInstallDate.ToDateTime().Month, deliveryUpdateModel.RescheduledInstallDate.ToDateTime().Day, deliveryUpdateModel.RescheduledInstallDate.ToDateTime().Hour, deliveryUpdateModel.RescheduledInstallDate.ToDateTime().Minute),
				RescheduleReason = deliveryUpdateModel.RescheduleReason,
				CancelDate = !deliveryUpdateModel.CancelDate.ToDate().HasValue ? string.Empty : string.Format("{0}{1}{2}{3}{4}", deliveryUpdateModel.CancelDate.ToDateTime().Year, deliveryUpdateModel.CancelDate.ToDateTime().Month, deliveryUpdateModel.CancelDate.ToDateTime().Day, deliveryUpdateModel.CancelDate.ToDateTime().Hour, deliveryUpdateModel.CancelDate.ToDateTime().Minute),
				CancelReason = deliveryUpdateModel.CancelReason,
				Exceptions = deliveryUpdateModel.Exceptions,
				UserNotes = deliveryUpdateModel.UserNotes,
				AdditionalComments = deliveryUpdateModel.AdditionalComments,
				OrderURL = string.Format("{0}?jobId={1}", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID),
				OrderLineDetail = deliveryUpdateModel.OrderLineDetail,
				POD = new POD()
				{
					DeliveryImages = new DeliveryImages()
					{
						ImageURL = string.Format("{0}?jobId={0}&tabName=POD", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID)
					},
					DeliverySignature = new DeliverySignature()
					{
						ImageURL = string.Format("{0}?jobId={0}&tabName=POD", M4PBusinessContext.ComponentSettings.M4PLApplicationURL, deliveryUpdateModel.ServiceProviderID),
						SignedBy = string.Empty //waiting for Nathan Reply on this
					}
				}
			};
		}

		private static string CreateDeliveryUpdateRequestXml(DeliveryUpdate deliveryUpdate)
		{
			XmlDocument xmlDoc = new XmlDocument();
			XmlSerializer xmlSerializer = new XmlSerializer(deliveryUpdate.GetType());
			using (MemoryStream xmlStream = new MemoryStream())
			{
				xmlSerializer.Serialize(xmlStream, deliveryUpdate);
				xmlStream.Position = 0;
				xmlDoc.Load(xmlStream);
				return string.Format(format: "{0} {1} {2}", arg0: "<ns:DeliveryUpdate xmlns:ns=\"http://esb.electrolux.com/FinalMile/Delivery\">", arg1: xmlDoc.DocumentElement.InnerXml, arg2: "</ns:DeliveryUpdate>");
			}
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
