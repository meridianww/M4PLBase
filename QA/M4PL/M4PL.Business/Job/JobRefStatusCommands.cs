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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobRefStatusCommands
// Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Job.JobRefStatusCommands
//====================================================================================================================

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobRefStatusCommands;

namespace M4PL.Business.Job
{
    public class JobRefStatusCommands : BaseCommands<JobRefStatus>, IJobRefStatusCommands
    {
        /// <summary>
        /// Get list of job ref status data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobRefStatus> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ob ref status record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobRefStatus Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job ref status  record
        /// </summary>
        /// <param name="jobRefStatus"></param>
        /// <returns></returns>

        public JobRefStatus Post(JobRefStatus jobRefStatus)
        {
            return _commands.Post(ActiveUser, jobRefStatus);
        }

        /// <summary>
        /// Updates an existing job ref status record
        /// </summary>
        /// <param name="jobRefStatus"></param>
        /// <returns></returns>

        public JobRefStatus Put(JobRefStatus jobRefStatus)
        {
            return _commands.Put(ActiveUser, jobRefStatus);
        }

        /// <summary>
        /// Deletes a specific job ref status record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job ref status record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
            
    }
}