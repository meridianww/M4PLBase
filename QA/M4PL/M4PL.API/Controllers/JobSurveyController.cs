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
//Date Programmed:                              09/11/2019
//Program Name:                                 JobSurvey
//Purpose:                                      End point to interact with Survey module
//====================================================================================================================================================*/

using M4PL.Business.Survey;
using M4PL.Entities.Survey;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Job Survey Controller
	/// </summary>
	[AllowAnonymous]
	[RoutePrefix("api/Survey")]
	public class JobSurveyController : ApiController
	{
		private readonly IJobSurveyCommands _jobSurveyCommands;

		/// <summary>
		/// Function to get the Contact details
		/// </summary>
		/// <param name="jobSurveyCommands">jobSurveyCommands</param>
		public JobSurveyController(IJobSurveyCommands jobSurveyCommands)
		
		{
			_jobSurveyCommands = jobSurveyCommands;
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
        public virtual IQueryable<JobSurvey> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobSurvey.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobSurvey Get(long id)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobSurvey object passed as parameter.
        /// </summary>
        /// <param name="jobSurvey">Refers to jobSurvey object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobSurvey Post(JobSurvey jobSurvey)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Post(jobSurvey);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobSurvey object passed.
        /// </summary>
        /// <param name="jobSurvey">Refers to jobSurvey object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobSurvey Put(JobSurvey jobSurvey)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Put(jobSurvey);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Delete(id);
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
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobSurvey object passed.
        /// </summary>
        /// <param name="jobSurvey">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobSurvey Patch(JobSurvey jobSurvey)
        {
            _jobSurveyCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSurveyCommands.Patch(jobSurvey);
        }
        /// <summary>
        /// Get the survey information for a particular Job by job id
        /// </summary>
        /// <param name="jobId">jobId</param>
        /// <returns>Job Seurvery record</returns>
        [HttpGet]
		[Route("{jobId}/job"),ResponseType(typeof(JobSurvey))]
		public JobSurvey GetJobSurvey(string jobId)
		{
			long updatedJobId = 0;
			long.TryParse(new string(jobId.ToCharArray().Where(c => char.IsDigit(c)).ToArray()), out updatedJobId);
			return _jobSurveyCommands.GetJobSurvey(null, updatedJobId);
		}

		/// <summary>
		/// Insert Job Survey
		/// </summary>
		/// <param name="jobSurvey">jobSurvey</param>
		/// <returns>true if Saved Successfully Else False</returns>
		[HttpPost]
		[Route("job"),ResponseType(typeof(bool))]
		public bool InsertJobSurvey(JobSurvey jobSurvey)
		{
			return _jobSurveyCommands.InsertJobSurvey(jobSurvey);
		}
	}
}