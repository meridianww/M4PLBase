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
//Program Name:                                 VendorFinancialCalendars
//Purpose:                                      End point to interact with Vendor Financial Calendars module
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
    [CustomAuthorize]
    [RoutePrefix("api/VendFinancialCalendars")]
    public class VendFinancialCalendarsController : ApiController
    {
        private readonly IVendFinancialCalendarCommands _vendFinancialCalendarCommands;

        /// <summary>
        /// Function to get Vendor's Financial Calender details
        /// </summary>
        /// <param name="vendFinancialCalendarCommands"></param>
        public VendFinancialCalendarsController(IVendFinancialCalendarCommands vendFinancialCalendarCommands)
        {
            _vendFinancialCalendarCommands = vendFinancialCalendarCommands;
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
        public virtual IQueryable<VendFinancialCalendar> PagedData(PagedDataInfo pagedDataInfo)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the vendFinancialCalendar.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual VendFinancialCalendar Get(long id)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new vendFinancialCalendar object passed as parameter.
        /// </summary>
        /// <param name="vendFinancialCalendar">Refers to vendFinancialCalendar object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual VendFinancialCalendar Post(VendFinancialCalendar vendFinancialCalendar)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Post(vendFinancialCalendar);
        }

        /// <summary>
        /// Put method is used to update record values completely based on vendFinancialCalendar object passed.
        /// </summary>
        /// <param name="vendFinancialCalendar">Refers to vendFinancialCalendar object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual VendFinancialCalendar Put(VendFinancialCalendar vendFinancialCalendar)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Put(vendFinancialCalendar);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Delete(id);
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
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on vendFinancialCalendar object passed.
        /// </summary>
        /// <param name="vendFinancialCalendar">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual VendFinancialCalendar Patch(VendFinancialCalendar vendFinancialCalendar)
        {
            _vendFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendFinancialCalendarCommands.Patch(vendFinancialCalendar);
        }
    }
}