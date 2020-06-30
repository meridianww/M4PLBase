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
//Date Programmed:                              18/02/2020
//Program Name:                                 JobEDIXcbl
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobXcblInfosController
    /// </summary>
    [RoutePrefix("api/JobXcblInfos")]
    public class JobXcblInfosController : BaseApiController<JobXcblInfo>
    {
        private readonly IJobXcblInfoCommands _jobXcblInfoCommands;

        /// <summary>
        /// Function to get Job's Cargo details
        /// </summary>
        /// <param name="jobXcblInfoCommands">jobXcblInfoCommands</param>
        public JobXcblInfosController(IJobXcblInfoCommands jobXcblInfoCommands)
            : base(jobXcblInfoCommands)
        {
            _jobXcblInfoCommands = jobXcblInfoCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetJobXcblInfo")]
        public JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobXcblInfoCommands.GetJobXcblInfo(jobId, gatewayId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("AcceptJobXcblInfo")]
        public bool AcceptJobXcblInfo(long jobId, long gatewayId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobXcblInfoCommands.AcceptJobXcblInfo(jobId, gatewayId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("RejectJobXcblInfo")]
        public bool RejectJobXcblInfo(long gatewayId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobXcblInfoCommands.RejectJobXcblInfo(gatewayId);
        }

    }
}