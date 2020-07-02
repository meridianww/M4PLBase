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
// Date Programmed:                              10/04/2019
// Program Name:                                 NavSalesOrderCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
//==============================================================================================================
using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;

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
			NavSalesOrder result = null;
			bool isDeliveryChargeRemovalRequired = false;
			//NavJobSalesOrder navJobSalesOrder = NavSalesOrderHelper.GetSalesOrderFromNavByJobId(NavAPIUrl, NavAPIUserName, NavAPIPassword, Convert.ToInt64(entity.M4PL_Job_ID));
			//SyncSalesOrderDetailsFromNav(entity, navJobSalesOrder);

			if (!string.IsNullOrEmpty(entity.ElectronicSalesOrderNo) || !string.IsNullOrEmpty(entity.ManualSalesOrderNo))
			{
				isDeliveryChargeRemovalRequired = false;
			}
			else
			{
				isDeliveryChargeRemovalRequired = _jobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(entity.M4PL_Job_ID), M4PBusinessContext.ComponentSettings.ElectroluxCustomerId);
			}

			if (isDeliveryChargeRemovalRequired)
			{
				_jobCommands.UpdateJobPriceOrCostCodeStatus(Convert.ToInt64(entity.M4PL_Job_ID), (int)StatusType.Delete);
			}

			try
			{
				result = GenerateNAVOrderFromM4PLUI(entity);
			}
			catch (Exception exp)
			{
				M4PL.DataAccess.Logger.ErrorLogger.Log(exp, "Error is occuring while create/update the order in NAV from M4PL UI.", "Post", Utilities.Logger.LogType.Error);
			}

			if (isDeliveryChargeRemovalRequired)
			{
				_jobCommands.UpdateJobPriceOrCostCodeStatus(Convert.ToInt64(entity.M4PL_Job_ID), (int)StatusType.Active);
			}

			return result;
		}

		private void SyncSalesOrderDetailsFromNav(NavSalesOrder entity, NavJobSalesOrder navJobSalesOrder)
		{
			if (navJobSalesOrder != null && navJobSalesOrder?.NavSalesOrder?.Count > 0)
			{
				bool isManualDelete = false;
				bool isElectronicDelete = false;
				bool isManualUpdate = false;
				bool isElectronicUpdate = false;
				string manualSalesOrderId = navJobSalesOrder.NavSalesOrder.Where(x => !x.Electronic_Invoice).Any() ? navJobSalesOrder.NavSalesOrder.Where(x => !x.Electronic_Invoice).FirstOrDefault().No : null;
				string electronicSalesOrderId = navJobSalesOrder.NavSalesOrder.Where(x => x.Electronic_Invoice).Any() ? navJobSalesOrder.NavSalesOrder.Where(x => x.Electronic_Invoice).FirstOrDefault().No : null;
				if (string.IsNullOrEmpty(entity.ManualSalesOrderNo) && !string.IsNullOrEmpty(manualSalesOrderId))
				{
					entity.ManualSalesOrderNo = manualSalesOrderId;
					isManualUpdate = true;
				}
				else if (!string.IsNullOrEmpty(entity.ManualSalesOrderNo) && string.IsNullOrEmpty(manualSalesOrderId))
				{
					isManualUpdate = true;
					isManualDelete = true;
					entity.ManualSalesOrderNo = null;
				}
				else if (!string.IsNullOrEmpty(entity.ManualSalesOrderNo) && !string.IsNullOrEmpty(manualSalesOrderId) && !entity.ManualSalesOrderNo.Equals(manualSalesOrderId))
				{
					isManualUpdate = true;
					entity.ManualSalesOrderNo = manualSalesOrderId;
				}

				if (string.IsNullOrEmpty(entity.ElectronicSalesOrderNo) && !string.IsNullOrEmpty(electronicSalesOrderId))
				{
					isElectronicUpdate = true;
					entity.ElectronicSalesOrderNo = electronicSalesOrderId;
				}
				else if (!string.IsNullOrEmpty(entity.ElectronicSalesOrderNo) && string.IsNullOrEmpty(electronicSalesOrderId))
				{
					isElectronicUpdate = true;
					isElectronicDelete = true;
					entity.ElectronicSalesOrderNo = null;
				}
				else if (!string.IsNullOrEmpty(entity.ElectronicSalesOrderNo) && !string.IsNullOrEmpty(electronicSalesOrderId) && !entity.ElectronicSalesOrderNo.Equals(electronicSalesOrderId))
				{
					isElectronicUpdate = true;
					entity.ElectronicSalesOrderNo = electronicSalesOrderId;
				}

				if (isElectronicUpdate || isManualUpdate)
				{
					NavSalesOrderHelper.UpdateSalesOrderInformationInDB(entity.ManualSalesOrderNo, entity.ElectronicSalesOrderNo, Convert.ToInt64(entity.M4PL_Job_ID), isManualDelete ? false : true, isElectronicDelete ? false : true, ActiveUser);
				}
			}
		}

		public NavSalesOrder Put(NavSalesOrder entity)
        {
            throw new NotImplementedException();
        }

        public NavSalesOrderCreationResponse CreateOrderInNAVFromM4PLJob(List<long> jobIdList)
        {
            NavSalesOrderCreationResponse result = null;
            Entities.Job.Job jobResult = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
            bool isDeliveryChargeRemovalRequired = false;
            if (!string.IsNullOrEmpty(jobResult.JobSONumber) || !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
            {
                isDeliveryChargeRemovalRequired = false;
            }
            else
            {
                isDeliveryChargeRemovalRequired = _jobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), M4PBusinessContext.ComponentSettings.ElectroluxCustomerId);
            }

            if (isDeliveryChargeRemovalRequired)
            {
                _jobCommands.UpdateJobPriceOrCostCodeStatus(jobResult.Id, (int)StatusType.Delete);
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
                _jobCommands.UpdateJobPriceOrCostCodeStatus((long)jobIdList?.FirstOrDefault(), (int)StatusType.Active);
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
                NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.JobElectronicInvoiceSONumber, out isDeleted);
                jobResult.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoiceSONumber;
            }

            if (!string.IsNullOrEmpty(jobResult.JobSONumber) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
            {
                bool isDeleted = false;
                NavSalesOrderHelper.DeleteSalesOrderForNAV(ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.JobSONumber, out isDeleted);
                jobResult.JobSONumber = isDeleted ? string.Empty : jobResult.JobSONumber;
            }

            if (!jobResult.JobElectronicInvoice || (jobResult.JobElectronicInvoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (jobResult.JobElectronicInvoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
            {
                if (!jobResult.JobElectronicInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobSONumber))
                    {
                        navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                    else
                    {
                        navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobSONumber, string.IsNullOrEmpty(jobResult.JobCustomerPurchaseOrder) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobCustomerPurchaseOrder, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
                    {
                        navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                    else
                    {
                        navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobCustomerPurchaseOrder : jobResult.JobElectronicInvoicePONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                }
            }
            else
            {
                if (isManualInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobSONumber))
                    {
                        navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
                    }
                    else
                    {
                        navSalesOrderCreationResponse.ManualNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobSONumber, jobResult.JobCustomerPurchaseOrder, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
                    }
                }

                if (isElectronicInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
                    {
                        navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
                    }
                    else
                    {
                        navSalesOrderCreationResponse.ElectronicNavSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, jobResult.JobElectronicInvoicePONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
                    }
                }
            }

            if (jobResult.VendorERPId > 0)
            {
                //Task.Run(() =>
                //{
                NavPurchaseOrderHelper.PurchaseOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobResult.JobElectronicInvoice);
                //});
            }

            return navSalesOrderCreationResponse;
        }

        private NavSalesOrder GenerateNAVOrderFromM4PLUI(NavSalesOrder entity)
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
                if (!entity.Electronic_Invoice)
                {
                    if (string.IsNullOrEmpty(entity.ManualSalesOrderNo))
                    {
                        manualSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
                    }
                    else
                    {
                        manualSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.ManualSalesOrderNo, string.IsNullOrEmpty(entity.ManualPurchaseOrderNo) ? entity.ElectronicPurchaseOrderNo : entity.ManualPurchaseOrderNo, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(entity.ElectronicSalesOrderNo))
                    {
                        manualSalesOrder = NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
                    }
                    else
                    {
                        manualSalesOrder = NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.ElectronicSalesOrderNo, string.IsNullOrEmpty(entity.ElectronicPurchaseOrderNo) ? entity.ManualPurchaseOrderNo : entity.ElectronicPurchaseOrderNo, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice, salesOrderItemRequest);
                    }
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

            if (entity.VendorNo > 0)
            {
                //Task.Run(() =>
                //{
                NavPurchaseOrderHelper.PurchaseOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.Electronic_Invoice);
                //});
            }

            return manualSalesOrder != null ? manualSalesOrder : electronicSalesOrder;
        }
    }
}
