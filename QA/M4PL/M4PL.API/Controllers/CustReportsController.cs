﻿#region Copyright

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
//Purpose:                                      End point to interact with Customer Reorts
//====================================================================================================================================================*/
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Customer Reports
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/CustReports")]
	public class CustReportsController : ApiController
	{
		private readonly ICustReportCommands _custReportCommands;

		/// <summary>
		/// Fucntion to get Customers reports
		/// </summary>
		/// <param name="custReportCommands"></param>
		public CustReportsController(ICustReportCommands custReportCommands)
			
		{
			_custReportCommands = custReportCommands;
		}
        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustReport> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the custReport.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustReport Get(long id)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new custReport object passed as parameter.
        /// </summary>
        /// <param name="custReport">Refers to custReport object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustReport Post(CustReport custReport)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Post(custReport);
        }

        /// <summary>
        /// Put method is used to update record values completely based on custReport object passed.
        /// </summary>
        /// <param name="custReport">Refers to custReport object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustReport Put(CustReport custReport)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Put(custReport);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Delete(id);
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
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on custReport object passed.
        /// </summary>
        /// <param name="custReport">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustReport Patch(CustReport custReport)
        {
            _custReportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custReportCommands.Patch(custReport);
        }
    }
}