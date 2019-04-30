/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorFinancialCalendars
//Purpose:                                      End point to interact with Vendor Financial Calendars module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendFinancialCalendars")]
    public class VendFinancialCalendarsController : BaseApiController<VendFinancialCalendar>
    {
        private readonly IVendFinancialCalendarCommands _vendFinancialCalendarCommands;

        /// <summary>
        /// Function to get Vendor's Financial Calender details
        /// </summary>
        /// <param name="vendFinancialCalendarCommands"></param>
        public VendFinancialCalendarsController(IVendFinancialCalendarCommands vendFinancialCalendarCommands)
            : base(vendFinancialCalendarCommands)
        {
            _vendFinancialCalendarCommands = vendFinancialCalendarCommands;
        }
    }
}