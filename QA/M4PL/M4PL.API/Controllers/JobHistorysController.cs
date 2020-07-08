#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job history/logs service
	/// </summary>
	[RoutePrefix("api/JobHistorys")]
	public class JobHistorysController : ApiController
	{
		private readonly IJobHistorysCommands _jobHistorysController;

        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        /// <summary>
        /// Job history/logs constructor with required parameter
        /// </summary>
        /// <param name="jobHistorysController"></param>
        public JobHistorysController(IJobHistorysCommands jobHistorysController)
		  
		{
			_jobHistorysController = jobHistorysController;
		}


        /// <summary>
        /// Get the jobData based on the paging settings
        /// </summary>
        /// <param name="pagedDataInfo">Pagination settings</param>
        /// <returns>List of jobs</returns>
        [CustomQueryable]
        [HttpPost]
        [Route("GetPagedData"), ResponseType(typeof(JobHistory))]
        public IList<JobHistory> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            _jobHistorysController.ActiveUser = ActiveUser;
            return _jobHistorysController.GetPagedData(pagedDataInfo);
        }
    }
}