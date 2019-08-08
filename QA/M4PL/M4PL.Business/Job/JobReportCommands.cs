/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobReportCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobReportCommands
===================================================================================================================*/
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobReportCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobReportCommands : BaseCommands<JobReport>, IJobReportCommands
    {
        /// <summary>
        /// Get list of memu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific JobReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new JobReport record
        /// </summary>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public JobReport Post(JobReport jobReport)
        {
            return _commands.Post(ActiveUser, jobReport);
        }

        /// <summary>
        /// Updates an existing JobReport record
        /// </summary>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public JobReport Put(JobReport jobReport)
        {
            return _commands.Put(ActiveUser, jobReport);
        }

        /// <summary>
        /// Deletes a specific JobReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of JobReport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<JobReport> Get()
        {
            throw new NotImplementedException();
        }

		public JobReport Patch(JobReport entity)
		{
			throw new NotImplementedException();
		}
	}
}