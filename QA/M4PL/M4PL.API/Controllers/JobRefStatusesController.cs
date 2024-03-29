﻿#region Copyright

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

using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;


namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job ref status service
	/// </summary>
	
    [CustomAuthorize]
    [RoutePrefix("api/JobRefStatuses")]
    public class JobRefStatusesController :ApiController
	{
		private readonly IJobRefStatusCommands _jobRefStatusCommands;

		/// <summary>
		/// Job ref status constructor with required parameter
		/// </summary>
		/// <param name="jobRefStatusCommands">Required parameter jobRefStatusCommands to initialize the required objects</param>
		public JobRefStatusesController(IJobRefStatusCommands jobRefStatusCommands)
		
		{
			_jobRefStatusCommands = jobRefStatusCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobRefStatus> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobRefStatus.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobRefStatus Get(long id)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobRefStatus object passed as parameter.
        /// </summary>
        /// <param name="jobRefStatus">Refers to jobRefStatus object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobRefStatus Post(JobRefStatus jobRefStatus)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Post(jobRefStatus);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobRefStatus object passed.
        /// </summary>
        /// <param name="jobRefStatus">Refers to jobRefStatus object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobRefStatus Put(JobRefStatus jobRefStatus)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Put(jobRefStatus);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobRefStatus object passed.
        /// </summary>
        /// <param name="jobRefStatus">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobRefStatus Patch(JobRefStatus jobRefStatus)
        {
            _jobRefStatusCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefStatusCommands.Patch(jobRefStatus);
        }
    }
}