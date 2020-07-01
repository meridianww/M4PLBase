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