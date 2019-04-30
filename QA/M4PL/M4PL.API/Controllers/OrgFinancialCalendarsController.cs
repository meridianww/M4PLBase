/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationFinancialCalender
//Purpose:                                      End point to interact with Organization Financial Calender module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgFinancialCalendars")]
    public class OrgFinancialCalendarsController : BaseApiController<OrgFinancialCalendar>
    {
        private readonly IOrgFinancialCalendarCommands _orgFinancialCalendarCommands;

        /// <summary>
        /// Function to get Organization financial calender details
        /// </summary>
        /// <param name="orgFinancialCalendarCommands"></param>
        public OrgFinancialCalendarsController(IOrgFinancialCalendarCommands orgFinancialCalendarCommands)
            : base(orgFinancialCalendarCommands)
        {
            _orgFinancialCalendarCommands = orgFinancialCalendarCommands;
        }
    }
}