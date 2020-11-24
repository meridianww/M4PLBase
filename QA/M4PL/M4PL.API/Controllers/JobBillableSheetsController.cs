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
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobBillableSheets Controller
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobBillableSheets")]
	public class JobBillableSheetsController : ApiController
	{
		private readonly IJobBillableSheetCommands _jobRefBillableSheetsCommands;

        /// <summary>
        /// JobBillableSheets constructor
        /// </summary>
        /// <param name="jobBillableSheetsCommands"></param>
		public JobBillableSheetsController(IJobBillableSheetCommands jobBillableSheetsCommands)
			
		{
			_jobRefBillableSheetsCommands = jobBillableSheetsCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobBillableSheet> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobBillableSheet.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobBillableSheet Get(long id)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobBillableSheet object passed as parameter.
        /// </summary>
        /// <param name="jobBillableSheet">Refers to jobBillableSheet object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobBillableSheet Post(JobBillableSheet jobBillableSheet)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Post(jobBillableSheet);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobBillableSheet object passed.
        /// </summary>
        /// <param name="jobBillableSheet">Refers to jobBillableSheet object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobBillableSheet Put(JobBillableSheet jobBillableSheet)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Put(jobBillableSheet);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Delete(id);
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
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobBillableSheet object passed.
        /// </summary>
        /// <param name="jobBillableSheet">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobBillableSheet Patch(JobBillableSheet jobBillableSheet)
        {
            _jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobRefBillableSheetsCommands.Patch(jobBillableSheet);
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
			_jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser; 
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
			_jobRefBillableSheetsCommands.ActiveUser = Models.ApiContext.ActiveUser; 
			return _jobRefBillableSheetsCommands.JobPriceCodeByProgram(id, jobId);
		}
	}
}