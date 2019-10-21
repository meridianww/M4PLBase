/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/18/2019
Program Name:                                 NavSalesOrderHelper
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderHelper
=============================================================================================================*/

using M4PL.Entities.Finance;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.IO;
using System.Net;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _purchaseCommands = M4PL.DataAccess.Finance.NavPurchaseOrderCommands;

namespace M4PL.Business.Finance
{
	/// <summary>
	/// Helper Class To Store the Purchase Order Related Methods
	/// </summary>
	public static class NavPurchaseOrderHelper
	{
		public static NavPurchaseOrder GeneratePurchaseOrderForNAV(ActiveUser activeUser, long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, string dimensionCode, string divisionCode)
		{
			NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
			if (navPurchaseOrderRequest == null) { return null; }
			navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavPurchaseOrder navPurchaseOrderResponse = null;
			int line_Number = 10000;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "POST";
			using (var streamWriter = new StreamWriter(request.GetRequestStream()))
			{
				string navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
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
				if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
				{
					foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
					{
						navPurchaseOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
						navPurchaseOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
						navPurchaseOrderItemRequestItem.Line_No = line_Number;
						navPurchaseOrderItemRequestItem.Type = "Item";
						GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
						line_Number = line_Number + 1;
					}
				}
			}

			return navPurchaseOrderResponse;
		}

		private static NavPurchaseOrderItem GeneratePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseLine", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest navPurchaseOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
			navPurchaseOrderItemrequest.Credentials = myCredentials;
			navPurchaseOrderItemrequest.KeepAlive = false;
			navPurchaseOrderItemrequest.ContentType = "application/json";
			navPurchaseOrderItemrequest.Method = "POST";
			using (var navPurchaseOrderItemStreamWriter = new StreamWriter(navPurchaseOrderItemrequest.GetRequestStream()))
			{
				string navPurchaseOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderItemRequest);
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

			return navPurchaseOrderItemResponse;
		}

		public static NavPurchaseOrder UpdatePurchaseOrderForNAV(ActiveUser activeUser, long jobId, string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, string dimensionCode, string divisionCode)
		{
			NavPurchaseOrder existingSalesOrderData = GetPurchaseOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, poNumer);
			NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
			if (navPurchaseOrderRequest == null) { return null; }
			navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "PATCH";
			request.Headers.Add(HttpRequestHeader.IfMatch, existingSalesOrderData.DataETag);
			using (var streamWriter = new StreamWriter(request.GetRequestStream()))
			{
				string navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
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

			////if (navPurchaseOrderResponse != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.No))
			////{
			////	_purchaseCommands.UpdateJobOrderMapping(ActiveUser, jobId, soNumber, navPurchaseOrderResponse.No);
			////	List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(ActiveUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem);
			////	if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
			////	{
			////		foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
			////		{
			////			navPurchaseOrderItemRequestItem.Line_No = line_Number;
			////			GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
			////			line_Number = line_Number + 1;
			////		}
			////	}
			////}

			return navPurchaseOrderResponse;
		}

		public static NavPurchaseOrder GetPurchaseOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber)
		{
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumber);
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

			return navPurchaseOrderResponse;
		}
	}
}
