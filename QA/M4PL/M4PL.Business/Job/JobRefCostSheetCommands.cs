/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobRefCostSheetCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.job.JobRefCostSheetCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobRefCostSheetCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobRefCostSheetCommands : BaseCommands<JobRefCostSheet>, IJobRefCostSheetCommands
    {
        /// <summary>
        /// Get list of jobrefcostsheet data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobRefCostSheet> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific jobrefcostsheet record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobRefCostSheet Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new jobrefcostsheet record
        /// </summary>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public JobRefCostSheet Post(JobRefCostSheet jobRefCostSheet)
        {
            return _commands.Post(ActiveUser, jobRefCostSheet);
        }

        /// <summary>
        /// Updates an existing jobrefcostsheet record
        /// </summary>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public JobRefCostSheet Put(JobRefCostSheet jobRefCostSheet)
        {
            return _commands.Put(ActiveUser, jobRefCostSheet);
        }

        /// <summary>
        /// Deletes a specific jobrefcostsheet record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of jobrefcostsheet record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<JobRefCostSheet> Get()
        {
            throw new NotImplementedException();
        }
    }
}