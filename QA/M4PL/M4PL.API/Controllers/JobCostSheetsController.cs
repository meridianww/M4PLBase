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
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
   
    [CustomAuthorize]
    [RoutePrefix("api/JobCostSheets")]
    public class JobCostSheetsController : ApiController
    {
        private readonly IJobCostSheetCommands _jobRefCostSheetsCommands;
        /// <summary>
        /// Fucntion to get Job's CostSheets details
        /// </summary>
        /// <param name="jobCostSheetsCommands"></param>
        public JobCostSheetsController(IJobCostSheetCommands jobCostSheetsCommands)

        {
            _jobRefCostSheetsCommands = jobCostSheetsCommands;
        }

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobCostSheet> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobCostSheet.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobCostSheet Get(long id)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobCostSheet object passed as parameter.
        /// </summary>
        /// <param name="jobCostSheet">Refers to jobCostSheet object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobCostSheet Post(JobCostSheet jobCostSheet)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Post(jobCostSheet);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobCostSheet object passed.
        /// </summary>
        /// <param name="jobCostSheet">Refers to jobCostSheet object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobCostSheet Put(JobCostSheet jobCostSheet)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Put(jobCostSheet);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobCostSheet object passed.
        /// </summary>
        /// <param name="jobCostSheet">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobCostSheet Patch(JobCostSheet jobCostSheet)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.Patch(jobCostSheet);
        }
        /// <summary>
        /// GetJobCostCodeAction method is used to get cost details associated with particular Order/Job.
        /// </summary>
        /// <param name="jobId"> 
        /// jobId(type numeric) parameter refer to Order/Job id.
        /// </param>
        /// <returns>
        /// Returns response as queryable list of JobCostCodeAction object based on parameter.
        /// </returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("JobCostCodeAction")]
        public IQueryable<JobCostCodeAction> GetJobCostCodeAction(long jobId)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.GetJobCostCodeAction(jobId).AsQueryable();
        }
        /// <summary>
        /// JobCostCodeByProgram method is used get Cost Rate details for particular orderid/jobid.
        /// </summary>
        /// <param name="id"> 
        /// Refer to Record Id(type numeric) for Cost Rate. 
        /// </param>
        /// <param name="jobId"> 
        /// Refer to Order/Job Id(type numeric) for Cost Rate. 
        /// </param>
        /// <returns>
        /// Returns response as JobCostSheet object based on parameters.
        /// </returns>
        [HttpGet]
        [Route("JobCostCodeByProgram")]
        public JobCostSheet JobCostCodeByProgram(long id, long jobId)
        {
            _jobRefCostSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefCostSheetsCommands.JobCostCodeByProgram(id, jobId);
        }
    }
}