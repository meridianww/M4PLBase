#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Utilities;
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
		public static BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public static void PushStatusUpdateToFarEye(long jobId, ActiveUser activeUser)
		{
			bool isFarEyePushNeeded = M4PLBusinessConfiguration.IsFarEyePushRequired.ToBoolean();
			if (isFarEyePushNeeded)
			{
				string farEyeAPIUrl = M4PLBusinessConfiguration.FarEyeAPIUrl;
				string farEyeAuthKey = M4PLBusinessConfiguration.FarEyeAuthKey;
				Task.Factory.StartNew(() =>
				{
					try
					{
						var deliveryUpdateModel = DataAccess.XCBL.XCBLCommands.GetDeliveryUpdateModel(jobId, activeUser);
						if (deliveryUpdateModel != null)
						{
							string rescheduleReason = string.Empty;
							string rescheduleDate = string.Empty;
							string canceledDate = string.Empty;
							string cancelReason = string.Empty;
							bool isCanceled = false;
							bool isRescheduled = false;
							if (!string.IsNullOrEmpty(deliveryUpdateModel.RescheduledInstallDate))
							{
								rescheduleDate = deliveryUpdateModel.RescheduledInstallDate;
								rescheduleReason = deliveryUpdateModel.RescheduleReason;
								deliveryUpdateModel.RescheduledInstallDate = string.Empty;
								deliveryUpdateModel.RescheduleReason = string.Empty;
								isRescheduled = true;
							}

							if (!string.IsNullOrEmpty(deliveryUpdateModel.CancelDate) && !string.IsNullOrEmpty(deliveryUpdateModel.InstallStatus) && !deliveryUpdateModel.InstallStatus.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
							{
								canceledDate = deliveryUpdateModel.CancelDate;
								cancelReason = deliveryUpdateModel.CancelReason;
								deliveryUpdateModel.CancelDate = string.Empty;
								deliveryUpdateModel.CancelReason = string.Empty;
								isCanceled = true;
							}

								string requestBody = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdateModel);
							string response = SentOrderStatusUpdateToFarEye(deliveryUpdateModel, farEyeAPIUrl, farEyeAuthKey);
							DataAccess.XCBL.XCBLCommands.InsertFarEyeJobDeliveryUpdateLog(requestBody, response, jobId);

							Task.Factory.StartNew(() =>
							{
								if (isRescheduled)
								{
									deliveryUpdateModel.RescheduledInstallDate = rescheduleDate;
									deliveryUpdateModel.RescheduleReason = rescheduleReason;
									deliveryUpdateModel.InstallStatus = "Reschedule";
									string rescheduleRequestBody = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdateModel);
									string rescheduleResponse = SentOrderStatusUpdateToFarEye(deliveryUpdateModel, farEyeAPIUrl, farEyeAuthKey);
									DataAccess.XCBL.XCBLCommands.InsertFarEyeJobDeliveryUpdateLog(rescheduleRequestBody, rescheduleResponse, jobId);
								}
								else if (isCanceled)
								{
									deliveryUpdateModel.InstallStatus = "Canceled";
									deliveryUpdateModel.CancelDate = canceledDate;
									deliveryUpdateModel.CancelReason = cancelReason;
									string cancelledRequestBody = Newtonsoft.Json.JsonConvert.SerializeObject(deliveryUpdateModel);
									string cancelledResponse = SentOrderStatusUpdateToFarEye(deliveryUpdateModel, farEyeAPIUrl, farEyeAuthKey);
									DataAccess.XCBL.XCBLCommands.InsertFarEyeJobDeliveryUpdateLog(cancelledRequestBody, cancelledResponse, jobId);
								}
							});
						}
					}
					catch (Exception exp)
					{
						DataAccess.Logger.ErrorLogger.Log(exp, "Exception occured while pushing data to Far Eye.", "PushStatusUpdateToFarEye", Utilities.Logger.LogType.Error);
					}
				});
			}
		}

		private static string SentOrderStatusUpdateToFarEye(DeliveryUpdate deliveryUpdate, string farEyeAPIURL, string farEyeAPIKey)
		{
			string electroluxOrderStatusUpdateJson = string.Empty;
			string farEyeUpdateURL = string.Empty;
			string farEyeApiKey = string.Empty;
			string responseData = string.Empty;
			farEyeUpdateURL = string.Format("{0}/Connector/v1/meridian/trackingUpdates", farEyeAPIURL);
			farEyeApiKey = string.Format("bearer {0}", farEyeAPIKey);

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
