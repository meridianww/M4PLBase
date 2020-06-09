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
    [RoutePrefix("api/JobBillableSheets")]
    public class JobBillableSheetsController : BaseApiController<JobBillableSheet>
    {
        private readonly IJobBillableSheetCommands _jobRefBillableSheetsCommands;

        public JobBillableSheetsController(IJobBillableSheetCommands jobBillableSheetsCommands)
            : base(jobBillableSheetsCommands)
        {
            _jobRefBillableSheetsCommands = jobBillableSheetsCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("JobBillableCodeAction")]
        public IQueryable<JobPriceCodeAction> GetJobBillableCodeAction(long jobId)
        {
            _jobRefBillableSheetsCommands.ActiveUser = ActiveUser;
            return _jobRefBillableSheetsCommands.GetJobPriceCodeAction(jobId).AsQueryable();
        }

        [HttpGet]
        [Route("JobBillableCodeByProgram")]
        public JobBillableSheet JobBillableCodeByProgram(long id, long jobId)
        {
            _jobRefBillableSheetsCommands.ActiveUser = ActiveUser;
            return _jobRefBillableSheetsCommands.JobPriceCodeByProgram(id, jobId);
        }
    }
}