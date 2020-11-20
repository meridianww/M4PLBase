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
//Program Name:                                 OrganizationFinancialCalender
//Purpose:                                      End point to interact with Organization Financial Calender module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;


namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Organization Financial Calendar
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/OrgFinancialCalendars")]
    public class OrgFinancialCalendarsController : ApiController
    {
        private readonly IOrgFinancialCalendarCommands _orgFinancialCalendarCommands;

        /// <summary>
        /// Function to get Organization financial calender details
        /// </summary>
        /// <param name="orgFinancialCalendarCommands"></param>
        public OrgFinancialCalendarsController(IOrgFinancialCalendarCommands orgFinancialCalendarCommands)
        
        {
            _orgFinancialCalendarCommands = orgFinancialCalendarCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<OrgFinancialCalendar> PagedData(PagedDataInfo pagedDataInfo)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the orgFinancialCalendar.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual OrgFinancialCalendar Get(long id)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new orgFinancialCalendar object passed as parameter.
        /// </summary>
        /// <param name="orgFinancialCalendar">Refers to orgFinancialCalendar object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual OrgFinancialCalendar Post(OrgFinancialCalendar orgFinancialCalendar)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Post(orgFinancialCalendar);
        }

        /// <summary>
        /// Put method is used to update record values completely based on orgFinancialCalendar object passed.
        /// </summary>
        /// <param name="orgFinancialCalendar">Refers to orgFinancialCalendar object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual OrgFinancialCalendar Put(OrgFinancialCalendar orgFinancialCalendar)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Put(orgFinancialCalendar);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Delete(id);
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
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on orgFinancialCalendar object passed.
        /// </summary>
        /// <param name="orgFinancialCalendar">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual OrgFinancialCalendar Patch(OrgFinancialCalendar orgFinancialCalendar)
        {
            _orgFinancialCalendarCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgFinancialCalendarCommands.Patch(orgFinancialCalendar);
        }
    }
}