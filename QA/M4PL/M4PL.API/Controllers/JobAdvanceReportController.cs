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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      End point to interact with JobAdvanceReport module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobAdvanceReportController
    /// </summary>
	[RoutePrefix("api/JobAdvanceReport")]
	public class JobAdvanceReportController : BaseApiController<JobAdvanceReport>
	{
		private readonly IJobAdvanceReportCommands _jobAdvanceReportCommands;

		/// <summary>
		/// Function to get Job's advance Report details
		/// </summary>
		/// <param name="jobAdvanceReportCommands"></param>
		public JobAdvanceReportController(IJobAdvanceReportCommands jobAdvanceReportCommands)
			: base(jobAdvanceReportCommands)
		{
			_jobAdvanceReportCommands = jobAdvanceReportCommands;
		}

		/// <summary>
		/// Get the job advance report filter, based upon customerId and entity and if customerId is 0 return all result by entity
		/// </summary>
		[CustomAuthorize]
		[HttpGet]
        [Route("AdvanceReport"), ResponseType(typeof(IList<JobAdvanceReportFilter>))]
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(long customerId, string entity)
		{
			_jobAdvanceReportCommands.ActiveUser = ActiveUser;
			return _jobAdvanceReportCommands.GetDropDownDataForProgram(ActiveUser, customerId, entity);
		}
	}
}