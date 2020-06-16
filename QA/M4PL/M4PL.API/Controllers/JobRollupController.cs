/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              11/12/2019
//Program Name:                                 JobRollup
//====================================================================================================================================================*/

using M4PL.Business.JobRollup;
using M4PL.Entities.JobRollup;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobRollup")]
    public class JobRollupController : BaseApiController<JobRollupList>
    {
        private readonly IJobRollupCommands _jobRollupCommands;

        /// <summary>
        /// Function to get Job's Roll up details
        /// </summary>
        /// <param name="jobRollupCommands">jobRollupCommands</param>
        public JobRollupController(IJobRollupCommands jobRollupCommands)
            : base(jobRollupCommands)
        {
            _jobRollupCommands = jobRollupCommands;
        }

        [HttpGet]
        [Route("GetRollupByProgram")]
        public List<JobRollupList> GetRollupByProgram(long programId)
        {
            return _jobRollupCommands.GetRollupByProgram(programId);
        }

        [HttpGet]
        [Route("GetRollupByJob")]
        public List<JobRollupList> GetRollupByJob(long jobId)
        {
            return _jobRollupCommands.GetRollupByJob(jobId);
        }
    }
}