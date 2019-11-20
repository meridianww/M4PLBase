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

namespace M4PL.Business.Job
{
	public static class JobRollupHelper
	{
		public static void StartJobRollUpProcess(Entities.Job.Job jobResult, ActiveUser activeUser, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			List<long> currentJobId = null;
			List<JobRollupList> rollupResult = _rollupCommands.GetRollupByJob(jobResult.Id);
			if (rollupResult != null && rollupResult.Count > 0)
			{
				foreach (var rollUpJob in rollupResult)
				{
					foreach (var jobId in rollUpJob.JobId)
					{
						currentJobId = new List<long>();
						currentJobId.Add(jobId);
						Entities.Job.Job jobData = _jobCommands.GetJobByProgram(activeUser, jobId, 0);
						if (!string.IsNullOrEmpty(jobData.JobSONumber))
						{
							_salesOrderHelper.StartOrderUpdationProcessForNAV(activeUser, currentJobId, jobData.JobSONumber, jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice);
						}
						else
						{
							_salesOrderHelper.StartOrderCreationProcessForNAV(activeUser, currentJobId, navAPIUrl, navAPIUserName, navAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice);
						}
					}
				}
			}
		}
	}
}
