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
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobReports")]
	public class JobReportsController : BaseApiController<JobReport>
	{
		private readonly IJobReportCommands _JobReportCommands;

		/// <summary>
		/// Fucntion to get Jobs reports
		/// </summary>
		/// <param name="jobReportCommands"></param>
		public JobReportsController(IJobReportCommands jobReportCommands)
			: base(jobReportCommands)
		{
			_JobReportCommands = jobReportCommands;
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