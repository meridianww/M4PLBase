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
//Purpose:                                      End point to interact with Reorts
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Reports
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/Reports")]
    public class ReportsController : ApiController
    {
        private readonly IReportCommands _reportCommands;

        /// <summary>
        /// Function to get Administration's menu driver details
        /// </summary>
        /// <param name="reportCommands"></param>
        public ReportsController(IReportCommands reportCommands)

        {
            _reportCommands = reportCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<Report> PagedData(PagedDataInfo pagedDataInfo)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the report.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Report Get(long id)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new report object passed as parameter.
        /// </summary>
        /// <param name="report">Refers to report object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Report Post(Report report)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Post(report);
        }

        /// <summary>
        /// Put method is used to update record values completely based on report object passed.
        /// </summary>
        /// <param name="report">Refers to report object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Report Put(Report report)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Put(report);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Delete(id);
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
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on report object passed.
        /// </summary>
        /// <param name="report">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Report Patch(Report report)
        {
            _reportCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _reportCommands.Patch(report);
        }
    }
}