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

using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Business.Finance.SalesOrder;
using M4PL.Entities;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
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
		public object jobData { get; private set; }

		public M4PLSalesOrderCreationResponse GenerateSalesOrderInNav(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, long customerId, ActiveUser activeUser)
		{
			var jobResult = DataAccess.Job.JobCommands.Get(activeUser, Convert.ToInt64(jobId));
			M4PLSalesOrderCreationResponse m4PLSalesOrderCreationResponse = null;
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
				m4PLSalesOrderCreationResponse = new M4PLSalesOrderCreationResponse();
				jobIdList.Add(jobResult.Id);

				if (!jobResult.IsParentOrder)
				{
					isDeliveryChargeRemovalRequired = DataAccess.Job.JobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), customerId);
					if (isDeliveryChargeRemovalRequired)
					{
						DataAccess.Job.JobCommands.UpdateJobPriceCodeStatus(jobResult.Id, (int)StatusType.Delete, customerId);
					}
					else
					{
						jobResult.IsParentOrder = true;
					}
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
					NavSalesOrderHelper.DeleteSalesOrderForNAV(activeUser, jobResult.Id, true, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoiceSONumber, out isDeleted);
					jobResult.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoiceSONumber;
				}

				if (!string.IsNullOrEmpty(jobResult.JobSONumber) && (!isSalesOrderItemPresent || !isManualInvoice))
				{
					bool isDeleted = false;
					NavSalesOrderHelper.DeleteSalesOrderForNAV(activeUser, jobResult.Id, false, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobSONumber, out isDeleted);
					jobResult.JobSONumber = isDeleted ? string.Empty : jobResult.JobSONumber;
				}

				if (!string.IsNullOrEmpty(jobResult.JobSONumber))
				{
					var existingSalesOrder = NavSalesOrderHelper.GetSalesOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobSONumber);
					if (existingSalesOrder == null)
					{
						DataAccess.Finance.NavSalesOrderCommand.DeleteJobOrderMapping(jobResult.Id, false, EntitiesAlias.SalesOrder.ToString());
						jobResult.JobSONumber = string.Empty;
					}
				}

				if (!string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
				{
					var existingElectronicSalesOrder = NavSalesOrderHelper.GetSalesOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoiceSONumber);
					if (existingElectronicSalesOrder == null)
					{
						DataAccess.Finance.NavSalesOrderCommand.DeleteJobOrderMapping(jobResult.Id, true, Entities.EntitiesAlias.SalesOrder.ToString());
						jobResult.JobElectronicInvoiceSONumber = string.Empty;
					}
				}

				if (!jobResult.JobElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobSONumber))
					{
						m4PLSalesOrderCreationResponse.ManualSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
					else
					{
						m4PLSalesOrderCreationResponse.ManualSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, string.IsNullOrEmpty(jobResult.JobCustomerPurchaseOrder) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
				else if (jobResult.JobElectronicInvoice && (!isSalesOrderItemPresent || !isElectronicInvoice))
				{
					if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
					{
						m4PLSalesOrderCreationResponse.ManualSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest, jobResult.IsParentOrder);
					}
					else
					{
						m4PLSalesOrderCreationResponse.ManualSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobCustomerPurchaseOrder : jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
					}
				}
				else
				{
					if (isManualInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobSONumber))
						{
							m4PLSalesOrderCreationResponse.ManualSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest, jobResult.IsParentOrder);
						}
						else
						{
							m4PLSalesOrderCreationResponse.ManualSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
						}
					}

					if (isElectronicInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
						{
							m4PLSalesOrderCreationResponse.ElectronicSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest, jobResult.IsParentOrder);
						}
						else
						{
							m4PLSalesOrderCreationResponse.ElectronicSalesOrder = SalesOrder.NavSalesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
						}
					}
				}

				if (isDeliveryChargeRemovalRequired)
				{
					DataAccess.Job.JobCommands.UpdateJobPriceCodeStatus((long)jobIdList?.FirstOrDefault(), (int)StatusType.Active, customerId);
				}
			}

			return m4PLSalesOrderCreationResponse;
		}

		public M4PLPurchaseOrderCreationResponse GeneratePurchaseOrderInNav(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, long customerId, ActiveUser activeUser)
		{
			var jobResult = DataAccess.Job.JobCommands.Get(activeUser, Convert.ToInt64(jobId));
			M4PLPurchaseOrderCreationResponse m4PLPurchaseOrderCreationResponse = null;
			if (jobResult != null && jobResult.JobCompleted && jobResult.JobOriginDateTimeActual.HasValue && jobResult.JobDeliveryDateTimeActual.HasValue)
			{
				List<long> jobIdList = new List<long>();
				bool isElectronicInvoice = false;
				bool isManualInvoice = false;
				bool isDeliveryChargeRemovalRequired = false;
				bool isPurchaseItemPresent = false;
				List<PurchaseOrderItem> manualPurchaseOrderItemRequest = null;
				List<PurchaseOrderItem> electronicPurchaseOrderItemRequest = null;
				jobIdList.Add(jobResult.Id);
				m4PLPurchaseOrderCreationResponse = new M4PLPurchaseOrderCreationResponse();
				if(!jobResult.IsParentOrder)
				{
					isDeliveryChargeRemovalRequired = DataAccess.Job.JobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), customerId);
				}

				if (isDeliveryChargeRemovalRequired)
				{
					DataAccess.Job.JobCommands.UpdateJobCostCodeStatus(jobResult.Id, (int)StatusType.Delete, customerId);
				}

				List<PurchaseOrderItem> purchaseOrderItemRequest = DataAccess.Finance.NavSalesOrderCommand.GetPurchaseOrderItemCreationData(activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrderItem);
				isPurchaseItemPresent = purchaseOrderItemRequest?.Any() ?? false;

				isManualInvoice = !isPurchaseItemPresent || (isPurchaseItemPresent && purchaseOrderItemRequest.Any(x => !x.Electronic_Invoice)) ? true : false;
				manualPurchaseOrderItemRequest = isPurchaseItemPresent && isManualInvoice ? purchaseOrderItemRequest.Where(x => !x.Electronic_Invoice).ToList() : null;

				isElectronicInvoice = isPurchaseItemPresent && purchaseOrderItemRequest.Any(x => x.Electronic_Invoice) ? true : false;
				electronicPurchaseOrderItemRequest = isElectronicInvoice ? purchaseOrderItemRequest.Where(x => x.Electronic_Invoice).ToList() : null;

				if (!string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) && (!jobResult.JobElectronicInvoice || !isElectronicInvoice))
				{
					bool isDeleted = false;
					NavPurchaseOrderHelper.DeletePurchaseOrderForNAV(jobResult.JobElectronicInvoicePONumber, jobResult.Id, true, navAPIUrl, navAPIUserName, navAPIPassword, out isDeleted);
					jobResult.JobElectronicInvoicePONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoicePONumber;
				}

				if (!string.IsNullOrEmpty(jobResult.JobPONumber) && (!isManualInvoice || !isPurchaseItemPresent))
				{
					bool isDeleted = false;
					NavPurchaseOrderHelper.DeletePurchaseOrderForNAV(jobResult.JobPONumber, jobResult.Id, false, navAPIUrl, navAPIUserName, navAPIPassword, out isDeleted);
					jobResult.JobPONumber = isDeleted ? string.Empty : jobResult.JobPONumber;
				}

				if (!string.IsNullOrEmpty(jobResult.JobPONumber))
				{
					var existingPurchaseOrder = NavPurchaseOrderHelper.GetPurchaseOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobPONumber);
					if (existingPurchaseOrder == null)
					{
						M4PL.DataAccess.Finance.NavSalesOrderCommand.DeleteJobOrderMapping(jobResult.Id, false, Entities.EntitiesAlias.PurchaseOrder.ToString());
						jobResult.JobPONumber = string.Empty;
					}
				}

				if (!string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber))
				{
					var existingElectronicPurchaseOrder = NavPurchaseOrderHelper.GetPurchaseOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoicePONumber);
					if (existingElectronicPurchaseOrder == null)
					{
						M4PL.DataAccess.Finance.NavSalesOrderCommand.DeleteJobOrderMapping(jobResult.Id, true, Entities.EntitiesAlias.PurchaseOrder.ToString());
						jobResult.JobElectronicInvoicePONumber = string.Empty;
					}
				}

				if (!jobResult.JobElectronicInvoice)
				{
					if (string.IsNullOrEmpty(jobResult.JobPONumber))
					{
						m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoice, purchaseOrderItemRequest);
					}
					else
					{
						m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(activeUser, jobIdList,
							string.IsNullOrEmpty(jobResult.JobPONumber) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoice, purchaseOrderItemRequest);
					}
				}
				else if (jobResult.JobElectronicInvoice && (!isPurchaseItemPresent || !isElectronicInvoice))
				{
					if (string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber))
					{
						m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoice, purchaseOrderItemRequest);
					}
					else
					{
						m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(activeUser, jobIdList,
							string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobPONumber : jobResult.JobElectronicInvoicePONumber,
							navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoice, purchaseOrderItemRequest);
					}
				}
				else
				{
					if (isManualInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobPONumber))
						{
							m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, false, manualPurchaseOrderItemRequest);
						}
						else
						{
							m4PLPurchaseOrderCreationResponse.ManualPurchaseOrder = NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(activeUser, jobIdList, string.IsNullOrEmpty(jobResult.JobPONumber) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, false, manualPurchaseOrderItemRequest);
						}
					}

					if (isElectronicInvoice)
					{
						if (string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber))
						{
							m4PLPurchaseOrderCreationResponse.ElectronicPurchaseOrder = NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, true, electronicPurchaseOrderItemRequest);
						}
						else
						{
							m4PLPurchaseOrderCreationResponse.ElectronicPurchaseOrder = NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(activeUser, jobIdList, !string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, true, electronicPurchaseOrderItemRequest);
						}
					}
				}

				if (isDeliveryChargeRemovalRequired)
				{
					DataAccess.Job.JobCommands.UpdateJobCostCodeStatus((long)jobIdList?.FirstOrDefault(), (int)StatusType.Active, customerId);
				}
			}

			return m4PLPurchaseOrderCreationResponse;
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