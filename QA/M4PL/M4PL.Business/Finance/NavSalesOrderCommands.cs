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
			return CreateSalesOrderForNAV(id);
		}

		public IList<NavSalesOrder> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Patch(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder CreateSalesOrderForNAV(long jobId)
		{
			NavSalesOrderRequest navSalesOrder = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			NavSalesOrder navSalesOrderResponse = GenerateSalesOrderForNAV(navSalesOrder);
			int line_Number = 10000;
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(ActiveUser, jobId, navSalesOrderResponse.No, null);
				List<NavSalesOrderItemRequest> navSalesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobId, Entities.EntitiesAlias.ShippingItem);
				if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
				{
					foreach (var navSalesOrderItemRequestItem in navSalesOrderItemRequest)
					{
						navSalesOrderItemRequestItem.Line_No = line_Number;
						GenerateSalesOrderItemForNAV(navSalesOrderItemRequestItem);
						line_Number = line_Number + 1;
					}
				}

				////Task.Run(() => { CreatePurchaseOrderForNAV(jobId, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.NavSalesOrder.No); });
			}

			return navSalesOrderResponse;
		}

		private static NavSalesOrder GenerateSalesOrderForNAV(NavSalesOrderRequest navSalesOrder)
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
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

		private static NavSalesOrderItem GenerateSalesOrderItemForNAV(NavSalesOrderItemRequest navSalesOrderItemRequest)
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
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

		public NavPurchaseOrder CreatePurchaseOrderForNAV(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber)
		{
			NavPurchaseOrder navPurchaseOrder = _purchaseCommands.GetRecordDataFromDatabase(ActiveUser, jobId, Entities.EntitiesAlias.PurchaseOrder);
			NavPurchaseOrderResponse navPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder", navAPIUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			request.ContentType = "application/json";
			request.Method = "POST";
			using (var streamWriter = new StreamWriter(request.GetRequestStream()))
			{
				string navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrder);
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
						navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderResponse>(responceString);
					}
				}
			}

			if (navPurchaseOrderResponse != null && navPurchaseOrderResponse.NavPurchaseOrder != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.NavPurchaseOrder.No))
			{
				_purchaseCommands.UpdateJobOrderMapping(ActiveUser, jobId, soNumber, navPurchaseOrderResponse.NavPurchaseOrder.No);
			}

			return navPurchaseOrder;
		}
	}
}
