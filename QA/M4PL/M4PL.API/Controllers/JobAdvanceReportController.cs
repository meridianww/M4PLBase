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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      End point to interact with JobAdvanceReport module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobAdvanceReportController
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobAdvanceReport")]
	public class JobAdvanceReportController : ApiController
	{
		private readonly IJobAdvanceReportCommands _jobAdvanceReportCommands;

		/// <summary>
		/// Function to get Job's advance Report details
		/// </summary>
		/// <param name="jobAdvanceReportCommands"></param>
		public JobAdvanceReportController(IJobAdvanceReportCommands jobAdvanceReportCommands)
		
		{
			_jobAdvanceReportCommands = jobAdvanceReportCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobAdvanceReport> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobAdvanceReport.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobAdvanceReport Get(long id)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobAdvanceReport object passed as parameter.
        /// </summary>
        /// <param name="jobAdvanceReport">Refers to jobAdvanceReport object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobAdvanceReport Post(JobAdvanceReport jobAdvanceReport)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Post(jobAdvanceReport);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobAdvanceReport object passed.
        /// </summary>
        /// <param name="jobAdvanceReport">Refers to jobAdvanceReport object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobAdvanceReport Put(JobAdvanceReport jobAdvanceReport)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Put(jobAdvanceReport);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Delete(id);
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
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobAdvanceReport object passed.
        /// </summary>
        /// <param name="jobAdvanceReport">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobAdvanceReport Patch(JobAdvanceReport jobAdvanceReport)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.Patch(jobAdvanceReport);
        }
        /// <summary>
        /// Get the job advance report filter, based upon customerId and jobAdvanceReport and if customerId is 0 return all result by jobAdvanceReport
        /// </summary>
        /// <param name="customerId">Customer Id</param>
        /// <param name="entity">Entity Name</param>
        /// <returns>List of Job Advance Report Filters</returns>
        [CustomAuthorize]
		[HttpGet]
        [Route("AdvanceReport"), ResponseType(typeof(IList<JobAdvanceReportFilter>))]
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(long customerId, string entity)
		{
			_jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser; 
			return _jobAdvanceReportCommands.GetDropDownDataForProgram(Models.ApiContext.ActiveUser, customerId, entity);
		}

        /// <summary>
        /// GenerateScrubDriverDetails
        /// </summary>
        /// <param name="scriberDriverView"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("GenerateScrubDriverDetails"), ResponseType(typeof(StatusModel))]
        public StatusModel GenerateScrubDriverDetails(JobDriverScrubReportData scriberDriverView)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.GenerateScrubDriverDetails(Models.ApiContext.ActiveUser, scriberDriverView);
        }
        /// <summary>
        /// Generates Projected Capacity Details
        /// </summary>
        /// <param name="projectedCapacityView"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("GenerateProjectedCapacityDetails"), ResponseType(typeof(StatusModel))]
        public StatusModel GenerateProjectedCapacityDetails(ProjectedCapacityData projectedCapacityView)
        {
            _jobAdvanceReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAdvanceReportCommands.GenerateProjectedCapacityDetails(Models.ApiContext.ActiveUser, projectedCapacityView);
        }
    }
}