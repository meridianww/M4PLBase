#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Job history/logs service
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobHistorys")]
    public class JobHistorysController : ApiController
    {
        private readonly IJobHistorysCommands _jobHistorysController;

        /// <summary>
        /// Job history/logs constructor with required parameter
        /// </summary>
        /// <param name="jobHistorysController"></param>
        public JobHistorysController(IJobHistorysCommands jobHistorysController)

        {
            _jobHistorysController = jobHistorysController;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobHistory> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobHistory.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobHistory Get(long id)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobHistory object passed as parameter.
        /// </summary>
        /// <param name="jobHistory">Refers to jobHistory object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobHistory Post(JobHistory jobHistory)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Post(jobHistory);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobHistory object passed.
        /// </summary>
        /// <param name="jobHistory">Refers to jobHistory object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobHistory Put(JobHistory jobHistory)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Put(jobHistory);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Delete(id);
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
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobHistory object passed.
        /// </summary>
        /// <param name="jobHistory">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobHistory Patch(JobHistory jobHistory)
        {
            _jobHistorysController.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobHistorysController.Patch(jobHistory);
        }
    }
}