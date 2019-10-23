/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/18/2019
Program Name:                                 NavSalesOrderHelper
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderHelper
=============================================================================================================*/

using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _purchaseCommands = M4PL.DataAccess.Finance.NavPurchaseOrderCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using System;
using M4PL.Utilities.Logger;

namespace M4PL.Business.Finance.PurchaseOrder
{
	/// <summary>
	/// Helper Class To Store the Purchase Order Related Methods
	/// </summary>
	public static class NavPurchaseOrderHelper
	{
		#region Purchase Order
		public static NavPurchaseOrder GetPurchaseOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber)
		{
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumber);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
					{
						string responceString = navPurchaseOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the purchase order: Request Url is: {0}.", serviceCall), string.Format("Get the Purchase Order Information for PONumber: {0}", poNumber), LogType.Error);
			}

			return navPurchaseOrderResponse;
		}

		public static NavPurchaseOrder GeneratePurchaseOrderForNAV(ActiveUser activeUser, long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, string dimensionCode, string divisionCode)
		{
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string navPurchaseOrderJson = string.Empty;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder", navAPIUrl, "Meridian");
			try
			{
				NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
				if (navPurchaseOrderRequest == null) { return null; }
				navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
				navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "POST";
				using (var streamWriter = new StreamWriter(request.GetRequestStream()))
				{
					navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
					streamWriter.Write(navPurchaseOrderJson);
				}

				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
					{
						string responceString = navPurchaseOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
						}
					}
				}

				if (navPurchaseOrderResponse != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.No))
				{
					_purchaseCommands.UpdateJobOrderMapping(activeUser, jobId, soNumber, navPurchaseOrderResponse.No);
					List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem);
					List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobId);
					if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
					{
						foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
						{
							navPurchaseOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
							navPurchaseOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
							if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.PurchaseOrderItem.ToString() && x.LineNumber == navPurchaseOrderItemRequestItem.Line_No).Any())
							{
								UpdatePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
							}
							else
							{
								GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
								_commands.UpdateJobOrderItemMapping(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), navPurchaseOrderItemRequestItem.Line_No);
							}
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Generating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order creation for JobId: {0}", jobId), LogType.Error);
			}

			return navPurchaseOrderResponse;
		}

		public static NavPurchaseOrder UpdatePurchaseOrderForNAV(ActiveUser activeUser, long jobId, string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, string dimensionCode, string divisionCode)
		{
			string navPurchaseOrderJson = string.Empty;
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
			try
			{
				NavPurchaseOrder existingSalesOrderData = GetPurchaseOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, poNumer);
				NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
				if (navPurchaseOrderRequest == null) { return null; }
				navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
				navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "PATCH";
				request.Headers.Add(HttpRequestHeader.IfMatch, existingSalesOrderData.DataETag);
				using (var streamWriter = new StreamWriter(request.GetRequestStream()))
				{
					navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
					streamWriter.Write(navPurchaseOrderJson);
				}

				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
					{
						string responceString = navPurchaseOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
						}
					}
				}

				if (navPurchaseOrderResponse != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.No))
				{
					List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem);
					List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobId);
					if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
					{
						foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
						{
							navPurchaseOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
							navPurchaseOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
							if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.PurchaseOrderItem.ToString() && x.LineNumber == navPurchaseOrderItemRequestItem.Line_No).Any())
							{
								UpdatePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
							}
							else
							{
								GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
								_commands.UpdateJobOrderItemMapping(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), navPurchaseOrderItemRequestItem.Line_No);
							}
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Updating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order updation for JobId: {0}", jobId), LogType.Error);
			}

			return navPurchaseOrderResponse;
		}

		#endregion

		#region Purchase Order Item

		public static NavPurchaseOrderItem GetPurchaseOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber, int lineNo)
		{
			NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", poNumber, lineNo);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderItemReader = new StreamReader(navPurchaseOrderItemResponseStream))
					{
						string responceString = navPurchaseOrderItemReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the purchase order item: Request Url is: {0}", serviceCall), string.Format("Purchase order item get for Purchase Order: {0} and Line number {1}.", poNumber, lineNo), LogType.Error);
			}

			return navPurchaseOrderItemResponse;
		}

		private static NavPurchaseOrderItem GeneratePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseLine", navAPIUrl, "Meridian");
			string navPurchaseOrderItemJson = string.Empty;
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest navPurchaseOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
				navPurchaseOrderItemrequest.Credentials = myCredentials;
				navPurchaseOrderItemrequest.KeepAlive = false;
				navPurchaseOrderItemrequest.ContentType = "application/json";
				navPurchaseOrderItemrequest.Method = "POST";
				using (var navPurchaseOrderItemStreamWriter = new StreamWriter(navPurchaseOrderItemrequest.GetRequestStream()))
				{
					navPurchaseOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderItemRequest);
					navPurchaseOrderItemStreamWriter.Write(navPurchaseOrderItemJson);
				}

				WebResponse response = navPurchaseOrderItemrequest.GetResponse();

				using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemSyncReader = new StreamReader(navPurchaseOrderItemResponseStream))
					{
						string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderItemResponseString))
						{
							navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(navSalesOrderItemResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Creating the purchase order item: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderItemJson), string.Format("Purchase order item create for JobId: {0}, Line number: {1}", navPurchaseOrderItemRequest.M4PL_Job_ID, navPurchaseOrderItemRequest.Line_No), LogType.Error);
			}

			return navPurchaseOrderItemResponse;
		}

		private static NavPurchaseOrderItem UpdatePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
			string navPurchaseOrderItemJson = string.Empty;
			string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", navPurchaseOrderItemRequest.Document_No, navPurchaseOrderItemRequest.Line_No);
			try
			{
				NavPurchaseOrderItem existingNavPurchaseOrderItem = GetPurchaseOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, navPurchaseOrderItemRequest.Document_No, navPurchaseOrderItemRequest.Line_No);
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest navPurchaseOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
				navPurchaseOrderItemrequest.Credentials = myCredentials;
				navPurchaseOrderItemrequest.KeepAlive = false;
				navPurchaseOrderItemrequest.ContentType = "application/json";
				navPurchaseOrderItemrequest.Method = "PATCH";
				navPurchaseOrderItemrequest.Headers.Add(HttpRequestHeader.IfMatch, existingNavPurchaseOrderItem.DataETag);
				using (var navPurchaseOrderItemStreamWriter = new StreamWriter(navPurchaseOrderItemrequest.GetRequestStream()))
				{
					navPurchaseOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderItemRequest);
					navPurchaseOrderItemStreamWriter.Write(navPurchaseOrderItemJson);
				}

				WebResponse response = navPurchaseOrderItemrequest.GetResponse();

				using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemSyncReader = new StreamReader(navPurchaseOrderItemResponseStream))
					{
						string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderItemResponseString))
						{
							navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(navSalesOrderItemResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Updating the purchase order item: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderItemJson), string.Format("Purchase order item update for JobId: {0}, Line number: {1}", navPurchaseOrderItemRequest.M4PL_Job_ID, navPurchaseOrderItemRequest.Line_No), LogType.Error);
			}

			return navPurchaseOrderItemResponse;
		}

		#endregion
	}
}
