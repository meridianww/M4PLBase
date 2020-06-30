/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 JobAttributeCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobAttributeCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobAttributeCommands;

namespace M4PL.Business.Job
{
    public class JobAttributeCommands : BaseCommands<JobAttribute>, IJobAttributeCommands
    {
        /// <summary>
        /// Get list of job attribute data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobAttribute> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specificjob attribute record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobAttribute Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job attribute record
        /// </summary>
        /// <param name="jobAttribute"></param>
        /// <returns></returns>

        public JobAttribute Post(JobAttribute jobAttribute)
        {
            return _commands.Post(ActiveUser, jobAttribute);
        }

        /// <summary>
        /// Updates an existing job attribute record
        /// </summary>
        /// <param name="jobAttribute"></param>
        /// <returns></returns>

        public JobAttribute Put(JobAttribute jobAttribute)
        {
            return _commands.Put(ActiveUser, jobAttribute);
        }

        /// <summary>
        /// Deletes a specific job attribute record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list ofjob attribute record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public JobAttribute Patch(JobAttribute entity)
        {
            throw new NotImplementedException();
        }
    }
}