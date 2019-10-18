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
using M4PL.Entities.Finance;

namespace M4PL.Business.Finance
{
	/// <summary>
	/// Helper Class To Store the Sales Order Related Methods
	/// </summary>
	public static class NavSalesOrderHelper
	{
		public static NavSalesOrder GetSalesOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
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

			return navSalesOrderResponse;
		}

		public static NavSalesOrder GenerateSalesOrderForNAV(NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "POST";
			using (var streamWriter = new StreamWriter(request.GetRequestStream()))
			{
				string navSalesOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrder);
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

			return navSalesOrderResponse;
		}

		public static NavSalesOrderItem GenerateSalesOrderItemForNAV(NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesLine", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest salesOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
			salesOrderItemrequest.Credentials = myCredentials;
			salesOrderItemrequest.KeepAlive = false;
			salesOrderItemrequest.ContentType = "application/json";
			salesOrderItemrequest.Method = "POST";
			using (var navSalesOrderItemStreamWriter = new StreamWriter(salesOrderItemrequest.GetRequestStream()))
			{
				string navSalesOrderItemJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrderItemRequest);
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

			return navSalesOrderItemResponse;
		}

		public static NavSalesOrder UpdateSalesOrderForNAV(NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			NavSalesOrder existingSalesOrderData = GetSalesOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
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
				string navSalesOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navSalesOrder);
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

			return navSalesOrderResponse;
		}
	}
}
