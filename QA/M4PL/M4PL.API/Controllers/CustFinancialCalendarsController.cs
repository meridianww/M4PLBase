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
//Program Name:                                 CustFinancialCalendarFinancialCalender
//Purpose:                                      End point to interact with CustFinancialCalendar Financial Calender module
//====================================================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Business.Customer;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Customer Financial Calendar
    /// </summary>
    [RoutePrefix("api/CustFinancialCalendars")]
    [CustomAuthorize]
    public class CustFinancialCalendarsController : ApiController
    {
        private readonly ICustFinancialCalendarCommands _custFinancialCalendarCommands;

        /// <summary>
        /// Fucntion to get CustFinancialCalendar's Financial Calender details
        /// </summary>
        /// <param name="custFinancialCalendarCommands"></param>
        public CustFinancialCalendarsController(ICustFinancialCalendarCommands custFinancialCalendarCommands)

        {
            _custFinancialCalendarCommands = custFinancialCalendarCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustFinancialCalendar> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the custFinancialCalendar.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustFinancialCalendar Get(long id)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new custFinancialCalendar object passed as parameter.
        /// </summary>
        /// <param name="custFinancialCalendar">Refers to custFinancialCalendar object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustFinancialCalendar Post(CustFinancialCalendar custFinancialCalendar)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Post(custFinancialCalendar);
        }

        /// <summary>
        /// Put method is used to update record values completely based on custFinancialCalendar object passed.
        /// </summary>
        /// <param name="custFinancialCalendar">Refers to custFinancialCalendar object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustFinancialCalendar Put(CustFinancialCalendar custFinancialCalendar)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Put(custFinancialCalendar);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Delete(id);
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
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on custFinancialCalendar object passed.
        /// </summary>
        /// <param name="custFinancialCalendar">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustFinancialCalendar Patch(CustFinancialCalendar custFinancialCalendar)
        {
            _custFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custFinancialCalendarCommands.Patch(custFinancialCalendar);
        }


    }
}