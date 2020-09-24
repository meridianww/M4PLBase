#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              1/20/2020
// Program Name:                                 JobAdvanceReportCommands
// Purpose:                                      Set of rules for JobAdvanceReportCommands
//====================================================================================================================

using M4PL.Business.Common;
using M4PL.Entities;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Job.JobAdvanceReportCommands;

namespace M4PL.Business.Job
{
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReport>, IJobAdvanceReportCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public IList<JobAdvanceReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
			IList<JobAdvanceReport> result = null;
			bool isCostChargeReport = false;
			bool isPriceChargeReport = false;
			result = _commands.GetPagedData(ActiveUser, pagedDataInfo);
			isCostChargeReport = result != null && result.Count > 0 && (result.ToList().Where(x => x.IsCostChargeReport).Any());
			isPriceChargeReport = result != null && result.Count > 0 && (result.ToList().Where(x => x.IsPriceChargeReport).Any());
			if (isCostChargeReport || isPriceChargeReport)
			{
				IList<JobAdvanceReport> updatedResult = new List<JobAdvanceReport>();
				JobAdvanceReport currentJobAdvanceReport = null;
				int jobItemCount = 1;
				if (isPriceChargeReport)
				{
					NavSalesOrderPostedInvoiceResponse navSalesOrderPostedInvoiceResponse = CommonCommands.GetCachedNavSalesOrderValues();
					NavSalesOrderItemResponse navSalesOrderItemResponse = CommonCommands.GetCachedNavSalesOrderItemValues();
					foreach (var currentJob in result)
					{
						var currentNavSalesOrder = navSalesOrderPostedInvoiceResponse.NavSalesOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJob.JobId);
						if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
						{
							var currentSalesLineItem = navSalesOrderItemResponse.NavSalesOrderItem.Where(x => x.Document_No.Equals(currentNavSalesOrder.No, StringComparison.OrdinalIgnoreCase));
							if (currentSalesLineItem.Any() && currentSalesLineItem.Count() > 0)
							{
								foreach (var salesLineItem in currentSalesLineItem)
								{
									currentJobAdvanceReport = currentJob.DeepCopy();
									currentJobAdvanceReport.RateChargeCode = string.IsNullOrEmpty(salesLineItem.Cross_Reference_No) ? salesLineItem.No : salesLineItem.Cross_Reference_No;
									currentJobAdvanceReport.RateTitle = salesLineItem.Description;
									currentJobAdvanceReport.RateAmount = salesLineItem.Unit_Price;
									currentJobAdvanceReport.Id = currentJob.Id;
									updatedResult.Add(currentJobAdvanceReport);
									jobItemCount = jobItemCount + 1;
								}
							}
						}
					}
				}
				else
				{
					NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderPostedInvoiceResponse = CommonCommands.GetCachedNavPurchaseOrderValues();
					NavPurchaseOrderItemResponse navPurchaseOrderItemResponse = CommonCommands.GetCachedNavPurchaseOrderItemValues();
					foreach (var currentJob in result)
					{
						var currentNavPurchaseOrder = navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJob.JobId);
						if (currentNavPurchaseOrder != null && !string.IsNullOrEmpty(currentNavPurchaseOrder.No))
						{
							var currentPurchaseLineItem = navPurchaseOrderItemResponse.NavPurchaseOrderItem.Where(x => x.Document_No.Equals(currentNavPurchaseOrder.No, StringComparison.OrdinalIgnoreCase));
							if (currentPurchaseLineItem.Any() && currentPurchaseLineItem.Count() > 0)
							{
								foreach (var purchaseLineItem in currentPurchaseLineItem)
								{
									currentJobAdvanceReport = currentJob.DeepCopy();
									currentJobAdvanceReport.RateChargeCode = string.IsNullOrEmpty(purchaseLineItem.Cross_Reference_No) ? purchaseLineItem.No : purchaseLineItem.Cross_Reference_No;
									currentJobAdvanceReport.RateTitle = purchaseLineItem.Description;
									currentJobAdvanceReport.RateAmount = purchaseLineItem.Unit_Cost_LCY;
									currentJobAdvanceReport.Id = currentJob.Id;
									updatedResult.Add(currentJobAdvanceReport);
									jobItemCount = jobItemCount + 1;
								}
							}
						}
					}
				}

				pagedDataInfo.TotalCount = updatedResult != null && updatedResult.Count > 0 ? updatedResult.Count : 0;
				return updatedResult;
			}

			return result;
        }

        public JobAdvanceReport Patch(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Post(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Put(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(ActiveUser activeUser, long customerId, string entity)
        {
            return _commands.GetDropDownDataForProgram(activeUser, customerId, entity);
        }
        public StatusModel GenerateScrubDriverDetails(ActiveUser activeUser, JobDriverScrubReportData scriberDriverView)
        {
            var result = _commands.InsertDriverScrubReportRawData(scriberDriverView, activeUser);
            return new StatusModel
            {
                Status = result ? "Success" : "Fail",
                StatusCode = result ? 200 : 500,
                AdditionalDetail = result ? "Record has been uploaded successfully" : "Failed to uploaded record"
            };
        }
        public StatusModel GenerateProjectedCapacityDetails(ActiveUser activeUser, ProjectedCapacityData projectedCapacityView)
        {
            var result = _commands.InsertProjectedCapacityRawData(projectedCapacityView, activeUser);
            return new StatusModel
            {
                Status = result ? "Success" : "Fail",
                StatusCode = result ? 200 : 500,
                AdditionalDetail = result ? "Record has been uploaded successfully" : "Failed to uploaded record"
            };
        }
    }
}