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
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Job Reorts
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobReports")]
	public class JobReportsController : ApiController
	{
		private readonly IJobReportCommands _JobReportCommands;

        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        /// <summary>
        /// Fucntion to get Jobs reports
        /// </summary>
        /// <param name="jobReportCommands"></param>
        public JobReportsController(IJobReportCommands jobReportCommands)
		{
			_JobReportCommands = jobReportCommands;
		}

        /// <summary>
        /// Get the Job report data based on the paging settings
        /// </summary>
        /// <param name="pagedDataInfo">Pagination settings</param>
        /// <returns>List of job reports data</returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData"), ResponseType(typeof(JobReport))]
        public IList<JobReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            _JobReportCommands.ActiveUser = ActiveUser;
            return _JobReportCommands.GetPagedData(pagedDataInfo);
        }

        /// <summary>
        /// Get the job report record by job Id
        /// </summary>
        /// <param name="Id">job Id</param>
        /// <returns>Job</returns>
        [HttpGet]
        [Route("{id}"), ResponseType(typeof(JobReport))]
        public JobReport Get(long Id)
        {
            _JobReportCommands.ActiveUser = ActiveUser;
            return _JobReportCommands.Get(Id);
        }

        /// <summary>
        /// Inserts new Job report record
        /// </summary>
        /// <param name="jobReport"></param>
        /// <returns>Returns newly created job report record</returns>
        [HttpPost, ResponseType(typeof(JobReport))]
        public JobReport Post(JobReport jobReport)
        {
            _JobReportCommands.ActiveUser = ActiveUser;
            return _JobReportCommands.Post(jobReport);
        }

        /// <summary>
        /// Updates the job record by the job id
        /// </summary>
        /// <param name="jobReport">Job details</param>
        /// <returns>Updated job record</returns>
        [HttpPut, ResponseType(typeof(JobReport))]
        public JobReport Put(JobReport jobReport)
        {
            _JobReportCommands.ActiveUser = ActiveUser;
            return _JobReportCommands.Put(jobReport);
        }

        /// <summary>
        /// Delete the list of Job report  reocrds by ids in comma separated.
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="statusId"></param>
        /// <returns>Returns the IdRefLangName list</returns>
        [HttpDelete]
        [Route("DeleteList"), ResponseType(typeof(IList<IdRefLangName>))]
        public IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _JobReportCommands.ActiveUser = ActiveUser;
            return _JobReportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Returns the job report data by company.
        /// </summary>
        /// <param name="companyId">company Id</param>
        /// <param name="locationCode">location code</param>
        /// <param name="startDate">Start Date</param>
        /// <param name="endDate">End Date</param>
        /// <param name="IsPBSReport">IsPBSReport</param>
        /// <returns>List of Report data</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("VocReport"),ResponseType(typeof(IList<JobReport>))]
        public IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport)
		{
			return _JobReportCommands.GetVocReportData(ActiveUser, companyId, locationCode, startDate, endDate, IsPBSReport);
		}
        
        /// <summary>
        /// Returns the Site codes by customer Id
        /// </summary>
        /// <param name="customerId">Customer Id</param>
        /// <param name="entity">entity will be location</param>
        /// <returns>Site codes list</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("VocReportByCustomer"), ResponseType(typeof(IList<JobReport>))]
		public IList<JobReport> GetDropDownDataForLocation(long customerId, string entity)
		{
			return _JobReportCommands.GetDropDownDataForLocation(ActiveUser, customerId, entity);
		}
	}
}