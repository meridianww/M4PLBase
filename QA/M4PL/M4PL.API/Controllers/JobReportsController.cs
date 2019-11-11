/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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
        /// Fucntion to get Jobs reports
        /// </summary> 
        [CustomAuthorize]
        [HttpGet]
        [Route("VocReport")]
        public IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate)
        {
            return _JobReportCommands.GetVocReportData(companyId, locationCode, startDate, endDate);
        }
    }
}