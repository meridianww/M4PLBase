﻿#region Copyright

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
using M4PL.Entities.XCBL.FarEye.Order;
using M4PL.Utilities;
using System;
using System.IO;
using System.Net;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.HelperClasses
{
	public static class FarEyeHelper
	{
		public static BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public static void PushStatusUpdateToFarEye(long jobId, ActiveUser activeUser, bool isNewOrder = false)
		{
			bool isFarEyePushNeeded = M4PLBusinessConfiguration.IsFarEyePushRequired.ToBoolean();
			if (isFarEyePushNeeded)
			{
				string farEyeAPIUrl = M4PLBusinessConfiguration.FarEyeAPIUrl;
				string farEyeAuthKey = M4PLBusinessConfiguration.FarEyeAuthKey;
				FarEyeCommands farEyeCommand = new FarEyeCommands();
				FarEyeDeliveryStatus farEyeOrderStatusRequest = null;
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
							if (isNewOrder)
							{
								deliveryUpdateModel.OrderNumber = deliveryUpdateModel.OrderNumber.Replace("O-", string.Empty);
							}
							else if (!string.IsNullOrEmpty(deliveryUpdateModel.RescheduledInstallDate))
							{
								rescheduleDate = deliveryUpdateModel.RescheduledInstallDate;
								rescheduleReason = deliveryUpdateModel.RescheduleReason;
								deliveryUpdateModel.RescheduledInstallDate = string.Empty;
								deliveryUpdateModel.RescheduleReason = string.Empty;
								isRescheduled = true;
							}
							else if (!string.IsNullOrEmpty(deliveryUpdateModel.CancelDate) && !string.IsNullOrEmpty(deliveryUpdateModel.InstallStatus) && !deliveryUpdateModel.InstallStatus.Equals("Canceled", StringComparison.OrdinalIgnoreCase))
							{
								canceledDate = deliveryUpdateModel.CancelDate;
								cancelReason = deliveryUpdateModel.CancelReason;
								deliveryUpdateModel.CancelDate = string.Empty;
								deliveryUpdateModel.CancelReason = string.Empty;
								isCanceled = true;
							}

							farEyeOrderStatusRequest = farEyeCommand.GetOrderStatus(null, deliveryUpdateModel, activeUser);
							if (farEyeOrderStatusRequest != null && !string.IsNullOrEmpty(farEyeOrderStatusRequest.carrier_status)
							 && farEyeOrderStatusRequest.carrier_status.Equals("Out For Delivery", StringComparison.OrdinalIgnoreCase))
							{
								var farEyeDisPatchedStatusRequest = farEyeOrderStatusRequest.DeepCopy();
								if (farEyeDisPatchedStatusRequest != null)
								{
									farEyeDisPatchedStatusRequest.carrier_status = "Dispatched";
									farEyeDisPatchedStatusRequest.carrier_status_code = "Dispatched";
									farEyeDisPatchedStatusRequest.carrier_status_description = "Dispatched";
									farEyeDisPatchedStatusRequest.carrier_sub_status = "Dispatched";
									farEyeDisPatchedStatusRequest.carrier_sub_status_description = "Dispatched";
									if (farEyeDisPatchedStatusRequest.info != null && farEyeDisPatchedStatusRequest.info.LineItems != null && farEyeDisPatchedStatusRequest.info.LineItems.Count > 0)
									{
										foreach (var dispatchLine in farEyeDisPatchedStatusRequest.info.LineItems)
										{
											dispatchLine.item_install_status = !string.IsNullOrEmpty(dispatchLine.item_install_status) && dispatchLine.item_install_status.Equals("Out For Delivery", StringComparison.OrdinalIgnoreCase)
												? "Dispatched" : dispatchLine.item_install_status;
										}
									}

									SentOrderStatusUpdateToFarEye(farEyeDisPatchedStatusRequest, farEyeAPIUrl, farEyeAuthKey, activeUser, jobId, isNewOrder);
								}
							}

							SentOrderStatusUpdateToFarEye(farEyeOrderStatusRequest, farEyeAPIUrl, farEyeAuthKey, activeUser, jobId, isNewOrder);

							Task.Factory.StartNew(() =>
							{
								if (isRescheduled)
								{
									deliveryUpdateModel.RescheduledInstallDate = rescheduleDate;
									deliveryUpdateModel.RescheduleReason = rescheduleReason;
									deliveryUpdateModel.InstallStatus = "Reschedule";
									farEyeOrderStatusRequest = farEyeCommand.GetOrderStatus(null, deliveryUpdateModel, activeUser);
									SentOrderStatusUpdateToFarEye(farEyeOrderStatusRequest, farEyeAPIUrl, farEyeAuthKey, activeUser, jobId);
								}
								else if (isCanceled)
								{
									deliveryUpdateModel.InstallStatus = "Canceled";
									deliveryUpdateModel.CancelDate = canceledDate;
									deliveryUpdateModel.CancelReason = cancelReason;
									farEyeOrderStatusRequest = farEyeCommand.GetOrderStatus(null, deliveryUpdateModel, activeUser);
									SentOrderStatusUpdateToFarEye(farEyeOrderStatusRequest, farEyeAPIUrl, farEyeAuthKey, activeUser, jobId);
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

		private static string SentOrderStatusUpdateToFarEye(FarEyeDeliveryStatus farEyeOrderStatusRequest, string farEyeAPIURL, string farEyeAPIKey, ActiveUser activeUser, long jobId, bool isNewOrder = false)
		{
			
			if (farEyeOrderStatusRequest != null && isNewOrder)
			{
				farEyeOrderStatusRequest.order_number = farEyeOrderStatusRequest.value;
				farEyeOrderStatusRequest.value = string.Empty;
				farEyeOrderStatusRequest.carrier_status = "Order Confirmation";
				farEyeOrderStatusRequest.carrier_status_code = "order_confirmation";
				farEyeOrderStatusRequest.carrier_status_description = "Order Confirmation";
				farEyeOrderStatusRequest.carrier_sub_status = "Order Confirmation";
				farEyeOrderStatusRequest.carrier_sub_status_description = "Order Confirmation";
				farEyeOrderStatusRequest.type = "Order";
				if (farEyeOrderStatusRequest.info?.LineItems != null)
				{
					farEyeOrderStatusRequest.info.LineItems.ForEach(x => x.item_install_status = "Order Confirmation");
				}
			}

			string farEyeOrderStatusUpdateJson = string.Empty;
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
					farEyeOrderStatusUpdateJson = Newtonsoft.Json.JsonConvert.SerializeObject(farEyeOrderStatusRequest);
					streamWriter.Write(farEyeOrderStatusUpdateJson);
				}

				WebResponse response = request.GetResponse();
				using (Stream electroluxDeliveryUpdateResponseStream = response.GetResponseStream())
				{
					using (TextReader electroluxDeliveryUpdateResponseReader = new StreamReader(electroluxDeliveryUpdateResponseStream))
					{
						responseData = electroluxDeliveryUpdateResponseReader.ReadToEnd();
					}
				}

				DataAccess.XCBL.XCBLCommands.InsertFarEyeJobDeliveryUpdateLog(farEyeOrderStatusUpdateJson, responseData, jobId);
			}
			catch (Exception exp)
			{
				responseData = exp.Message;
				DataAccess.Logger.ErrorLogger.Log(exp, string.Format("Exception occured while pushing data to Far Eye.Request json was:{0}", farEyeOrderStatusUpdateJson), "SentOrderStatusUpdateToFarEye", Utilities.Logger.LogType.Error);
			}

			return responseData;
		}
	}
}