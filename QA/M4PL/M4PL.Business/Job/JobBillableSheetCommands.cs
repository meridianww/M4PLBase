
/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              29/07/2019
Program Name:                                 JobBillableSheetCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.job.JobBillableSheetCommands
===================================================================================================================*/
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobBillableSheetCommands;

namespace M4PL.Business.Job
{
    public class JobBillableSheetCommands : BaseCommands<JobBillableSheet>, IJobBillableSheetCommands
    {
        /// <summary>
        /// Get list of jobBillableSheet data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobBillableSheet> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific jobBillableSheet record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobBillableSheet Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new jobBillableSheet record
        /// </summary>
        /// <param name="_jobBillableSheet"></param>
        /// <returns></returns>

        public JobBillableSheet Post(JobBillableSheet _jobBillableSheet)
        {
            return _commands.Post(ActiveUser, _jobBillableSheet);
        }

        /// <summary>
        /// Updates an existing jobBillableSheet record
        /// </summary>
        /// <param name="_jobBillableSheet"></param>
        /// <returns></returns>

        public JobBillableSheet Put(JobBillableSheet _jobBillableSheet)
        {
            return _commands.Put(ActiveUser, _jobBillableSheet);
        }

        /// <summary>
        /// Deletes a specific jobBillableSheet record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of jobBillableSheet record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<JobBillableSheet> Get()
        {
            throw new NotImplementedException();
        }

		public JobBillableSheet Patch(JobBillableSheet entity)
		{
			throw new NotImplementedException();
		}

		public IList<JobPriceCodeAction> GetJobPriceCodeAction(long jobId)
		{
			return _commands.GetJobPriceCodeAction(ActiveUser, jobId);
		}

		public JobBillableSheet JobPriceCodeByProgram(long id, long jobId)
		{
			return _commands.JobPriceCodeByProgram(ActiveUser, id, jobId);
		}
	}
}
