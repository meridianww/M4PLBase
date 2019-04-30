/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustFinancialCalendarCommands
Purpose:                                      Client to consume M4PL API called CustFinancialCalendarController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Customer;

namespace M4PL.APIClient.Customer
{
    public class CustFinancialCalendarCommands : BaseCommands<CustFinancialCalendarView>, ICustFinancialCalendarCommands
    {
        /// <summary>
        /// Route to call Customer Financial Calenders
        /// </summary>
        public override string RouteSuffix
        {
            get { return "CustFinancialCalendars"; }
        }
    }
}