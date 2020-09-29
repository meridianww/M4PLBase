﻿#region Copyright

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
// Date Programmed:                              10/04/2019
// Program Name:                                 NavSalesOrderCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
//==============================================================================================================
using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities;
using M4PL.Entities.Finance;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;

namespace M4PL.Business.Finance.SalesOrder
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrder>, INavSalesOrderCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
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

		public M4PLOrderCreationResponse GenerateOrderInNav(long jobId)
		{
			Order.NavOrderCommands navOrderRepo = new Order.NavOrderCommands();
			string navAPIURL = M4PLBusinessConfiguration.NavAPIUrl;
			string navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
			string navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
			long customerId = M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong();
			ActiveUser activeUser = ActiveUser;
			M4PLOrderCreationResponse m4PLOrderCreationResponse = new M4PLOrderCreationResponse();
			List<Task> tasks = new List<Task>();
			tasks.Add(Task.Factory.StartNew(() =>
			{
				try
				{
					m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse = navOrderRepo.GenerateSalesOrderInNav(jobId, navAPIURL, navAPIUserName, navAPIPassword, customerId, activeUser);
				}
				catch (Exception exp)
				{
					DataAccess.Logger.ErrorLogger.Log(exp, "Error occured while creating the Sales Order for the job", "GenerateOrderInNav", Utilities.Logger.LogType.Error);
				}
			}));

			tasks.Add(Task.Factory.StartNew(() =>
			{
				try
				{
					m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse = navOrderRepo.GeneratePurchaseOrderInNav(jobId, navAPIURL, navAPIUserName, navAPIPassword, customerId, activeUser);
				}
				catch (Exception exp)
				{
					DataAccess.Logger.ErrorLogger.Log(exp, "Error occured while creating the Purchase Order for the job", "GenerateOrderInNav", Utilities.Logger.LogType.Error);
				}
			}));

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }

			return m4PLOrderCreationResponse;
		}

		public NavSalesOrderCreationResponse CreateOrderInNAVFromM4PLJob(List<long> jobIdList)
		{
			NavSalesOrderCreationResponse result = null;
			Entities.Job.Job jobResult = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
			if (jobResult != null && jobResult.JobCompleted && jobResult.JobDeliveryDateTimeActual.HasValue && jobResult.JobOriginDateTimeActual.HasValue)
			{
				bool isDeliveryChargeRemovalRequired = false;
				if (!string.IsNullOrEmpty(jobResult.JobSONumber) || !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
				{
					isDeliveryChargeRemovalRequired = false;
				}
				else
				{
					isDeliveryChargeRemovalRequired = _jobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				}

				if (isDeliveryChargeRemovalRequired)
				{
					_jobCommands.UpdateJobPriceOrCostCodeStatus(jobResult.Id, (int)StatusType.Delete, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				}

				try
				{
					result = CreateSalesOrderForRollup(jobIdList, jobResult);
				}
				catch (Exception exp)
				{
					M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "Error is occuring while create/update the order in NAV from M4PL.", "CreateOrderInNAVFromM4PLJob", Utilities.Logger.LogType.Error);
				}

				if (isDeliveryChargeRemovalRequired)
				{
					_jobCommands.UpdateJobPriceOrCostCodeStatus((long)jobIdList?.FirstOrDefault(), (int)StatusType.Active, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				}
			}

			return result;
		}

		private NavSalesOrderCreationResponse CreateSalesOrderForRollup(List<long> jobIdList, Entities.Job.Job jobResult)
		{
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			NavSalesOrderCreationResponse navSalesOrderCreationResponse = new NavSalesOrderCreationResponse();
			List<SalesOrderItem> salesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
			if (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))
			{
				isManualInvoice = true;
				isElectronicInvoice = false;
			}
			else if (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0)
			{
				isElectronicInvoice = salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any() ? true : false;
				isManualInvoice = salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any() ? true : false;
				manualSalesOrderItemRequest = isManualInvoice ? salesOrderItemRequest.Where(x => !x.Electronic_Invoice).ToList() : null;
				electronicSalesOrderItemRequest = isElectronicInvoice ? salesOrderItemRequest.Where(x => x.Electronic_Invoice).ToList() : null;
			}

			if ((!jobResult.JobElectronicInvoice || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any())) && !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.JobElectronicInvoiceSONumber, out isDeleted);
				jobResult.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoiceSONumber;
			}

			if (!string.IsNullOrEmpty(jobResult.JobSONumber) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.JobSONumber, out isDeleted);
				jobResult.JobSONumber = isDeleted ? string.Empty : jobResult.JobSONumber;
			}

			if (!jobResult.JobElectronicInvoice || (jobResult.JobElectronicInvoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (jobResult.JobElectronicInvoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
			{
				if (!jobResult.JobElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobSONumber))
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobSONumber, string.IsNullOrEmpty(jobResult.JobCustomerPurchaseOrder) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobCustomerPurchaseOrder, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
				else
				{
					if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobCustomerPurchaseOrder : jobResult.JobElectronicInvoicePONumber, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
			}
			else
			{
				if (isManualInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobSONumber))
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobSONumber, jobResult.JobCustomerPurchaseOrder, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
					}
				}

				if (isElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, jobResult.JobElectronicInvoicePONumber, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
					}
				}
			}

			if (!string.IsNullOrEmpty(jobResult.VendorERPId))
			{
				//Task.Run(() =>
				//{
				NavPurchaseOrderHelper.PurchaseOrderCreationProcessForNAV(ActiveUser, jobIdList, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, jobResult.JobElectronicInvoice);
				//});
			}

			return navSalesOrderCreationResponse;
		}
	}
}