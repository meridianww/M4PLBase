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
using M4PL.Entities.Job;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobBillableSheets
    /// </summary>
	[RoutePrefix("api/JobBillableSheets")]
	public class JobBillableSheetsController : BaseApiController<JobBillableSheet>
	{
		private readonly IJobBillableSheetCommands _jobRefBillableSheetsCommands;

        /// <summary>
        /// JobBillableSheets constructor
        /// </summary>
        /// <param name="jobBillableSheetsCommands"></param>
		public JobBillableSheetsController(IJobBillableSheetCommands jobBillableSheetsCommands)
			: base(jobBillableSheetsCommands)
		{
			_jobRefBillableSheetsCommands = jobBillableSheetsCommands;
		}

        /// <summary>
        /// Get job billable code action by job id 
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
		[CustomAuthorize]
		[HttpGet]
        [Route("JobBillableCodeAction"), ResponseType(typeof(IQueryable<JobPriceCodeAction>))]
        public IQueryable<JobPriceCodeAction> GetJobBillableCodeAction(long jobId)
		{
			_jobRefBillableSheetsCommands.ActiveUser = ActiveUser;
			return _jobRefBillableSheetsCommands.GetJobPriceCodeAction(jobId).AsQueryable();
		}

        /// <summary>
        /// Get the job billable code program by Id, If Id is 0 basic details come from program will be returned
        /// </summary>
        /// <param name="id"></param>
        /// <param name="jobId"></param>
        /// <returns></returns>
		[HttpGet]
        [Route("JobBillableCodeByProgram"), ResponseType(typeof(JobBillableSheet))]
        public JobBillableSheet JobBillableCodeByProgram(long id, long jobId)
		{
			_jobRefBillableSheetsCommands.ActiveUser = ActiveUser;
			return _jobRefBillableSheetsCommands.JobPriceCodeByProgram(id, jobId);
		}
	}
}