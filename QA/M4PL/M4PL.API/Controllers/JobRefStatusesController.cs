#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 JobRefStatuses
//Purpose:                                      End point to interact with Job RefStatuses module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job ref status service
	/// </summary>
	[RoutePrefix("api/JobRefStatuses")]
	public class JobRefStatusesController : ApiController
	{
		private readonly IJobRefStatusCommands _jobRefStatusCommands;

        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        /// <summary>
        /// Job ref status constructor with required parameter
        /// </summary>
        /// <param name="jobRefStatusCommands">Required parameter jobRefStatusCommands to initialize the required objects</param>
        public JobRefStatusesController(IJobRefStatusCommands jobRefStatusCommands)
		{
			_jobRefStatusCommands = jobRefStatusCommands;
		}


        /// <summary>
        /// Get the jobData based on the paging settings
        /// </summary>
        /// <param name="pagedDataInfo">Pagination settings</param>
        /// <returns>List of jobs</returns>
        [CustomQueryable]
        [HttpPost]
        [Route("GetPagedData"), ResponseType(typeof(JobRefStatus))]
        public IList<JobRefStatus> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            _jobRefStatusCommands.ActiveUser = ActiveUser;
            return _jobRefStatusCommands.GetPagedData(pagedDataInfo);
        }

        /// <summary>
        /// Get the job record by job Id
        /// </summary>
        /// <param name="Id">job Id</param>
        /// <returns>Job</returns>
        [HttpGet]
        [Route("{id}"), ResponseType(typeof(JobRefStatus))]
        public JobRefStatus Get(long Id)
        {
            _jobRefStatusCommands.ActiveUser = ActiveUser;
            return _jobRefStatusCommands.Get(Id);
        }

        /// <summary>
        /// Create new job record
        /// </summary>
        /// <param name="job"></param>
        /// <returns>Returns newly created job</returns>
        [HttpPost, ResponseType(typeof(JobRefStatus))]
        public JobRefStatus Post(JobRefStatus job)
        {
            _jobRefStatusCommands.ActiveUser = ActiveUser;
            return _jobRefStatusCommands.Post(job);
        }

        /// <summary>
        /// Updates the job record by the job id
        /// </summary>
        /// <param name="job">Job details</param>
        /// <returns>Updated job record</returns>
        [HttpPut, ResponseType(typeof(JobRefStatus))]
        public JobRefStatus Put(JobRefStatus job)
        {
            _jobRefStatusCommands.ActiveUser = ActiveUser;
            return _jobRefStatusCommands.Put(job);
        }

        /// <summary>
        /// Delete the list of Jobs by jobid in comma separated.
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="statusId"></param>
        /// <returns>Returns the IdRefLangName list</returns>
        [HttpDelete]
        [Route("DeleteList"), ResponseType(typeof(IList<IdRefLangName>))]
        public IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobRefStatusCommands.ActiveUser = ActiveUser;
            return _jobRefStatusCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }


    }
}