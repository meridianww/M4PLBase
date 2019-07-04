/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCargoCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobCargoCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCargoCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobCargoCommands : BaseCommands<JobCargo>, IJobCargoCommands
    {
        /// <summary>
        /// Get list of job cargo data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobCargo> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job cargo record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobCargo Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a newjob cargo record
        /// </summary>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public JobCargo Post(JobCargo jobCargo)
        {
            return _commands.Post(ActiveUser, jobCargo);
        }

        /// <summary>
        /// Updates an existing job cargo record
        /// </summary>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public JobCargo Put(JobCargo jobCargo)
        {
            return _commands.Put(ActiveUser, jobCargo);
        }

        /// <summary>
        /// Deletes a specific job cargo record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job cargo record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<JobCargo> Get()
        {
            throw new NotImplementedException();
        }
    }
}