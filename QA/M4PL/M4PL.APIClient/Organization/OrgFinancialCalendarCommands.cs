/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 OrgFinancialCalendarCommands
Purpose:                                      Client to consume M4PL API called OrgFinancialCalendarController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    public class OrgFinancialCalendarCommands : BaseCommands<OrgFinancialCalendarView>, IOrgFinancialCalendarCommands
    {
        /// <summary>
        /// Route to call OrgFinancialCalenders
        /// </summary>
        public override string RouteSuffix
        {
            get { return "OrgFinancialCalendars"; }
        }
    }
}