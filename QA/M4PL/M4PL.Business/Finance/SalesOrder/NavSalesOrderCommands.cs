/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
=============================================================================================================*/
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using M4PL.Business.Common;
using System.Linq;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Business.Finance.PurchaseOrder;

namespace M4PL.Business.Finance.SalesOrder
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

		//to do: need to change
		public NavSalesOrder Patch(NavSalesOrder entity)
		{
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
			List<SalesOrderItem> salesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
			if (salesOrderItemRequest == null || salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)
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

			return NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.No, entity.Quote_No, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			NavSalesOrder manualSalesOrder = null;
			NavSalesOrder electronicSalesOrder = null;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
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

			if ((!entity.Electronic_Invoice || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any())) && !string.IsNullOrEmpty(entity.ElectronicSalesOrderNo))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.ElectronicSalesOrderNo, out isDeleted);
				entity.ElectronicSalesOrderNo = isDeleted ? string.Empty : entity.ElectronicSalesOrderNo;
			}

			if (!string.IsNullOrEmpty(entity.ManualSalesOrderNo) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.ManualSalesOrderNo, out isDeleted);
				entity.ManualSalesOrderNo = isDeleted ? string.Empty : entity.ManualSalesOrderNo;
			}

			if (!entity.Electronic_Invoice || (entity.Electronic_Invoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (entity.Electronic_Invoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
			{
				if (string.IsNullOrEmpty(entity.ManualSalesOrderNo))
				{
					manualSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
				}
				else
				{
					manualSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.ManualSalesOrderNo, entity.ManualPurchaseOrderNo, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
				}
			}
			else
			{
				if (isManualInvoice)
				{
					if (string.IsNullOrEmpty(entity.ManualSalesOrderNo))
					{
						manualSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, false, manualSalesOrderItemRequest);
					}
					else
					{
						manualSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.ManualSalesOrderNo, entity.ManualPurchaseOrderNo, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, false, manualSalesOrderItemRequest);
					}
				}

				if (isElectronicInvoice)
				{
					if (string.IsNullOrEmpty(entity.ElectronicSalesOrderNo))
					{
						electronicSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, true, electronicSalesOrderItemRequest);
					}
					else
					{
						electronicSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.ElectronicSalesOrderNo, entity.ElectronicPurchaseOrderNo, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, true, electronicSalesOrderItemRequest);
					}
				}
			}

			return manualSalesOrder != null ? manualSalesOrder : electronicSalesOrder;
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrderCreationResponse CreateSalesOrderForRollup(List<long> jobIdList)
		{
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			NavSalesOrderCreationResponse navSalesOrderCreationResponse = new NavSalesOrderCreationResponse();
			Entities.Job.Job jobData = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
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

			if ((!jobData.JobElectronicInvoice || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any())) && !string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.JobElectronicInvoiceSONumber, out isDeleted);
				jobData.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobData.JobElectronicInvoiceSONumber;
			}

			if (!string.IsNullOrEmpty(jobData.JobSONumber) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
			{
				bool isDeleted = false;
				NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.JobSONumber, out isDeleted);
				jobData.JobSONumber = isDeleted ? string.Empty : jobData.JobSONumber;
			}

			if (!jobData.JobElectronicInvoice || (jobData.JobElectronicInvoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (jobData.JobElectronicInvoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
			{
				if (string.IsNullOrEmpty(jobData.JobSONumber))
				{
					navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice, salesOrderItemRequest);
				}
				else
				{
					navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobSONumber, jobData.JobPONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice, salesOrderItemRequest);
				}
			}
			else
			{
				if (isManualInvoice)
				{
					if (string.IsNullOrEmpty(jobData.JobSONumber))
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, false, manualSalesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobSONumber, jobData.JobPONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, false, manualSalesOrderItemRequest);
					}
				}

				if (isElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber))
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, true, electronicSalesOrderItemRequest);
					}
					else
					{
						navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobElectronicInvoiceSONumber, jobData.JobElectronicInvoicePONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, true, electronicSalesOrderItemRequest);
					}
				}
			}

			return navSalesOrderCreationResponse;
		}

		public NavSalesOrder UpdateSalesOrderForRollup(List<long> jobIdList)
		{
			List<SalesOrderItem> salesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			NavSalesOrder manualOrder = null;
			NavSalesOrder electronicOrder = null;
			if (salesOrderItemRequest == null || salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)
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

			Entities.Job.Job jobData = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
			if (!string.IsNullOrEmpty(jobData.JobSONumber))
			{
				manualOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobSONumber, jobData.JobPONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, false, manualSalesOrderItemRequest);
			}

			if (!string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber))
			{
				electronicOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobElectronicInvoiceSONumber, jobData.JobPONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, true, electronicSalesOrderItemRequest);
			}

			return manualOrder == null ? electronicOrder : manualOrder;
		}
	}
}
