/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/18/2019
Program Name:                                 NavSalesOrderHelper
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderHelper
=============================================================================================================*/

using System.IO;
using System.Net;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Utilities.Logger;
using System;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Linq;
using Newtonsoft.Json.Linq;
using M4PL.Entities.Finance.OrderItem;
using System.Collections.Generic;
using M4PL.Entities.Finance.JobOrderMapping;
using System.Threading.Tasks;
using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Business.Common;

namespace M4PL.Business.Finance.SalesOrder
{
	/// <summary>
	/// Helper Class To Store the Sales Order Related Methods
	/// </summary>
	public static class NavSalesOrderHelper
	{
		#region Sales Order

		public static NavSalesOrder GetSalesOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderReader = new StreamReader(navSalesOrderResponseStream))
					{
						string navSalesOrderResponseString = navSalesOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderResponseString))
						{
							navSalesOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrder>(navSalesOrderResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the Sales order: Request Url is: {0}.", serviceCall), string.Format("Get the Sales Order Information for SONumber: {0}", soNumber), LogType.Error);
			}

			return navSalesOrderResponse;
		}

		public static NavSalesOrder GenerateSalesOrderForNAV(ActiveUser activeUser, NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string navSalesOrderJson = string.Empty;
			string proFlag = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder", navAPIUrl, "Meridian");
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "POST";
				using (var streamWriter = new StreamWriter(request.GetRequestStream()))
				{
					navSalesOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrder);
					streamWriter.Write(navSalesOrderJson);
				}

				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderReader = new StreamReader(navSalesOrderResponseStream))
					{
						string navSalesOrderResponseString = navSalesOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderResponseString))
						{
							navSalesOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrder>(navSalesOrderResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				proFlag = Entities.ProFlag.H.ToString();
				_logger.Log(exp, string.Format("Error is occuring while Generating the Sales order: Request Url is: {0}, Request body json was {1}", serviceCall, navSalesOrderJson), string.Format("Sales order creation for JobId: {0}", navSalesOrder.M4PL_Job_ID), LogType.Error);
			}

			var jobIdList = new System.Collections.Generic.List<long>();
			jobIdList.Add(Convert.ToInt64(navSalesOrder.M4PL_Job_ID));
			_commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);

			return navSalesOrderResponse;
		}

		public static NavSalesOrder UpdateSalesOrderForNAV(ActiveUser activeUser, NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string navSalesOrderJson = string.Empty;
			string proFlag = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
			try
			{
				NavSalesOrder existingSalesOrderData = GetSalesOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				request.Method = "PATCH";
				existingSalesOrderData.DataETag = existingSalesOrderData.DataETag.Replace("W/", string.Empty);
				request.Headers.Add(HttpRequestHeader.IfMatch, existingSalesOrderData.DataETag);
				using (var streamWriter = new StreamWriter(request.GetRequestStream()))
				{
					navSalesOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrder);
					streamWriter.Write(navSalesOrderJson);
				}

				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderReader = new StreamReader(navSalesOrderResponseStream))
					{
						string navSalesOrderResponseString = navSalesOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderResponseString))
						{
							navSalesOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrder>(navSalesOrderResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				proFlag = Entities.ProFlag.H.ToString();
				_logger.Log(exp, string.Format("Error is occuring while Updating the Sales order: Request Url is: {0}, Request body json was {1}", serviceCall, navSalesOrderJson), string.Format("Sales order updation for JobId: {0}", navSalesOrder.M4PL_Job_ID), LogType.Error);
			}

			var jobIdList = new System.Collections.Generic.List<long>();
			jobIdList.Add(Convert.ToInt64(navSalesOrder.M4PL_Job_ID));
			_commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);

			return navSalesOrderResponse;
		}

		public static bool DeleteSalesOrderForNAV(ActiveUser activeUser, NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
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
				_logger.Log(exp, string.Format("Error is occuring while Deleting the Sales order: Request Url is: {0}", serviceCall), string.Format("Sales order item delete for Sales Order: {0}.", soNumber), LogType.Error);
			}

			return isRecordDeleted;
		}

		#endregion

		#region Sales Order Item
		public static NavSalesOrderItem GetSalesOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, int lineNo)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesLine('Order', '{2}', {3})", navAPIUrl, "Meridian", soNumber, lineNo);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemReader = new StreamReader(navSalesOrderItemResponseStream))
					{
						string responceString = navSalesOrderItemReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navSalesOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrderItem>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the Sales order item: Request Url is: {0}", serviceCall), string.Format("Sales order item get for Sales Order: {0} and Line number {1}.", soNumber, lineNo), LogType.Error);
			}

			return navSalesOrderItemResponse;
		}

		public static NavSalesOrderItem GenerateSalesOrderItemForNAV(ActiveUser activeUser, NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordUpdated)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string navSalesOrderItemJson = string.Empty;
			string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navSalesOrderItemRequest.M4PLItemId);
			string serviceCall = string.Format("{0}('{1}')/SalesLine", navAPIUrl, "Meridian");
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest salesOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
				salesOrderItemrequest.Credentials = myCredentials;
				salesOrderItemrequest.KeepAlive = false;
				salesOrderItemrequest.ContentType = "application/json";
				salesOrderItemrequest.Method = "POST";
				using (var navSalesOrderItemStreamWriter = new StreamWriter(salesOrderItemrequest.GetRequestStream()))
				{
					navSalesOrderItemJson = JsonConvert.SerializeObject(navSalesOrderItemRequest);
					navSalesOrderItemJson = navSalesOrderItemJson.Replace(dataToRemove, string.Empty);
					navSalesOrderItemStreamWriter.Write(navSalesOrderItemJson);
				}

				WebResponse response = salesOrderItemrequest.GetResponse();

				using (Stream navSalesOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemSyncReader = new StreamReader(navSalesOrderItemResponseStream))
					{
						string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderItemResponseString))
						{
							navSalesOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrderItem>(navSalesOrderItemResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Creating the Sales order Item: Request Url is: {0}, Request body json was {1}", serviceCall, navSalesOrderItemJson), string.Format("Sales order Item Creation for JobId: {0}, Line number: {1}", navSalesOrderItemRequest.M4PL_Job_ID, navSalesOrderItemRequest.Line_No), LogType.Error);
			}

			isRecordUpdated = navSalesOrderItemResponse == null ? false : true;

			return navSalesOrderItemResponse;
		}

		public static NavSalesOrderItem UpdateSalesOrderItemForNAV(ActiveUser activeUser, NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordUpdated)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string navSalesOrderItemJson = string.Empty;
			string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navSalesOrderItemRequest.M4PLItemId);
			string serviceCall = string.Format("{0}('{1}')/SalesLine('Order', '{2}', {3})", navAPIUrl, "Meridian", navSalesOrderItemRequest.Document_No, navSalesOrderItemRequest.Line_No);
			try
			{
				NavSalesOrderItem existingNavSalesOrderItem = GetSalesOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderItemRequest.Document_No, navSalesOrderItemRequest.Line_No);
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest salesOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
				salesOrderItemrequest.Credentials = myCredentials;
				salesOrderItemrequest.KeepAlive = false;
				salesOrderItemrequest.ContentType = "application/json";
				salesOrderItemrequest.Method = "PATCH";
				salesOrderItemrequest.Headers.Add(HttpRequestHeader.IfMatch, existingNavSalesOrderItem.DataETag);
				using (var navSalesOrderItemStreamWriter = new StreamWriter(salesOrderItemrequest.GetRequestStream()))
				{
					navSalesOrderItemJson = JsonConvert.SerializeObject(navSalesOrderItemRequest);
					navSalesOrderItemJson = navSalesOrderItemJson.Replace(dataToRemove, string.Empty);
					navSalesOrderItemStreamWriter.Write(navSalesOrderItemJson);
				}

				WebResponse response = salesOrderItemrequest.GetResponse();

				using (Stream navSalesOrderItemResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemSyncReader = new StreamReader(navSalesOrderItemResponseStream))
					{
						string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderItemResponseString))
						{
							navSalesOrderItemResponse = JsonConvert.DeserializeObject<NavSalesOrderItem>(navSalesOrderItemResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Updating the Sales order Item: Request Url is: {0}, Request body json was {1}", serviceCall, navSalesOrderItemJson), string.Format("Sales order Item updation for JobId: {0}, Line number: {1}", navSalesOrderItemRequest.M4PL_Job_ID, navSalesOrderItemRequest.Line_No), LogType.Error);
			}

			isRecordUpdated = navSalesOrderItemResponse != null ? true : false;

			return navSalesOrderItemResponse;
		}

		public static bool DeleteSalesOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, int lineNo, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}('{1}')/SalesLine('Order', '{2}', {3})", navAPIUrl, "Meridian", soNumber, lineNo);
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
				_logger.Log(exp, string.Format("Error is occuring while Deleting the Sales order item: Request Url is: {0}", serviceCall), string.Format("Sales order item delete for Sales Order: {0} and Line number {1}.", soNumber, lineNo), LogType.Error);
			}

			return isRecordDeleted;
		}

		#endregion

		#region Dimension
		public static NavSalesOrderDimensionResponse GetNavSalesOrderDimension()
		{
			NavSalesOrderDimensionResponse navSalesOrderDimensionValueList = null;
			string serviceCall = string.Format("{0}('{1}')/DimensionValues", M4PBusinessContext.ComponentSettings.NavAPIUrl, "Meridian");
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(M4PBusinessContext.ComponentSettings.NavAPIUserName, M4PBusinessContext.ComponentSettings.NavAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderDimensionStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderDimensionReader = new StreamReader(navSalesOrderDimensionStream))
					{
						string responceString = navSalesOrderDimensionReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navSalesOrderDimensionValueList = Newtonsoft.Json.JsonConvert.DeserializeObject<NavSalesOrderDimensionResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the DimensionValue: Request Url is: {0}", serviceCall), "Get the DimensionValue List From NAV.", LogType.Error);
			}

			return navSalesOrderDimensionValueList;
		}

		#endregion

		#region NAV Item

		public static NAVOrderItemResponse GetNavNAVOrderItemResponse()
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			NAVOrderItemResponse navOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/Items", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			WebResponse response = request.GetResponse();

			using (Stream navOrderItemResponseStream = response.GetResponseStream())
			{
				using (TextReader txtnavOrderItemReader = new StreamReader(navOrderItemResponseStream))
				{
					string responceString = txtnavOrderItemReader.ReadToEnd();

					using (var stringReader = new StringReader(responceString))
					{
						navOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NAVOrderItemResponse>(responceString);
					}
				}
			}

			return navOrderItemResponse;
		}

		#endregion

		#region Helper Method

		public static NavSalesOrder StartOrderCreationProcessForNAV(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, long vendorNo, bool electronicInvoice)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			navSalesOrderRequest.Electronic_Invoice = electronicInvoice;
			NavSalesOrder navSalesOrderResponse = GenerateSalesOrderForNAV(activeUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(activeUser, jobIdList, navSalesOrderResponse.No, null);
				Task.Run(() => { UpdateSalesOrderItemDetails(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag); });
				if (vendorNo > 0)
				{
					Task.Run(() => { NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.No, dimensionCode, divisionCode, electronicInvoice); });
				}
			}

			return navSalesOrderResponse;
		}

		public static NavSalesOrder StartOrderUpdationProcessForNAV(ActiveUser activeUser, List<long> jobIdList, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword, long vendorNo, bool electronicInvoice)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			navSalesOrderRequest.Electronic_Invoice = electronicInvoice;
			NavSalesOrder navSalesOrderResponse = UpdateSalesOrderForNAV(activeUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				Task.Run(() => { UpdateSalesOrderItemDetails(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag); });
				if (vendorNo > 0)
				{
					Task.Run(() =>
					{
						if (string.IsNullOrEmpty(poNumber))
						{

							NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode, electronicInvoice);
						}
						else
						{
							NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(activeUser, jobIdList, poNumber, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode, electronicInvoice);
						}
					});
				}
			}

			return navSalesOrderResponse;
		}

		private static void UpdateSalesOrderItemDetails(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, string soNumber, ref bool allLineItemsUpdated, ref string proFlag)
		{
			List<NavSalesOrderItemRequest> navSalesOrderItemRequest = _commands.GetSalesOrderItemCreationData(activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
			List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobIdList);
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string deleteProFlag = null;
			bool allLineItemsDeleted = true;
			bool isRecordUpdated = true;
			bool isRecordDeleted = true;
			if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
			{
				DeleteNAVSalesOrderItem(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, allLineItemsUpdated, navSalesOrderItemRequest, jobOrderItemMapping, soNumber, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
			}

			if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
			{
				foreach (var navSalesOrderItemRequestItem in navSalesOrderItemRequest)
				{
					navSalesOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
					navSalesOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
					if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && x.LineNumber == navSalesOrderItemRequestItem.Line_No).Any())
					{
						UpdateSalesOrderItemForNAV(activeUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
					}
					else
					{
						navSalesOrderItemResponse = GenerateSalesOrderItemForNAV(activeUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
						if (navSalesOrderItemResponse != null)
						{
							_commands.UpdateJobOrderItemMapping(navSalesOrderItemRequestItem.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), navSalesOrderItemRequestItem.Line_No);
						}
					}

					allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
					isRecordUpdated = true;
					navSalesOrderItemResponse = null;
				}

				proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
				_commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
			}
		}

		private static void DeleteNAVSalesOrderItem(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool allLineItemsUpdated, List<NavSalesOrderItemRequest> navSalesOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, string soNumber, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
		{
			IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = null;
			var deletedItems = navSalesOrderItemRequest?.Select(s => s.Line_No);
			deletedJobOrderItemMapping = deletedItems == null ? deletedJobOrderItemMapping : jobOrderItemMapping.Where(t => t.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && !deletedItems.Contains(t.LineNumber));
			foreach (var deleteItem in deletedJobOrderItemMapping)
			{
				DeleteSalesOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, soNumber, deleteItem.LineNumber, out isRecordDeleted);
				if (isRecordDeleted)
				{
					_commands.DeleteJobOrderItemMapping(deleteItem.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), deleteItem.LineNumber);
				}

				allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
			}

			deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
			_commands.UpdateJobProFlag(activeUser, deleteProFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
		}

		#endregion
	}
}