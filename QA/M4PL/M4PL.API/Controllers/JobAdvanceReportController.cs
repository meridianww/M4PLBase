/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
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

namespace M4PL.API.Controllers
{
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
        /// Fucntion to get Jobs reports
        /// </summary> 
        [CustomAuthorize]
        [HttpGet]
        [Route("AdvanceReport")]
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(long customerId, string entity)
        {
            _jobAdvanceReportCommands.ActiveUser = ActiveUser;
            return _jobAdvanceReportCommands.GetDropDownDataForProgram(ActiveUser, customerId, entity);
        }
    }
}