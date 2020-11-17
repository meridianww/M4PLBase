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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 Reports
//Purpose:                                      End point to interact with Vendor Reorts
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// This Controller handles DB operations for Vendor Reports
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/VendReports")]
	public class VendReportsController : ApiController
	{
		private readonly IVendReportCommands _VendReportCommands;

		/// <summary>
		/// Fucntion to get Vendors reports
		/// </summary>
		/// <param name="vendReportCommands"></param>
		public VendReportsController(IVendReportCommands vendReportCommands)
		
		{
			_VendReportCommands = vendReportCommands;
		}

        /// <summary>
        /// Gets the Page Data(RecordSet) to feed the DataGrid
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<VendReport> PagedData(PagedDataInfo pagedDataInfo)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the vendReport.
        /// </summary>
        /// <param name="id">Refer to  Report Id as numeric value. (refers to SYSTM000Ref_Report table Id)</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual VendReport Get(long id)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new vendReport object passed as parameter.
        /// </summary>
        /// <param name="vendReport"></param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual VendReport Post(VendReport vendReport)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Post(vendReport);
        }

        /// <summary>
        /// Put method is used to update record values completely based on vendReport object passed.
        /// </summary>
        /// <param name="vendReport"></param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual VendReport Put(VendReport vendReport)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Put(vendReport);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive. (refers to SYSTM000Ref_Report table Id)</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Delete(id);
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
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on vendReport object passed.
        /// </summary>
        /// <param name="vendReport"></param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual VendReport Patch(VendReport vendReport)
        {
            _VendReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _VendReportCommands.Patch(vendReport);
        }
    }
}