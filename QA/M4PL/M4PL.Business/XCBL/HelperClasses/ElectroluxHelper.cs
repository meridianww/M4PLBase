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
		public static DeliveryUpdate GetDeliveryUpdateModel(long jobId, ActiveUser activeUser)
		{
			var jobData = _jobCommands.GetJobByProgram(activeUser, jobId, 0);
			return new DeliveryUpdate()
			{
				ServiceProvider = "Meridian",
				ServiceProviderID = jobData.Id.ToString(),
				OrderNumber = jobData.JobCustomerSalesOrder,
				OrderDate = string.Format("{0}{1}{2}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Month),
				SPTransactionID = jobData.Id.ToString(),
				InstallStatus = "Complete",
				InstallStatusTS = string.Format("{0}{1}{2}{3}{4}{5}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second),
				PlannedInstallDate = string.Format("{0}{1}{2}{3}{4}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute),
				ScheduledInstallDate = string.Format("{0}{1}{2}{3}{4}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute),
				ActualInstallDate = string.Format("{0}{1}{2}{3}{4}{5}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second),
				RescheduledInstallDate = string.Format("{0}{1}{2}{3}{4}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute),
				RescheduleReason = "Test",
				CancelDate = string.Format("{0}{1}{2}{3}{4}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute),
				CancelReason = "Test",
				Exceptions = new Exceptions { HasExceptions = "false", ExceptionInfo = null },
				UserNotes = "This is Test",
				AdditionalComments = "This is a Test Comment",
				OrderURL = "https://dms.edc.com/portal/tracking/Shipment/1017047022]]",
				POD = new POD()
				{
					DeliveryImages = new DeliveryImages()
					{
						ImageURL = "https://dms.edc.com/portal/tracking/Shipment/1017047022/POD_Image.jpg]]"
					},
					DeliverySignature = new DeliverySignature()
					{
						ImageURL = "https://dms.edc.com/portal/tracking/Shipment/1017047022/POD_SignedBy_Image.jpg]]",
						SignedBy = "Bob T Willis"
					}
				},
				OrderLineDetail = new OrderLineDetail()
				{
					OrderLine = new List<OrderLine>()
					{
						new OrderLine()
						{
							LineNumber = "1",
							ItemNumber = "FGGC3045QS",
							ItemInstallStatus = "Complete",
							UserNotes = "Test",
							ItemInstallComments = "Test",
							Exceptions = new Exceptions()
							{
								HasExceptions = "false",
								ExceptionInfo = null
							}
						}
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
