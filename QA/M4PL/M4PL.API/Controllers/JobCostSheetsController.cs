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

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobCostSheets")]
	public class JobCostSheetsController : BaseApiController<JobCostSheet>
	{
		private readonly IJobCostSheetCommands _jobRefCostSheetsCommands;

		//Fucntion to get Job's CostSheets details
		public JobCostSheetsController(IJobCostSheetCommands jobCostSheetsCommands)
			: base(jobCostSheetsCommands)
		{
			_jobRefCostSheetsCommands = jobCostSheetsCommands;
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("JobCostCodeAction")]
		public IQueryable<JobCostCodeAction> GetJobCostCodeAction(long jobId)
		{
			_jobRefCostSheetsCommands.ActiveUser = ActiveUser;
			return _jobRefCostSheetsCommands.GetJobCostCodeAction(jobId).AsQueryable();
		}

		[HttpGet]
		[Route("JobCostCodeByProgram")]
		public JobCostSheet JobCostCodeByProgram(long id, long jobId)
		{
			_jobRefCostSheetsCommands.ActiveUser = ActiveUser;
			return _jobRefCostSheetsCommands.JobCostCodeByProgram(id, jobId);
		}
	}
}