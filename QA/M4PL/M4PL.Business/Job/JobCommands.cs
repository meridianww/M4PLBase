/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Job.JobCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCommands;
using _rollupCommands = M4PL.DataAccess.JobRollup.JobRollupCommands;
using System;
using M4PL.Entities.JobRollup;
using System.Threading.Tasks;
using M4PL.Entities;
using System.Linq;
using M4PL.Utilities;
using System.Data;
using System.Threading;
using M4PL.Business.XCBL.HelperClasses;

namespace M4PL.Business.Job
{
    public class JobCommands : BaseCommands<Entities.Job.Job>, IJobCommands
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

        /// <summary>
        /// Get list of job data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Job.Job> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Job.Job Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job record
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        public Entities.Job.Job Post(Entities.Job.Job job)
        {
            long customerId = M4PBusinessContext.ComponentSettings.ElectroluxCustomerId;
            bool isUpdateRequired = customerId == job.CustomerId ? false : true;
            return _commands.Post(ActiveUser, job, isUpdateRequired);
        }

        /// <summary>
        /// Updates an existing job record
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        public Entities.Job.Job Put(Entities.Job.Job job)
        {
            ActiveUser activeUser = ActiveUser;
            long customerId = M4PBusinessContext.ComponentSettings.ElectroluxCustomerId;
            bool isUpdateRequired = customerId == job.CustomerId ? false : true;
            Entities.Job.Job jobResult = _commands.Put(activeUser, job, isRelatedAttributeUpdate : isUpdateRequired, isServiceCall : false);
            if (jobResult != null && jobResult.JobCompleted)
            {
                Task.Run(() =>
                {
					bool isDeliveryChargeRemovalRequired = _commands.GetJobDeliveryChargeRemovalRequired(job.Id, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId);
					if (isDeliveryChargeRemovalRequired)
					{
						_commands.UpdateJobPriceOrCostCodeStatus(job.Id, (int)StatusType.Delete);
					}

					try
					{
						JobRollupHelper.StartJobRollUpProcess(jobResult, activeUser, NavAPIUrl, NavAPIUserName, NavAPIPassword);
					}
					catch(Exception exp)
					{
						DataAccess.Logger.ErrorLogger.Log(exp, "Error while creating Order in NAV after job Completion.", "StartJobRollUpProcess", Utilities.Logger.LogType.Error);
					}

					if (isDeliveryChargeRemovalRequired)
					{
						_commands.UpdateJobPriceOrCostCodeStatus(job.Id, (int)StatusType.Active);
					}
				});
            }

            return jobResult;
        }

        /// <summary>
        /// Deletes a specific job record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public JobDestination GetJobDestination(long id, long parentId)
        {
            return _commands.GetJobDestination(ActiveUser, id, parentId);
        }

        public Job2ndPoc GetJob2ndPoc(long id, long parentId)
        {
            return _commands.GetJob2ndPoc(ActiveUser, id, parentId);
        }

        public JobSeller GetJobSeller(long id, long parentId)
        {
            return _commands.GetJobSeller(ActiveUser, id, parentId);
        }

        public JobSeller UpdateJobAttributes(long id, long parentId)
        {
            return _commands.GetJobSeller(ActiveUser, id, parentId);
        }

        public JobMapRoute GetJobMapRoute(long id)
        {
            return _commands.GetJobMapRoute(ActiveUser, id);
        }

        public JobPod GetJobPod(long id)
        {
            return _commands.GetJobPod(ActiveUser, id);
        }

        public JobDestination PutJobDestination(JobDestination jobDestination)
        {
            return _commands.PutJobDestination(ActiveUser, jobDestination);
        }

        public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
        {
            return _commands.PutJob2ndPoc(ActiveUser, job2ndPoc);
        }

        public JobSeller PutJobSeller(JobSeller jobSeller)
        {
            return _commands.PutJobSeller(ActiveUser, jobSeller);
        }

        public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
        {
            return _commands.PutJobMapRoute(ActiveUser, jobMapRoute);
        }

        public Entities.Job.Job GetJobByProgram(long id, long parentId)
        {
            return _commands.GetJobByProgram(ActiveUser, id, parentId);
        }

        public Entities.Job.Job Patch(Entities.Job.Job entity)
        {
            throw new NotImplementedException();
        }

        public IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {
            return _commands.GetJobsSiteCodeByProgram(ActiveUser, id, parentId, isNullFIlter);
        }

        public bool GetIsJobDataViewPermission(long recordId)
        {
            var permittedProgramEntity = _commands.GetCustomEntityIdByEntityName(ActiveUser, EntitiesAlias.Program, true);
            if (permittedProgramEntity == null) return false;
            return permittedProgramEntity.Any(t => t.EntityId == -1 || t.EntityId == recordId);
        }

        public bool UpdateJobAttributes(long jobId)
        {
            return _commands.UpdateJobAttributes(ActiveUser, jobId);
        }

        public bool InsertJobComment(JobComment comment)
        {
            return _commands.InsertJobComment(ActiveUser, comment);
        }

        public bool InsertJobGateway(long jobId, string gatewayStatusCode)
        {
            return _commands.InsertJobGateway(ActiveUser, jobId, gatewayStatusCode);
        }

        public long CreateJobFromEDI204(long eshHeaderID)
        {
            return _commands.CreateJobFromEDI204(ActiveUser, eshHeaderID);
        }

        public bool CreateJobFromCSVImport(JobCSVData jobCSVData)
        {
            bool result = true;
            if (jobCSVData != null && jobCSVData.ProgramId > 0 && jobCSVData.FileContent != null)
            {
                using (DataTable tblCSVInfo = CSVParser.GetDataTableForCSVByteArray(jobCSVData.FileContent))
                {
                    if (tblCSVInfo != null && tblCSVInfo.Rows.Count > 0)
                    {
                        List<BatchJobDetail> batchJobDetailsList = new List<BatchJobDetail>();
                        batchJobDetailsList = Extension.ConvertDataTableToModel<BatchJobDetail>(tblCSVInfo);
                        if (batchJobDetailsList != null && batchJobDetailsList.Count > 0)
                        {
                            result = GenerateOrderFromCSV(batchJobDetailsList, jobCSVData.ProgramId);
                        }
                    }
                }
            }

            return result;
        }

        public List<ChangeHistoryData> GetChangeHistory(long jobId)
        {
            return _commands.GetChangeHistory(jobId, ActiveUser);
        }

		public bool UpdateJobInvoiceDetail(JobInvoiceData jobInvoiceData)
		{
			bool result = false;
			if (jobInvoiceData?.JobId > 0)
			{
				var existingJobDetails = _commands.GetJobByProgram(ActiveUser, jobInvoiceData.JobId, 0);
				if (existingJobDetails?.Id > 0)
				{
					existingJobDetails.JobInvoicedDate = jobInvoiceData.InvoicedDate;
					var updatedJobDetails = _commands.Post(ActiveUser, existingJobDetails, true, true);
					result = updatedJobDetails?.Id > 0 ? true : false;
				}

				if (result && jobInvoiceData.CustomerId == M4PBusinessContext.ComponentSettings.ElectroluxCustomerId && jobInvoiceData.IsCustomerUpdateRequired)
				{
					var deliveryUpdateModel = DataAccess.XCBL.XCBLCommands.GetDeliveryUpdateModel(jobInvoiceData.JobId, ActiveUser);
					if (deliveryUpdateModel != null)
					{
						ElectroluxHelper.SendDeliveryUpdateRequestToElectrolux(ActiveUser, deliveryUpdateModel, jobInvoiceData.JobId);
					}
				}
			}

			return result;
		}

		private bool GenerateOrderFromCSV(List<BatchJobDetail> batchJobDetails, long jobProgramId)
        {
            int noOfThreads = 10;
            List<BatchJobDetail> processData = new List<BatchJobDetail>();
            if (batchJobDetails != null && batchJobDetails.Count > 0)
            {
                int totalCount = batchJobDetails.Count;
                if (totalCount < noOfThreads)
                {
                    noOfThreads = totalCount;
                }

                int noOfOrdersPerThread = totalCount / noOfThreads;
                for (int i = 0; i < noOfThreads; i++)
                {
                    processData = i == noOfThreads - 1 ? batchJobDetails.Skip(i * noOfOrdersPerThread).ToList() :
                        batchJobDetails.Skip(i * noOfOrdersPerThread).Take(noOfOrdersPerThread).ToList();
                    if (processData.Count > 0)
                    {
                        var data = processData;
                        var newThread = new Thread(() => _commands.CreateJobInDatabase(data, jobProgramId, ActiveUser));
                        newThread.Start();
                        Thread.Sleep(1000);
                    }
                }
            }

            return true;
        }

        public bool UpdateJobCompleted(long custId, long programId,long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate)
        {
            return _commands.UpdateJobCompleted(custId, programId,jobId, deliveryDate, includeNullableDeliveryDate, ActiveUser);
        }

        public List<Entities.Job.Job> GetActiveJobByProgramId(long programId)
        {
            return _commands.GetActiveJobByProgramId(programId);

        }
    }
}