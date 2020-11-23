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
    /// JobXcblInfosController
    /// </summary>
    
    [CustomAuthorize]
    [RoutePrefix("api/JobXcblInfos")]
    public class JobXcblInfosController : ApiController
    {
        private readonly IJobXcblInfoCommands _jobXcblInfoCommands;

        /// <summary>
        /// Function to get Job's Cargo details
        /// </summary>
        /// <param name="jobXcblInfoCommands">jobXcblInfoCommands</param>
        public JobXcblInfosController(IJobXcblInfoCommands jobXcblInfoCommands)
        {
            _jobXcblInfoCommands = jobXcblInfoCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobXcblInfo> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobXcblInfo.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobXcblInfo Get(long id)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobXcblInfo object passed as parameter.
        /// </summary>
        /// <param name="jobXcblInfo">Refers to jobXcblInfo object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobXcblInfo Post(JobXcblInfo jobXcblInfo)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Post(jobXcblInfo);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobXcblInfo object passed.
        /// </summary>
        /// <param name="jobXcblInfo">Refers to jobXcblInfo object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobXcblInfo Put(JobXcblInfo jobXcblInfo)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Put(jobXcblInfo);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Delete(id);
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
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobXcblInfo object passed.
        /// </summary>
        /// <param name="jobXcblInfo">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobXcblInfo Patch(JobXcblInfo jobXcblInfo)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.Patch(jobXcblInfo);
        }
        /// <summary>
        /// It will compare the changes with job current values and XBCL values recieved from customer and detected changes eligible for mannual approve will be returned.
        /// </summary>
        /// <param name="jobId">jobId</param>
        /// <param name="gatewayId">gateway Id</param>
        /// <returns>List of changes for mannual review</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("GetJobXcblInfo"), ResponseType(typeof(JobXcblInfo))]
        public JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.GetJobXcblInfo(jobId, gatewayId);
        }

        /// <summary>
        /// It will approve the xcbl changes for supplied job id and gateway id. Then it will update the changes the Job. 
        /// </summary>
        /// <param name="jobId">job Id</param>
        /// <param name="gatewayId">gateway id</param>
        /// <returns>Returns true if the changes approved successfully else false.</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("AcceptJobXcblInfo"), ResponseType(typeof(bool))]
        public bool AcceptJobXcblInfo(long jobId, long gatewayId)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.AcceptJobXcblInfo(jobId, gatewayId);
        }

        /// <summary>
        /// It will reject the xcbl changes for supplied gateway id. It will NOT update any changes the Job. 
        /// </summary>
        /// <param name="gatewayId"><Gateway Id/param>
        /// <returns></returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("RejectJobXcblInfo"), ResponseType(typeof(bool))]
        public bool RejectJobXcblInfo(long gatewayId)
        {
            _jobXcblInfoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobXcblInfoCommands.RejectJobXcblInfo(gatewayId);
        }
    }
}