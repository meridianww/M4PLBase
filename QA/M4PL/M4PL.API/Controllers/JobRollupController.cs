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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              11/12/2019
//Program Name:                                 JobRollup
//====================================================================================================================================================*/

using M4PL.Business.JobRollup;
using M4PL.Entities.JobRollup;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobRollup")]
	public class JobRollupController : ApiController
	{
		private readonly IJobRollupCommands _jobRollupCommands;

		/// <summary>
		/// Function to get Job's Roll up details
		/// </summary>
		/// <param name="jobRollupCommands">jobRollupCommands</param>
		public JobRollupController(IJobRollupCommands jobRollupCommands)
		{
			_jobRollupCommands = jobRollupCommands;
		}

        /// <summary>
        /// Get the rollup list by program Id, List contains distinct columns where all of them are completed. 
        /// </summary>
        /// <param name="programId">program id</param>
        /// <returns>Rollup List</returns>
		[HttpGet]
		[Route("GetRollupByProgram"), ResponseType(typeof(List<JobRollupList>))]
		public List<JobRollupList> GetRollupByProgram(long programId)
		{
			return _jobRollupCommands.GetRollupByProgram(programId);
		}

        /// <summary>
        /// Get the rollup list by program Id, List contains distinct columns where all of them are completed. 
        /// </summary>
        /// <param name="jobId">job id</param>
        /// <returns>Rollup List</returns>
		[HttpGet]
		[Route("GetRollupByJob"),ResponseType(typeof(List<JobRollupList>))]
		public List<JobRollupList> GetRollupByJob(long jobId)
		{
			return _jobRollupCommands.GetRollupByJob(jobId);
		}
	}
}