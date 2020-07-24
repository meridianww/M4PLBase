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
	
    [CustomAuthorize]
    [RoutePrefix("api/JobReports")]
    public class JobReportsController : ApiController
    {
		private readonly IJobReportCommands _JobReportCommands;

		/// <summary>
		/// Fucntion to get Jobs reports
		/// </summary>
		/// <param name="jobReportCommands"></param>
		public JobReportsController(IJobReportCommands jobReportCommands)
			
		{
			_JobReportCommands = jobReportCommands;
		}

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobReport> PagedData(PagedDataInfo pagedDataInfo)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobReport.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobReport Get(long id)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobReport object passed as parameter.
        /// </summary>
        /// <param name="jobReport">Refers to jobReport object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobReport Post(JobReport jobReport)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Post(jobReport);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobReport object passed.
        /// </summary>
        /// <param name="jobReport">Refers to jobReport object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobReport Put(JobReport jobReport)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Put(jobReport);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Delete(id);
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
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobReport object passed.
        /// </summary>
        /// <param name="jobReport">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobReport Patch(JobReport jobReport)
        {
            _JobReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _JobReportCommands.Patch(jobReport);
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
			return _JobReportCommands.GetVocReportData(Models.ApiContext.ActiveUser, companyId, locationCode, startDate, endDate, IsPBSReport);
		}
        
        /// <summary>
        /// Returns the Site codes by customer Id
        /// </summary>
        /// <param name="customerId">Customer Id</param>
        /// <param name="jobReport">jobReport will be location</param>
        /// <returns>Site codes list</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("VocReportByCustomer"), ResponseType(typeof(IList<JobReport>))]
		public IList<JobReport> GetDropDownDataForLocation(long customerId, string jobReport)
		{
			return _JobReportCommands.GetDropDownDataForLocation(Models.ApiContext.ActiveUser, customerId, jobReport);
		}
	}
}