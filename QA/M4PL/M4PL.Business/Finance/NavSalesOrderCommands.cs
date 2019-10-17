/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
=============================================================================================================*/
using M4PL.Entities.Finance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using System.Net;
using System.IO;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _purchaseCommands = M4PL.DataAccess.Finance.NavPurchaseOrderCommands;

namespace M4PL.Business.Finance
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrder>, INavSalesOrderCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> Get()
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Patch(NavSalesOrder entity)
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			return StartOrderUpdationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), entity.No, entity.Quote_No, navAPIUrl, navAPIUserName, navAPIPassword);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			return StartOrderCreationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), navAPIUrl, navAPIUserName, navAPIPassword);
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder StartOrderCreationProcessForNAV(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrderRequest navSalesOrder = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			NavSalesOrder navSalesOrderResponse = GenerateSalesOrderForNAV(navSalesOrder, navAPIUrl, navAPIUserName, navAPIPassword);
			int line_Number = 10000;
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(ActiveUser, jobId, navSalesOrderResponse.No, null);
				Task.Run(() =>
				{
					List<NavSalesOrderItemRequest> navSalesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobId, Entities.EntitiesAlias.ShippingItem);
					if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
					{
						foreach (var navSalesOrderItemRequestItem in navSalesOrderItemRequest)
						{
							navSalesOrderItemRequestItem.Line_No = line_Number;
							navSalesOrderItemRequestItem.Type = "Item";
							GenerateSalesOrderItemForNAV(navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
							line_Number = line_Number + 1;
						}
					}
				});

				Task.Run(() => { GeneratePurchaseOrderForNAV(jobId, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.No); });
			}

			return navSalesOrderResponse;
		}

		private static NavSalesOrder GenerateSalesOrderForNAV(NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword)
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

		private static NavSalesOrderItem GenerateSalesOrderItemForNAV(NavSalesOrderItemRequest navSalesOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword)
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

		public NavPurchaseOrder GeneratePurchaseOrderForNAV(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
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
				_purchaseCommands.UpdateJobOrderMapping(ActiveUser, jobId, soNumber, navPurchaseOrderResponse.No);
				List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(ActiveUser, jobId, Entities.EntitiesAlias.PurchaseOrderItem);
				if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
				{
					foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
					{
						navPurchaseOrderItemRequestItem.Line_No = line_Number;
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

		public NavSalesOrder StartOrderUpdationProcessForNAV(long jobId, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrderRequest navSalesOrder = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			NavSalesOrder navSalesOrderResponse = UpdateSalesOrderForNAV(navSalesOrder, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			Task.Run(() => 
			{
				if (string.IsNullOrEmpty(poNumber))
				{
					GeneratePurchaseOrderForNAV(jobId, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
				}
				else
				{
					UpdatePurchaseOrderForNAV(jobId, poNumber, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
				}
			});

			return navSalesOrderResponse;
		}

		private static NavSalesOrder UpdateSalesOrderForNAV(NavSalesOrderRequest navSalesOrder, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavSalesOrder navSalesOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/SalesOrder('Order', '{2}')", navAPIUrl, "Meridian", soNumber);
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "PATCH";
			request.Headers.Add(HttpRequestHeader.IfMatch, "JzUyO0pBQUFBQUNMQVFBQUFBSjcvMU1BVHdBd0FEQUFNQUEwQURBQU1BQTFBRFVBTndBQUFBQUE4OzEwNjQxNjIzMDsn");
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

		public NavPurchaseOrder UpdatePurchaseOrderForNAV(long jobId, string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
			NavPurchaseOrder navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "PATCH";
			request.Headers.Add(HttpRequestHeader.IfMatch, "JzUyO0pBQUFBQUNMQVFBQUFBSjcvMU1BVHdBd0FEQUFNQUEwQURBQU1BQTFBRFVBTndBQUFBQUE4OzEwNjQxNjIzMDsn");
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
	}
}
