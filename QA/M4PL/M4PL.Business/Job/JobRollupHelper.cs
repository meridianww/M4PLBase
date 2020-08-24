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
// Date Programmed:                              11/20/2019
// Program Name:                                 JobRollupHelper
// Purpose:                                      Contains commands For Job Roll-Up Helper
//==============================================================================================================

using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _salesOrderHelper = M4PL.Business.Finance.SalesOrder.NavSalesOrderHelper;

namespace M4PL.Business.Job
{
    public static class JobRollupHelper
    {
        public static void StartJobRollUpProcess(Entities.Job.Job jobResult, ActiveUser activeUser, string navAPIUrl, string navAPIUserName, string navAPIPassword)
        {
            bool isElectronicInvoice = false;
            bool isManualInvoice = false;
            List<SalesOrderItem> manualSalesOrderItemRequest = null;
            List<SalesOrderItem> electronicSalesOrderItemRequest = null;
            List<long> jobIdList = new List<long>();
            jobIdList.Add(jobResult.Id);
            List<SalesOrderItem> salesOrderItemRequest = _commands.GetSalesOrderItemCreationData(activeUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
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
                _salesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoiceSONumber, out isDeleted);
                jobResult.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobResult.JobElectronicInvoiceSONumber;
            }

            if (!string.IsNullOrEmpty(jobResult.JobSONumber) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
            {
                bool isDeleted = false;
                _salesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobSONumber, out isDeleted);
                jobResult.JobSONumber = isDeleted ? string.Empty : jobResult.JobSONumber;
            }

            if (!jobResult.JobElectronicInvoice || (jobResult.JobElectronicInvoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (jobResult.JobElectronicInvoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
            {
                if (!jobResult.JobElectronicInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobSONumber))
                    {
                        _salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                    else
                    {
                        _salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, string.IsNullOrEmpty(jobResult.JobCustomerPurchaseOrder) ? jobResult.JobElectronicInvoicePONumber : jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
                    {
                        _salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                    else
                    {
                        _salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, string.IsNullOrEmpty(jobResult.JobElectronicInvoicePONumber) ? jobResult.JobCustomerPurchaseOrder : jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, jobResult.JobElectronicInvoice, salesOrderItemRequest);
                    }
                }
            }
            else
            {
                if (isManualInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobSONumber))
                    {
                        _salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
                    }
                    else
                    {
                        _salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobSONumber, jobResult.JobCustomerPurchaseOrder, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, false, manualSalesOrderItemRequest);
                    }
                }

                if (isElectronicInvoice)
                {
                    if (string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
                    {
                        _salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
                    }
                    else
                    {
                        _salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, jobIdList, jobResult.JobElectronicInvoiceSONumber, jobResult.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.VendorERPId, true, electronicSalesOrderItemRequest);
                    }
                }
            }

            if (!string.IsNullOrEmpty(jobResult.VendorERPId))
            {
                //Task.Run(() =>
                //{
                NavPurchaseOrderHelper.PurchaseOrderCreationProcessForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, jobResult.JobElectronicInvoice);
                //});
            }
        }
    }
}
