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
using System.Threading.Tasks;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using M4PL.Business.Common;

namespace M4PL.Business.Finance
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrder>, INavSalesOrderCommands
	{
		public string NavAPIUrl
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUrl; }
		}

		public string NavAPIUserName
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUserName; }
		}

		public string NavAPIPassword
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIPassword; }
		}

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
			return StartOrderUpdationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), entity.No, entity.Quote_No, NavAPIUrl, NavAPIUserName, NavAPIPassword);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			return StartOrderCreationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), NavAPIUrl, NavAPIUserName, NavAPIPassword);
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder StartOrderCreationProcessForNAV(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrderRequest navSalesOrder = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.GenerateSalesOrderForNAV(navSalesOrder, navAPIUrl, navAPIUserName, navAPIPassword);
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
							NavSalesOrderHelper.GenerateSalesOrderItemForNAV(navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword);
							line_Number = line_Number + 1;
						}
					}
				});

				Task.Run(() => { NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.No); });
			}

			return navSalesOrderResponse;
		}

		public NavSalesOrder StartOrderUpdationProcessForNAV(long jobId, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			NavSalesOrderRequest navSalesOrder = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.UpdateSalesOrderForNAV(navSalesOrder, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			Task.Run(() =>
			{
				if (string.IsNullOrEmpty(poNumber))
				{
					NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
				}
				else
				{
					NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(ActiveUser, jobId, poNumber, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
				}
			});

			return navSalesOrderResponse;
		}
	}
}
