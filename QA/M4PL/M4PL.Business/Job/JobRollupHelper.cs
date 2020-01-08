/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              11/20/2019
Program Name:                                 JobRollupHelper
Purpose:                                      Contains commands For Job Roll-Up Helper
=============================================================================================================*/

using System.Collections.Generic;
using M4PL.Entities.JobRollup;
using M4PL.Entities.Support;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using _rollupCommands = M4PL.DataAccess.JobRollup.JobRollupCommands;
using _salesOrderHelper = M4PL.Business.Finance.SalesOrder.NavSalesOrderHelper;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using M4PL.Entities.Finance.ShippingItem;
using System.Linq;
using System.Threading.Tasks;
using M4PL.Business.Finance.PurchaseOrder;

namespace M4PL.Business.Job
{
	public static class JobRollupHelper
	{
		public static void StartJobRollUpProcess(Entities.Job.Job jobResult, ActiveUser activeUser, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			List<long> currentJobId = null;
			List<JobRollupList> rollupResult = _rollupCommands.GetRollupByJob(jobResult.Id);
			bool isElectronicInvoice = false;
			bool isManualInvoice = false;
			List<SalesOrderItem> manualSalesOrderItemRequest = null;
			List<SalesOrderItem> electronicSalesOrderItemRequest = null;
			if (rollupResult != null && rollupResult.Count > 0)
			{
				foreach (var rollUpJob in rollupResult)
				{
					List<SalesOrderItem> salesOrderItemRequest = _commands.GetSalesOrderItemCreationData(activeUser, rollUpJob.JobId, Entities.EntitiesAlias.ShippingItem);
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

					foreach (var jobId in rollUpJob.JobId)
					{
						currentJobId = new List<long>();
						currentJobId.Add(jobId);
						Entities.Job.Job jobData = _jobCommands.GetJobByProgram(activeUser, jobId, 0);
						if ((!jobData.JobElectronicInvoice || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any())) && !string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber))
						{
							bool isDeleted = false;
							_salesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobData.JobElectronicInvoiceSONumber, out isDeleted);
							jobData.JobElectronicInvoiceSONumber = isDeleted ? string.Empty : jobData.JobElectronicInvoiceSONumber;
						}

						if (!string.IsNullOrEmpty(jobData.JobSONumber) && ((salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0)) || (salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
						{
							bool isDeleted = false;
							_salesOrderHelper.DeleteSalesOrderForNAV(activeUser, navAPIUrl, navAPIUserName, navAPIPassword, jobData.JobSONumber, out isDeleted);
							jobData.JobSONumber = isDeleted ? string.Empty : jobData.JobSONumber;
						}

						if (!jobData.JobElectronicInvoice || (jobData.JobElectronicInvoice && (salesOrderItemRequest == null || (salesOrderItemRequest != null && salesOrderItemRequest.Count == 0))) || (jobData.JobElectronicInvoice && salesOrderItemRequest != null && salesOrderItemRequest.Count > 0 && !salesOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
						{
							if (string.IsNullOrEmpty(jobData.JobSONumber))
							{
								_salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, currentJobId, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice, salesOrderItemRequest);
							}
							else
							{
								_salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, currentJobId, jobData.JobSONumber, jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice, salesOrderItemRequest);
							}
						}
						else
						{
							if (isManualInvoice)
							{
								if (string.IsNullOrEmpty(jobData.JobSONumber))
								{
									_salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, currentJobId, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, false, manualSalesOrderItemRequest);
								}
								else
								{
									_salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, currentJobId, jobData.JobSONumber, jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, false, manualSalesOrderItemRequest);
								}
							}

							if (isElectronicInvoice)
							{
								if (string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber))
								{
									_salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, currentJobId, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, true, electronicSalesOrderItemRequest);
								}
								else
								{
									_salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, currentJobId, jobData.JobElectronicInvoiceSONumber, jobData.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, true, electronicSalesOrderItemRequest);
								}
							}
						}

						if (jobData.VendorERPId > 0)
						{
							Task.Run(() =>
							{
								NavPurchaseOrderHelper.PurchaseOrderCreationProcessForNAV(activeUser, currentJobId, navAPIUrl, navAPIUserName, navAPIPassword, jobData.JobElectronicInvoice);
							});
						}
					}
				}
			}
		}
	}
}
