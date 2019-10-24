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

			_commands.UpdateJobProFlag(activeUser, proFlag, Convert.ToInt64(navSalesOrder.M4PL_Job_ID), Entities.EntitiesAlias.SalesOrder);

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

			_commands.UpdateJobProFlag(activeUser, proFlag, Convert.ToInt64(navSalesOrder.M4PL_Job_ID), Entities.EntitiesAlias.SalesOrder);

			return navSalesOrderResponse;
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
					navSalesOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrderItemRequest);
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
					navSalesOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrderItemRequest);
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
				_logger.Log(exp, string.Format("Error is occuring while Getting the Sales order item: Request Url is: {0}", serviceCall), string.Format("Sales order item get for Sales Order: {0} and Line number {1}.", soNumber, lineNo), LogType.Error);
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
	}
}