#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.FarEye;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Job/Orders
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobUtility")]
    public class JobUtilityController : ApiController
    {
        // GET: JobUtility
        private readonly IJobCommands _jobCommands;

        /// <summary>
        /// Function to get Job details
        /// </summary>
        /// <param name="jobCommands"></param>
        public JobUtilityController(IJobCommands jobCommands)

        {
            _jobCommands = jobCommands;
        }

        /// <summary>
        /// Update a Job to Schedule If it's not done yet and Reschedule if it's scheduled already
        /// </summary>
        /// <param name="jobTrackingUpdateRequest">jobScheduleRequest</param>
        /// <returns>API returns a Status Model object which contains the details about success or failure, in case of failure AdditionalDetail property contains the reson of failure.</returns>
        [HttpPost]
        [Route("AddJobIsSchedule"), ResponseType(typeof(StatusModel))]
        public StatusModel AddJobIsSchedule(JobTrackingUpdateRequest jobTrackingUpdateRequest)
        {
            if (jobTrackingUpdateRequest == null)
            {
                return new StatusModel()
                {
                    Status = "Failure",
                    StatusCode = (int)HttpStatusCode.PreconditionFailed,
                    AdditionalDetail = "Input parameter should not be null."
                };
            }

            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.AddJobIsSchedule(jobTrackingUpdateRequest);
        }

        /// <summary>
        /// API is use to re-activate an archived order
        /// </summary>
        /// <param name="jobId">jobId</param>
        /// <returns>true if activated successfully else false.</returns>
        [HttpGet]
        [Route("ReactivateJob"), ResponseType(typeof(StatusModel))]
        public StatusModel ReactivateJob(long jobId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.ReactivateJob(jobId);
        }

        /// <summary>
        /// A job comment(Job Tracking tab => comment) will be created for the supplied job Id with the title mentioned and once its saved successfully rich text editor also saved for the comment with mentioned gateway comment.
        /// </summary>
        /// <param name="comment">Gateway comment input, Gateway Title is used as comment title and Gateway comment is used in Rich text editor</param>
        /// <returns>Returns true if its saved successfully else false.</returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("Gateway/Comment"), ResponseType(typeof(bool))]
        public bool InsertJobComment(JobComment comment)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.InsertJobComment(comment);
        }

        /// <summary>
        /// A gateway will be created for a job and it will be copied from program by GatewayStatusCode. Job Status code and Job Cargo details will be updated.
        /// </summary>
        /// <param name="jobId">Job Id for which gateway will be added</param>
        /// <param name="gatewayStatusCode">Gateway Status code used to identify gateway from Job</param>
        /// <returns>Returns true if it is inserted scussessfully else false</returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("Gateway/InsertJobGateway"), ResponseType(typeof(bool))]
        public bool InsertJobGateway(JobTrackingUpdateRequest jobTrackingUpdateRequest)
        {
            if (jobTrackingUpdateRequest == null)
            {
                return false;
            }

            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.InsertJobGateway(jobTrackingUpdateRequest.JobId, jobTrackingUpdateRequest.StatusCode, jobTrackingUpdateRequest.GatewayACD);
        }
    }
}