/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendFinancialCalendarCommands
Purpose:                                      Client to consume M4PL API called VendFinancialCalendarController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Route to call VendFinancialCalendars
    /// </summary>
    public class VendFinancialCalendarCommands : BaseCommands<VendFinancialCalendarView>, IVendFinancialCalendarCommands
    {
        public override string RouteSuffix
        {
            get { return "VendFinancialCalendars"; }
        }
    }
}