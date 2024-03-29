﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.CostCode;
using M4PL.Entities.Finance.CostCode;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Nav Related Operations
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/NavCostCode")]
	public class NavCostCodeController : ApiController
	{
		private readonly INavCostCodeCommands _navCostCodeCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavCostCodeController"/> class.
		/// </summary>
		public NavCostCodeController(INavCostCodeCommands navCostCodeCommands)
			
		{
			_navCostCodeCommands = navCostCodeCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<NavCostCode> PagedData(PagedDataInfo pagedDataInfo)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the navCostCode.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual NavCostCode Get(long id)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new navCostCode object passed as parameter.
        /// </summary>
        /// <param name="navCostCode">Refers to navCostCode object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual NavCostCode Post(NavCostCode navCostCode)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Post(navCostCode);
        }

        /// <summary>
        /// Put method is used to update record values completely based on navCostCode object passed.
        /// </summary>
        /// <param name="navCostCode">Refers to navCostCode object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual NavCostCode Put(NavCostCode navCostCode)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Put(navCostCode);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Delete(id);
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
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on navCostCode object passed.
        /// </summary>
        /// <param name="navCostCode">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual NavCostCode Patch(NavCostCode navCostCode)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.Patch(navCostCode);
        }
        /// <summary>
        /// Gets list of all Cost Codes from NAV
        /// </summary>
        /// <returns></returns>
        [HttpGet]
		[Route("GetAllCostCode")]
		public virtual IList<NavCostCode> GetAllCostCode()
		{
			_navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.GetAllCostCode();
		}
        /// <summary>
        /// Gets Document for Cost Code from NAV for Supplied JobId
        /// </summary>
        /// <param name="jobId">JobId</param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetCostCodeReportByJobId")]
        public virtual Entities.Document.DocumentData GetCostCodeReportByJobId( string jobId)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.GetCostCodeReportByJobId(jobId);
        }
        /// <summary>
        /// Checks if Cost Code Data available in NAV for a supplied JobId
        /// </summary>
        /// <param name="jobId">JobId</param>
        /// <returns></returns>
        [HttpGet]
        [Route("IsCostCodeDataPresentForJobInNAV")]
        public virtual Entities.Document.DocumentStatus IsCostCodeDataPresentForJobInNAV(string jobId)
        {
            _navCostCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCostCodeCommands.IsCostCodeDataPresentForJobInNAV(jobId);
        }
    }
}