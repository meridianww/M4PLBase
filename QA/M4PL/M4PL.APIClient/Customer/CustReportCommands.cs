/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 CustomerCommands
Purpose:                                      Client to consume M4PL API called CustomerController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Customer;

namespace M4PL.APIClient.Customer
{
    /// <summary>
    /// Route to call Customers
    /// </summary>
    public class CustReportCommands : BaseCommands<CustReportView>, ICustReportCommands
    {
        public override string RouteSuffix
        {
            get { return "CustReports"; }
        }
    }
}