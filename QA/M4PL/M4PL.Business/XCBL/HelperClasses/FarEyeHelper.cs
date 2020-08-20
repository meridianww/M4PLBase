#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Support;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.HelperClasses
{
	public static class FarEyeHelper
	{
		public static void PushStatusUpdateToFarEye(long jobId, ActiveUser activeUser)
		{
			bool isFarEyePushNeeded = M4PBusinessContext.ComponentSettings.IsFarEyePushRequired;
			if (!isFarEyePushNeeded)
			{
				bool isUpdateRequiredToPushOnProduction = M4PBusinessContext.ComponentSettings.IsElectroluxDeliveryUpdateProduction;
				string testAPIURL = M4PBusinessContext.ComponentSettings.FarEyeUpdateTestAPIURL;
				string testAPIKey = M4PBusinessContext.ComponentSettings.FarEyeUpdateTestAPIKey;
				string productionAPIURL = M4PBusinessContext.ComponentSettings.FarEyeUpdateProductionAPIURL;
				string productionAPIKey = M4PBusinessContext.ComponentSettings.FarEyeUpdateProductionAPIKey;
				Task.Factory.StartNew(() =>
				{
					try
					{
						var deliveryUpdateModel = DataAccess.XCBL.XCBLCommands.GetDeliveryUpdateModel(jobId, activeUser);
						if (deliveryUpdateModel != null)
						{
							string requestBody = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdateModel);
							string response = SentOrderStatusUpdateToFarEye(deliveryUpdateModel, isUpdateRequiredToPushOnProduction, testAPIURL, testAPIKey, productionAPIURL, productionAPIKey);
							DataAccess.XCBL.XCBLCommands.InsertFarEyeJobDeliveryUpdateLog(requestBody, response, jobId);
						}
					}
					catch (Exception exp)
					{
						DataAccess.Logger.ErrorLogger.Log(exp, "Exception occured while pushing data to Far Eye.", "PushStatusUpdateToFarEye", Utilities.Logger.LogType.Error);
					}
				});
			}
		}

		private static string SentOrderStatusUpdateToFarEye(DeliveryUpdate deliveryUpdate, bool isUpdateRequiredToPushOnProduction, string testAPIURL, string testAPIKey, string productionAPIURL, string productionAPIKey)
		{
			string electroluxOrderStatusUpdateJson = string.Empty;
			string farEyeUpdateURL = string.Empty;
			string farEyeApiKey = string.Empty;
			string responseData = string.Empty;
			if (!isUpdateRequiredToPushOnProduction)
			{
				farEyeUpdateURL = string.Format("{0}/Connector/v1/meridian/trackingUpdates", testAPIURL);
				farEyeApiKey = string.Format("bearer {0}", testAPIKey);
			}
			else
			{
				farEyeUpdateURL = string.Format("{0}/Connector/v1/meridian/trackingUpdates", productionAPIURL);
				farEyeApiKey = string.Format("bearer {0}", productionAPIKey);
			}

			try
			{
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(farEyeUpdateURL);
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "POST";
				request.Headers.Add(HttpRequestHeader.Authorization, farEyeApiKey);
				using (var streamWriter = new StreamWriter(request.GetRequestStream()))
				{
					electroluxOrderStatusUpdateJson = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdate);
					streamWriter.Write(electroluxOrderStatusUpdateJson);
				}

				WebResponse response = request.GetResponse();
				using (Stream electroluxDeliveryUpdateResponseStream = response.GetResponseStream())
				{
					using (TextReader electroluxDeliveryUpdateResponseReader = new StreamReader(electroluxDeliveryUpdateResponseStream))
					{
						responseData = electroluxDeliveryUpdateResponseReader.ReadToEnd();
					}
				}
			}
			catch(Exception exp)
			{
				responseData = exp.Message;
				DataAccess.Logger.ErrorLogger.Log(exp, "Exception occured while pushing data to Far Eye.", "SentOrderStatusUpdateToFarEye", Utilities.Logger.LogType.Error);
			}

			return responseData;
		}
	}
}
