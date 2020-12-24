#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/18/2019
// Program Name:                                 NavSalesOrderHelper
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderHelper
//==============================================================================================================

using M4PL.Business.Common;
using M4PL.Entities;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.SalesOrderDimension;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using M4PL.Utilities.Logger;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.Business.Finance.SalesOrder
{
	/// <summary>
	/// Helper Class To Store the Sales Order Related Methods
	/// </summary>
	public static class NavSalesOrderHelper
	{
		public static BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		#region Sales Order

		public static NavJobSalesOrder GetSalesOrderFromNavByJobId(string navAPIUrl, string navAPIUserName, string navAPIPassword, long jobId)
		{
			NavJobSalesOrder navJobSalesOrderResponse = null;
			string serviceCall = string.Format("{0}/SalesOrder?$filter=M4PL_Job_ID eq '{1}'", navAPIUrl, jobId);
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
							navJobSalesOrderResponse = JsonConvert.DeserializeObject<NavJobSalesOrder>(navSalesOrderResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the Sales order Details by JobId: Request Url is: {0}.", serviceCall), string.Format("Get the Sales Order Information for JobId: {0}", jobId), LogType.Error);
			}

			return navJobSalesOrderResponse;
		}

		public static NavSalesOrder GetSalesOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}/SalesOrder('Order', '{1}')", navAPIUrl, soNumber);
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
			Newtonsoft.Json.Linq.JObject jsonObject = null;
			string serviceCall = string.Format("{0}/SalesOrder", navAPIUrl);
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
					navSalesOrderJson = JsonConvert.SerializeObject(navSalesOrder);
					jsonObject = (Newtonsoft.Json.Linq.JObject)JsonConvert.DeserializeObject(navSalesOrderJson);
					jsonObject.Property("Ship_from_City").Remove();
					jsonObject.Property("Ship_from_County").Remove();
					navSalesOrderJson = jsonObject.ToString();
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
			Newtonsoft.Json.Linq.JObject jsonObject = null;
			string serviceCall = string.Format("{0}/SalesOrder('Order', '{1}')", navAPIUrl, soNumber);
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
					navSalesOrderJson = JsonConvert.SerializeObject(navSalesOrder);
					jsonObject = (Newtonsoft.Json.Linq.JObject)JsonConvert.DeserializeObject(navSalesOrderJson);
					jsonObject.Property("Ship_from_City").Remove();
					jsonObject.Property("Ship_from_County").Remove();
					navSalesOrderJson = jsonObject.ToString();
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

		public static bool DeleteSalesOrderForNAV(ActiveUser activeUser, long jobId, bool isElectronicInvoice, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}/SalesOrder('Order', '{1}')", navAPIUrl, soNumber);
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
				if (isRecordDeleted)
				{
					_commands.DeleteJobOrderMapping(jobId, isElectronicInvoice, Entities.EntitiesAlias.SalesOrder.ToString());
				}
			}
			catch (Exception exp)
			{
				isRecordDeleted = false;
				_logger.Log(exp, string.Format("Error is occuring while Deleting the Sales order: Request Url is: {0}", serviceCall), string.Format("Sales order item delete for Sales Order: {0}.", soNumber), LogType.Error);
			}

			return isRecordDeleted;
		}

		#endregion Sales Order

		#region Sales Order Item

		public static NavSalesOrderItem GetSalesOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, int lineNo)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string serviceCall = string.Format("{0}/SalesLine('Order', '{1}', {2})", navAPIUrl, soNumber, lineNo);
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

		public static NavSalesOrderItem GenerateSalesOrderItemForNAV(ActiveUser activeUser, NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, List<long> jobIdList, out bool isRecordUpdated)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string navSalesOrderItemJson = string.Empty;
			string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navSalesOrderItemRequest.M4PLItemId);
			string serviceCall = string.Format("{0}/SalesLine", navAPIUrl);
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

			if (navSalesOrderItemResponse != null)
			{
				_commands.UpdateJobOrderItemMapping(navSalesOrderItemRequest.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), navSalesOrderItemRequest.Line_No, navSalesOrderItemRequest.Document_No);
			}

			return navSalesOrderItemResponse;
		}

		public static NavSalesOrderItem UpdateSalesOrderItemForNAV(ActiveUser activeUser, NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, List<long> jobIdList, out bool isRecordUpdated)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string navSalesOrderItemJson = string.Empty;
			string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navSalesOrderItemRequest.M4PLItemId);
			string serviceCall = string.Format("{0}/SalesLine('Order', '{1}', {2})", navAPIUrl, navSalesOrderItemRequest.Document_No, navSalesOrderItemRequest.Line_No);
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

			if (navSalesOrderItemResponse != null)
			{
				_commands.UpdateJobOrderItemMapping(navSalesOrderItemRequest.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), navSalesOrderItemRequest.Line_No, navSalesOrderItemRequest.Document_No);
			}

			return navSalesOrderItemResponse;
		}

		public static bool DeleteSalesOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, int lineNo, out bool isRecordDeleted)
		{
			string serviceCall = string.Format("{0}/SalesLine('Order', '{1}', {2})", navAPIUrl, soNumber, lineNo);
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

		#endregion Sales Order Item

		#region Dimension

		public static NavSalesOrderDimensionResponse GetNavSalesOrderDimension(string userName, string password, string serviceUrl)
		{
			NavSalesOrderDimensionResponse navSalesOrderDimensionValueList = null;
			string serviceCall = string.Format("{0}/DimensionValues", serviceUrl);
			try
			{
				navSalesOrderDimensionValueList = new NavSalesOrderDimensionResponse();
				NetworkCredential myCredentials = new NetworkCredential(userName, password);
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
							navSalesOrderDimensionValueList = JsonConvert.DeserializeObject<NavSalesOrderDimensionResponse>(responceString);
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

		public static NavSalesOrderPostedInvoiceResponse GetNavPostedSalesOrderResponse(string username, string password, string serviceUrl)
		{
			NavSalesOrderPostedInvoiceResponse navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}/PostedSalesInvoice", serviceUrl);
			try
			{
				navSalesOrderResponse = new NavSalesOrderPostedInvoiceResponse();
				NetworkCredential myCredentials = new NetworkCredential(username, password);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderReader = new StreamReader(navSalesOrderStream))
					{
						string responceString = navSalesOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navSalesOrderResponse = JsonConvert.DeserializeObject<NavSalesOrderPostedInvoiceResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the PostedSalesInvoice: Request Url is: {0}", serviceCall), "Get the PostedSalesInvoice List From NAV.", LogType.Error);
			}

			return navSalesOrderResponse;
		}

		public static NavPurchaseOrderPostedInvoiceResponse GetNavPostedPurchaseOrderResponse(string username, string password, string serviceUrl)
		{
			NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}/PostedPurchaseInvoice", serviceUrl);
			try
			{
				navPurchaseOrderResponse = new NavPurchaseOrderPostedInvoiceResponse();
				NetworkCredential myCredentials = new NetworkCredential(username, password);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderStream))
					{
						string responceString = navPurchaseOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderResponse = JsonConvert.DeserializeObject<NavPurchaseOrderPostedInvoiceResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the PostedPurchaseInvoice: Request Url is: {0}", serviceCall), "Get the PostedPurchaseInvoice List From NAV.", LogType.Error);
			}

			return navPurchaseOrderResponse;
		}

		public static NavPurchaseOrderPostedInvoiceResponse GetNavPostedPurchaseInvoiceResponse(string username, string password, string serviceUrl, string documentNumber)
		{
			NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}/PostedPurchaseInvoice?$filter=No eq '{1}'", serviceUrl, documentNumber);
			try
			{
				navPurchaseOrderResponse = new NavPurchaseOrderPostedInvoiceResponse();
				NetworkCredential myCredentials = new NetworkCredential(username, password);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderStream))
					{
						string responceString = navPurchaseOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderResponse = JsonConvert.DeserializeObject<NavPurchaseOrderPostedInvoiceResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the PostedPurchaseInvoice: Request Url is: {0}", serviceCall), "Get the PostedPurchaseInvoice List From NAV.", LogType.Error);
			}

			return navPurchaseOrderResponse;
		}

		public static NavSalesOrderItemResponse GetNavPostedSalesOrderItemResponse(string username, string password, string serviceUrl)
		{
			NavSalesOrderItemResponse navSalesOrderItemResponse = null;
			string serviceCall = string.Format("{0}/PostedSalesInvoiceLines", serviceUrl);
			try
			{
				navSalesOrderItemResponse = new NavSalesOrderItemResponse();
				NetworkCredential myCredentials = new NetworkCredential(username, password);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderItemStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderItemReader = new StreamReader(navSalesOrderItemStream))
					{
						string responceString = navSalesOrderItemReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navSalesOrderItemResponse = JsonConvert.DeserializeObject<NavSalesOrderItemResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the PostedSalesInvoiceLines: Request Url is: {0}", serviceCall), "Get the PostedSalesInvoiceLines List From NAV.", LogType.Error);
			}

			return navSalesOrderItemResponse;
		}

		public static NavPurchaseOrderItemResponse GetNavPostedPurchaseOrderItemResponse(string username, string password, string serviceUrl)
		{
			NavPurchaseOrderItemResponse navPurchaseOrderItemResponse = null;
			string serviceCall = string.Format("{0}/PostedPurchaseInvoiceLines", serviceUrl);
			try
			{
				navPurchaseOrderItemResponse = new NavPurchaseOrderItemResponse();
				NetworkCredential myCredentials = new NetworkCredential(username, password);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navPurchaseOrderItemStream = response.GetResponseStream())
				{
					using (TextReader navPurchaseOrderItemReader = new StreamReader(navPurchaseOrderItemStream))
					{
						string responceString = navPurchaseOrderItemReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPurchaseOrderItemResponse = JsonConvert.DeserializeObject<NavPurchaseOrderItemResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the PostedPurchaseInvoiceLines: Request Url is: {0}", serviceCall), "Get the PostedPurchaseInvoiceLines List From NAV.", LogType.Error);
			}

			return navPurchaseOrderItemResponse;
		}

		#endregion Dimension

		#region NAV Item

		public static NAVOrderItemResponse GetNavNAVOrderItemResponse()
		{
			NAVOrderItemResponse navOrderItemResponse = null;
			CustomerNavConfiguration currentCustomerNavConfiguration = null;
			string navAPIPassword;
			string navAPIUserName;
			string navAPIUrl;
			////if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
			////{
			////	currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
			////	navAPIUrl = currentCustomerNavConfiguration.ServiceUrl;
			////	navAPIUserName = currentCustomerNavConfiguration.ServiceUserName;
			////	navAPIPassword = currentCustomerNavConfiguration.ServicePassword;
			////}
			////else
			////{
				navAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
				navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
				navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
			////}

			try
			{
				string serviceCall = string.Format("{0}/Items", navAPIUrl);
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
							navOrderItemResponse = JsonConvert.DeserializeObject<NAVOrderItemResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error is occuring while getting NAV Order Item Response.", "GetNavNAVOrderItemResponse", LogType.Error);
			}

			return navOrderItemResponse;
		}

		#endregion NAV Item

		#region Helper Method

		public static NavSalesOrder StartOrderCreationProcessForNAV(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string vendorNo, bool electronicInvoice, List<SalesOrderItem> salesOrderItemRequest, bool isParentOrder = true)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues(navAPIUserName, navAPIPassword, navAPIUrl);
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISION" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISION" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
					: string.Empty;

                //dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Code) && x.Code.Equals(navSalesOrderRequest.Ship_from_Code, StringComparison.OrdinalIgnoreCase)).Any()
                //    ? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Code) && x.Code.Equals(navSalesOrderRequest.Ship_from_Code, StringComparison.OrdinalIgnoreCase)).FirstOrDefault().Dimension_Code
                //    : string.Empty;

                //if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
                //{
                //	string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
                //	if (!string.IsNullOrEmpty(dimensionMatchCode))
                //	{
                //		dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
                //		dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
                //	}
                //}
            }

			dimensionCode = navSalesOrderRequest.Ship_from_Code;
			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			navSalesOrderRequest.Electronic_Invoice = electronicInvoice;
			NavSalesOrder navSalesOrderResponse = GenerateSalesOrderForNAV(activeUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(activeUser, jobIdList, navSalesOrderResponse.No, electronicInvoice, isParentOrder);
				salesOrderItemRequest.ForEach(x => x.Document_No = navSalesOrderResponse.No);
				UpdateSalesOrderItemDetails(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag, electronicInvoice, salesOrderItemRequest);
			}

			return navSalesOrderResponse;
		}

		public static NavSalesOrder StartOrderUpdationProcessForNAV(ActiveUser activeUser, List<long> jobIdList, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword, string vendorNo, bool electronicInvoice, List<SalesOrderItem> salesOrderItemRequest)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues(navAPIUserName, navAPIPassword, navAPIUrl);
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				//divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISION" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
				//	? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISION" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
				//	: string.Empty;

                dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Code) && x.Code.Equals(navSalesOrderRequest.Ship_from_Code, StringComparison.OrdinalIgnoreCase)).Any()
                    ? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Code) && x.Code.Equals(navSalesOrderRequest.Ship_from_Code, StringComparison.OrdinalIgnoreCase)).FirstOrDefault().Dimension_Code
                    : string.Empty;

                //if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
                //{
                //string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
                //if (!string.IsNullOrEmpty(dimensionMatchCode))
                //{
                //	dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
                //	dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
                //}
                //}
            }

			dimensionCode = navSalesOrderRequest.Ship_from_Code;
			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			navSalesOrderRequest.Electronic_Invoice = electronicInvoice;
			NavSalesOrder navSalesOrderResponse = UpdateSalesOrderForNAV(activeUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				salesOrderItemRequest.ForEach(x => x.Document_No = navSalesOrderResponse.No);
				//Task.Run(() =>
				//{
				UpdateSalesOrderItemDetails(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag, electronicInvoice, salesOrderItemRequest);
				//});
			}

			return navSalesOrderResponse;
		}

		private static void UpdateSalesOrderItemDetails(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, string soNumber, ref bool allLineItemsUpdated, ref string proFlag, bool isElectronicInvoice, List<SalesOrderItem> salesOrderItemRequest)
		{
			List<NavSalesOrderItemRequest> navSalesOrderItemRequest = null;
			if (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0)
			{
				navSalesOrderItemRequest = new List<NavSalesOrderItemRequest>();
				salesOrderItemRequest.ToList().ForEach(x => navSalesOrderItemRequest.Add(new NavSalesOrderItemRequest()
				{
					No = x.No,
					M4PLItemId = x.M4PLItemId,
					Qty_to_Invoice = x.Qty_to_Invoice,
					Qty_to_Ship = x.Qty_to_Ship,
					Quantity = x.Quantity,
					Planned_Delivery_Date = x.Planned_Delivery_Date,
					Shipment_Date = x.Shipment_Date,
					Planned_Shipment_Date = x.Planned_Shipment_Date,
					M4PL_Job_ID = x.M4PL_Job_ID,
					FilteredTypeField = x.FilteredTypeField,
					Document_No = x.Document_No,
					Line_No = x.Line_No,
					Type = x.Type,
					Shortcut_Dimension_1_Code = x.Shortcut_Dimension_1_Code,
					Shortcut_Dimension_2_Code = x.Shortcut_Dimension_2_Code
				}));
			}

			List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobIdList, Entities.EntitiesAlias.SalesOrder, isElectronicInvoice);
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string deleteProFlag = null;
			bool allLineItemsDeleted = true;
			bool isRecordUpdated = true;
			bool isRecordDeleted = true;
			if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
			{
				DeleteNAVSalesOrderItem(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, isElectronicInvoice, allLineItemsUpdated, navSalesOrderItemRequest, jobOrderItemMapping, soNumber, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
			}

			if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
			{
				foreach (var navSalesOrderItemRequestItem in navSalesOrderItemRequest)
				{
					navSalesOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
					navSalesOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
					if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && x.LineNumber == navSalesOrderItemRequestItem.Line_No && x.Document_Number == navSalesOrderItemRequestItem.Document_No).Any())
					{
						navSalesOrderItemResponse = UpdateSalesOrderItemForNAV(activeUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, jobIdList, out isRecordUpdated);
					}
					else
					{
						navSalesOrderItemResponse = GenerateSalesOrderItemForNAV(activeUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, jobIdList, out isRecordUpdated);
					}

					allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
					isRecordUpdated = true;
					navSalesOrderItemResponse = null;
				}

				proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
				_commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
			}
		}

		private static void DeleteNAVSalesOrderItem(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool isElectronicInvoice, bool allLineItemsUpdated, List<NavSalesOrderItemRequest> navSalesOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, string soNumber, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
		{
			IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = null;
			var deletedItems = navSalesOrderItemRequest?.Select(s => s.Line_No);
			deletedJobOrderItemMapping = deletedItems == null ? deletedJobOrderItemMapping : jobOrderItemMapping.Where(t => !deletedItems.Contains(t.LineNumber));
			foreach (var deleteItem in deletedJobOrderItemMapping)
			{
				DeleteSalesOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, soNumber, deleteItem.LineNumber, out isRecordDeleted);
				if (isRecordDeleted)
				{
					_commands.DeleteJobOrderItemMapping(deleteItem.JobOrderItemMappingId);
				}

				allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
			}

			deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
			_commands.UpdateJobProFlag(activeUser, deleteProFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
		}

		#endregion Helper Method

		public static void UpdateSalesOrderInformationInDB(string manualSalesOrderId, string electronicSalesOrderId, long jobId, bool isManualUpdate, bool isElectronicUpdate, ActiveUser activeUser)
		{
			_commands.UpdateSalesOrderInformationInDB(jobId, manualSalesOrderId, electronicSalesOrderId, isManualUpdate, isElectronicUpdate, activeUser);
		}
	}
}