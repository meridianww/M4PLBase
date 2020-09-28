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
// Date Programmed:                              07/31/2019
// Program Name:                                 NavPriceCodeCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPriceCodeCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Business.Finance.Order
{
	public class NavOrderCommands : BaseCommands<NavSalesOrderResponse>, INavOrderCommands
	{
		public void GenerateSalesOrderInNav(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, long customerId, ActiveUser activeUser)
		{
			var jobResult = DataAccess.Job.JobCommands.Get(ActiveUser, Convert.ToInt64(jobId));
			// Start Sales Order Creation Process Only When JobOriginDateTimeActual and JobDeliveryDateTimeActual are not null.
			if (jobResult != null && jobResult.JobCompleted && jobResult.JobOriginDateTimeActual.HasValue && jobResult.JobDeliveryDateTimeActual.HasValue)
			{
				bool isDeliveryChargeRemovalRequired = false;
				bool isElectronicInvoice = false;
				bool isManualInvoice = false;
				bool isSalesOrderItemPresent = false;
				List<SalesOrderItem> manualSalesOrderItemRequest = null;
				List<SalesOrderItem> electronicSalesOrderItemRequest = null;
				List<long> jobIdList = new List<long>();
				jobIdList.Add(jobResult.Id);
				// If This is a Sales Order Update Process then no need to check the Delivery Charge Logic.
				if (!string.IsNullOrEmpty(jobResult.JobSONumber) || !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
				{
					isDeliveryChargeRemovalRequired = false;
				}
				else
				{
					isDeliveryChargeRemovalRequired = DataAccess.Job.JobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), customerId);
				}

				if (isDeliveryChargeRemovalRequired)
				{
					DataAccess.Job.JobCommands.UpdateJobPriceCodeStatus(jobResult.Id, (int)StatusType.Delete, customerId);
				}

				List<SalesOrderItem> salesOrderItemRequest = DataAccess.Finance.NavSalesOrderCommand.GetSalesOrderItemCreationData(activeUser, jobIdList, EntitiesAlias.ShippingItem);
				isSalesOrderItemPresent = salesOrderItemRequest?.Any() ?? false;
				isManualInvoice = !isSalesOrderItemPresent || (isSalesOrderItemPresent && salesOrderItemRequest.Any(x => !x.Electronic_Invoice)) ? true : false;
				manualSalesOrderItemRequest = isSalesOrderItemPresent && isManualInvoice ? salesOrderItemRequest.Where(x => !x.Electronic_Invoice).ToList() : null;
				isElectronicInvoice = isSalesOrderItemPresent && salesOrderItemRequest.Any(x => x.Electronic_Invoice) ? true : false;
				electronicSalesOrderItemRequest = isElectronicInvoice ? salesOrderItemRequest.Where(x => x.Electronic_Invoice).ToList() : null;

				if (!string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber) && (!jobResult.JobElectronicInvoice || !isElectronicInvoice))
				{
					bool isDeleted = false;
					SalesOrder.NavSalesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoiceSONumber, out isDeleted);
					jobResult.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoiceSONumber;
				}

				if (!string.IsNullOrEmpty(jobResult.JobSONumber) && (!isSalesOrderItemPresent || !isManualInvoice))
				{
					bool isDeleted = false;
					SalesOrder.NavSalesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobSONumber, out isDeleted);
					jobResult.JobSONumber = isDeleted ? string.Empty : jobResult.JobSONumber;
				}

				if (!jobResult.JobElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobSONumber))
					{
						SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
					else
					{
						SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, string.IsNullOrEmpty(jobResult.JobCustomerPurchaseOrder) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
				else if (jobResult.JobElectronicInvoice && (!isSalesOrderItemPresent || !isElectronicInvoice))
				{
					if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
					{
						SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
					else
					{
						SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobCustomerPurchaseOrder : jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
				else
				{
					if (isManualInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobSONumber))
						{
							SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
						}
						else
						{
							SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
						}
					}

					if (isElectronicInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
						{
							SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
						}
						else
						{
							SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
						}
					}
				}

				if (isDeliveryChargeRemovalRequired)
				{
					DataAccess.Job.JobCommands.UpdateJobPriceCodeStatus((long)jobIdList?.FirstOrDefault(), (int)StatusType.Active, customerId);
				}
			}
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrderResponse Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrderResponse> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrderResponse Patch(NavSalesOrderResponse entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrderResponse Post(NavSalesOrderResponse entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrderResponse Put(NavSalesOrderResponse entity)
		{
			throw new NotImplementedException();
		}
	}
}