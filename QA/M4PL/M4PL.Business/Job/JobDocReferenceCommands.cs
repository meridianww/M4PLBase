﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobDocReferenceCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.JobDocReferenceCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobDocReferenceCommands;

namespace M4PL.Business.Job
{
    public class JobDocReferenceCommands : BaseCommands<JobDocReference>, IJobDocReferenceCommands
    {
        /// <summary>
        /// Get list of job reference data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobDocReference> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobDocReference Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        public JobDocReference Post(JobDocReference jobDocReference)
        {
            return _commands.Post(ActiveUser, jobDocReference);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        public JobDocReference PostWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            return _commands.PostWithSettings(ActiveUser, userSysSetting, jobDocReference);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        public JobDocReference Put(JobDocReference jobDocReference)
        {
            return _commands.Put(ActiveUser, jobDocReference);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        public JobDocReference PutWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            return _commands.PutWithSettings(ActiveUser, userSysSetting, jobDocReference);
        }

        /// <summary>
        /// Deletes a specific job reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job reference record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }


    }
}