/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerFinancialCalender
//Purpose:                                      End point to interact with Customer Financial Calender module
//====================================================================================================================================================*/

using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustFinancialCalendars")]
    public class CustFinancialCalendarsController : BaseApiController<CustFinancialCalendar>
    {
        private readonly ICustFinancialCalendarCommands _custFinancialCalendarCommands;

        /// <summary>
        /// Fucntion to get Customer's Financial Calender details
        /// </summary>
        /// <param name="custFinancialCalendarCommands"></param>
        public CustFinancialCalendarsController(ICustFinancialCalendarCommands custFinancialCalendarCommands)
            : base(custFinancialCalendarCommands)
        {
            _custFinancialCalendarCommands = custFinancialCalendarCommands;
        }
    }
}