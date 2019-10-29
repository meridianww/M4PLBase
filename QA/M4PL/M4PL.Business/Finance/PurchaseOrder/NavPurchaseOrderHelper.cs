﻿/*Copyright(2016) Meridian Worldwide Transportation Group
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
			string proFlag = null;
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
					UpdateLineItemInformationForPurchaseOrder(activeUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navPurchaseOrderResponse.No, out proFlag);
				}
			}
			catch (Exception exp)
			{
				proFlag = Entities.ProFlag.H.ToString();
				_logger.Log(exp, string.Format("Error is occuring while Generating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order creation for JobId: {0}", jobId), LogType.Error);
			}

			_commands.UpdateJobProFlag(activeUser, proFlag, jobId, Entities.EntitiesAlias.PurchaseOrder);
			return navPurchaseOrderResponse;
		}

		public static NavPurchaseOrder UpdatePurchaseOrderForNAV(ActiveUser activeUser, long jobId, string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, string dimensionCode, string divisionCode)
		{
			string navPurchaseOrderJson = string.Empty;
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string proFlag = null;
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
					UpdateLineItemInformationForPurchaseOrder(activeUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navPurchaseOrderResponse.No, out proFlag);
				}
			}
			catch (Exception exp)
			{
				proFlag = Entities.ProFlag.H.ToString();
				_logger.Log(exp, string.Format("Error is occuring while Updating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order updation for JobId: {0}", jobId), LogType.Error);
			}

			_commands.UpdateJobProFlag(activeUser, proFlag, jobId, Entities.EntitiesAlias.PurchaseOrder);
			return navPurchaseOrderResponse;
		}

		public static bool DeletePurchaseOrderForNAV(string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "DELETE";
				WebResponse response = request.GetResponse();
				isRecordDeleted = response != null && (response as HttpWebResponse).StatusCode == HttpStatusCode.NoContent ? true : false;
			}
			catch (Exception exp)
			{
				isRecordDeleted = false;
				_logger.Log(exp, string.Format("Error is occuring while Deleting the Purchase order: Request Url is: {0}", serviceCall), string.Format("Sales order item delete for Purchase Order: {0}.", poNumer), LogType.Error);
			}

			return isRecordDeleted;
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

		private static NavPurchaseOrderItem GeneratePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordUpdated)
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

			isRecordUpdated = navPurchaseOrderItemResponse == null ? false : true;
			return navPurchaseOrderItemResponse;
		}

		private static NavPurchaseOrderItem UpdatePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordUpdated)
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

			isRecordUpdated = navPurchaseOrderItemResponse == null ? false : true;
			return navPurchaseOrderItemResponse;
		}

		public static bool DeletePurchaseOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber, int lineNo, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", poNumber, lineNo);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "DELETE";
				WebResponse response = request.GetResponse();
				isRecordDeleted = response != null && (response as HttpWebResponse).StatusCode == HttpStatusCode.NoContent ? true : false;
			}
			catch (Exception exp)
			{
				isRecordDeleted = false;
				_logger.Log(exp, string.Format("Error is occuring while Deleting the Purchase order item: Request Url is: {0}", serviceCall), string.Format("Purchase order item delete for Purchase Order: {0} and Line number {1}.", poNumber, lineNo), LogType.Error);
			}

			return isRecordDeleted;
		}

		#endregion

		#region Helper Method

		private static void UpdateLineItemInformationForPurchaseOrder(ActiveUser activeUser, long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, string poNumber, out string proFlag)
		{
			bool allLineItemsUpdated = true;
			string deleteProFlag = null;
			bool allLineItemsDeleted = true;
			List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem);
			List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobId);
			bool isRecordUpdated = true;
			bool isRecordDeleted = true;
			if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
			{
				DeleteLineItemInformationForPurchaseOrder(activeUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, allLineItemsUpdated, navPurchaseOrderItemRequest, jobOrderItemMapping, poNumber, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
			}

			NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
			if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
			{
				foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
				{
					navPurchaseOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
					navPurchaseOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
					if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.PurchaseOrderItem.ToString() && x.LineNumber == navPurchaseOrderItemRequestItem.Line_No).Any())
					{
						UpdatePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
					}
					else
					{
						navPurchaseOrderItemResponse = GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
						if (navPurchaseOrderItemResponse != null)
						{
							_commands.UpdateJobOrderItemMapping(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), navPurchaseOrderItemRequestItem.Line_No);
						}
					}

					allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
					isRecordUpdated = true;
					navPurchaseOrderItemResponse = null;
				}
			}

			proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
			_commands.UpdateJobProFlag(activeUser, proFlag, jobId, Entities.EntitiesAlias.PurchaseOrder);
		}

		private static void DeleteLineItemInformationForPurchaseOrder(ActiveUser activeUser, long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool allLineItemsUpdated, List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, string poNumber, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
		{
			IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = null;
			var deletedItems = navPurchaseOrderItemRequest?.Select(s => s.Line_No);
			deletedJobOrderItemMapping = deletedItems == null ? deletedJobOrderItemMapping : jobOrderItemMapping.Where(t => t.EntityName == Entities.EntitiesAlias.PurchaseOrderItem.ToString() && !deletedItems.Contains(t.LineNumber));
			foreach (var deleteItem in deletedJobOrderItemMapping)
			{
				DeletePurchaseOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, poNumber, deleteItem.LineNumber, out isRecordDeleted);
				if (isRecordDeleted)
				{
					_commands.DeleteJobOrderItemMapping(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), deleteItem.LineNumber);
				}

				allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
			}

			deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
			_commands.UpdateJobProFlag(activeUser, deleteProFlag, jobId, Entities.EntitiesAlias.PurchaseOrder);
		}

		#endregion
	}
}
