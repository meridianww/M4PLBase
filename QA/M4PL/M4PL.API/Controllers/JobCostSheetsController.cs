/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              25/07/2019
//Program Name:                                 JobCostSheets
//Purpose:                                      End point to interact with Job CostSheets module
//====================================================================================================================================================*/

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