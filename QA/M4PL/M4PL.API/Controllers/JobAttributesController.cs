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
//Program Name:                                 JobAttribute
//Purpose:                                      End point to interact with JobAttribute module
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
    /// JobAttributes
    /// </summary>
	[RoutePrefix("api/JobAttributes")]
	public class JobAttributesController : ApiController
	{
        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        private readonly IJobAttributeCommands _jobAttributeCommands;

		/// <summary>
		/// Function to get Job's attribute details
		/// </summary>
		/// <param name="jobAttributeCommands"></param>
		public JobAttributesController(IJobAttributeCommands jobAttributeCommands)
		{
			_jobAttributeCommands = jobAttributeCommands;
		}

        /// <summary>
        /// Get the jobAttributue based on the paging settings
        /// </summary>
        /// <param name="pagedDataInfo">Pagination settings</param>
        /// <returns>List of jobAttribute</returns>
        [CustomQueryable]
        [HttpPost]
        [Route("GetPagedData"), ResponseType(typeof(Job))]
        public IList<JobAttribute> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            _jobAttributeCommands.ActiveUser = ActiveUser;
            return _jobAttributeCommands.GetPagedData(pagedDataInfo);
        }

        /// <summary>
        /// Get the job record by jobAttribute Id
        /// </summary>
        /// <param name="Id">jobAttribute Id</param>
        /// <returns>Job Attribute</returns>
        [HttpGet]
        [Route("{id}"), ResponseType(typeof(JobAttribute))]
        public JobAttribute Get(long Id)
        {
            _jobAttributeCommands.ActiveUser = ActiveUser;
            return _jobAttributeCommands.Get(Id);
        }

        /// <summary>
        /// Create new job record
        /// </summary>
        /// <param name="jobAttribute"></param>
        /// <returns>Returns newly created job</returns>
        [HttpPost, ResponseType(typeof(JobAttribute))]
        public JobAttribute Post(JobAttribute jobAttribute)
        {
            _jobAttributeCommands.ActiveUser = ActiveUser;
            return _jobAttributeCommands.Post(jobAttribute);
        }

        /// <summary>
        /// Updates the job attribute record by the job attribute id
        /// </summary>
        /// <param name="jobAttribute">Job details</param>
        /// <returns>Updated job attribute record</returns>
        [HttpPut, ResponseType(typeof(JobAttribute))]
        public JobAttribute Put(JobAttribute jobAttribute)
        {
            _jobAttributeCommands.ActiveUser = ActiveUser;
            return _jobAttributeCommands.Put(jobAttribute);
        }

        /// <summary>
        /// Delete the list of Jobs by Job Attribute Ids in comma separated.
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="statusId"></param>
        /// <returns>Returns the IdRefLangName list</returns>
        [HttpDelete]
        [Route("DeleteList"), ResponseType(typeof(IList<IdRefLangName>))]
        public IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobAttributeCommands.ActiveUser = ActiveUser;
            return _jobAttributeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }


    }
}