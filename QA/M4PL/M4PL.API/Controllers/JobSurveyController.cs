﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              09/11/2019
//Program Name:                                 JobSurvey
//Purpose:                                      End point to interact with Survey module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Survey;
using M4PL.Entities.Survey;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Job Survey Controller
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/Survey")]
    public class JobSurveyController : BaseApiController<JobSurvey>
    {
        private readonly IJobSurveyCommands _jobSurveyCommands;

        /// <summary>
        /// Function to get the Contact details
        /// </summary>
        /// <param name="jobSurveyCommands">jobSurveyCommands</param>
        public JobSurveyController(IJobSurveyCommands jobSurveyCommands)
            : base(jobSurveyCommands)
        {
            _jobSurveyCommands = jobSurveyCommands;
        }

        /// <summary>
        /// Get the survey information for a particular Job
        /// </summary>
        /// <param name="jobId">jobId</param>
        [HttpGet]
        [Route("{jobId:long}/job")]
        public JobSurvey GetJobSurvey(long jobId)
        {
            return _jobSurveyCommands.GetJobSurvey(null, jobId);
        }
    }
}