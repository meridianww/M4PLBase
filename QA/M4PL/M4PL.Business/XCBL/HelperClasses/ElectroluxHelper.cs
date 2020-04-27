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

namespace M4PL.Business.XCBL.HelperClasses
{
	public static class ElectroluxHelper
	{
		public static DeliveryUpdateResponse SendDeliveryUpdateRequestToElectrolux(ActiveUser activeUser, DeliveryUpdate deliveryUpdate, long jobId)
		{
			DeliveryUpdateResponse deliveryUpdateResponse = null;
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
							deliveryUpdateResponse = GenerateDeliveryUpdateResponseFromString(electroluxDeliveryUpdateResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Sending the Delivery Update To Electrolux: Request Url is: {0}, Request body xml was {1}", deliveryUpdateURL, deliveryUpdateXml), string.Format("Electrolux delivery update for JobId: {0}", jobId), LogType.Error);
			}

			return deliveryUpdateResponse;
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

	}
}
