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
//Date Programmed:                              18/02/2020
//Program Name:                                 JobEDIXcbl
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

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
	/// Job EDI xCBL Services
	/// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobEDIXcbl")]
    public class JobEDIXcblController : ApiController
	{
		private readonly IJobEDIXcblCommands _jobEDIXcblCommands;

		/// <summary>
		/// Constructor to get Job's Cargo details
		/// </summary>
		/// <param name="jobEDIXcblCommands">jobEDIXcblCommands</param>
		public JobEDIXcblController(IJobEDIXcblCommands jobEDIXcblCommands)
			
		{
			_jobEDIXcblCommands = jobEDIXcblCommands;
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
        public virtual IQueryable<JobEDIXcbl> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobEDIXcbl.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobEDIXcbl Get(long id)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobEDIXcbl object passed as parameter.
        /// </summary>
        /// <param name="jobEDIXcbl">Refers to jobEDIXcbl object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobEDIXcbl Post(JobEDIXcbl jobEDIXcbl)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Post(jobEDIXcbl);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobEDIXcbl object passed.
        /// </summary>
        /// <param name="jobEDIXcbl">Refers to jobEDIXcbl object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobEDIXcbl Put(JobEDIXcbl jobEDIXcbl)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Put(jobEDIXcbl);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Delete(id);
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
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobEDIXcbl object passed.
        /// </summary>
        /// <param name="jobEDIXcbl">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobEDIXcbl Patch(JobEDIXcbl jobEDIXcbl)
        {
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobEDIXcblCommands.Patch(jobEDIXcbl);
        }
        /// <summary>
        /// POST too Add Electonic transaction for job
        /// </summary>
        /// <param name="jobEDIXcbl"></param>
        /// <returns></returns>
        [CustomAuthorize]
		[HttpPost]
		[Route("ElectronicTransaction"), ResponseType(typeof(long))]
		public long JobAddElectronicTransaction(JobEDIXcbl jobEDIXcbl)
		{
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            JobEDIXcbl updatedJobEDIXcbl = _jobEDIXcblCommands.Post(jobEDIXcbl);

			return updatedJobEDIXcbl != null ? updatedJobEDIXcbl.Id : 0;
		}

		/// <summary>
		/// PUT to update Electonic transaction data for job EDI xCBL
		/// </summary>
		/// <param name="jobEDIXcbl"></param>
		/// <returns>Returns the job EDI xCBL Id.</returns>
		[CustomAuthorize]
		[HttpPut]
		[Route("ElectronicTransaction"), ResponseType(typeof(long))]
		public long JobUpdateElectronicTransaction(JobEDIXcbl jobEDIXcbl)
		{
            _jobEDIXcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            JobEDIXcbl updatedJobEDIXcbl = _jobEDIXcblCommands.Put(jobEDIXcbl);

			return updatedJobEDIXcbl != null ? updatedJobEDIXcbl.Id : 0;
		}
	}
}