/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 OrgReportCommands
Purpose:                                      Client to consume M4PL API called OrgReportController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    /// <summary>
    /// Route to call Organizations
    /// </summary>
    public class OrgReportCommands : BaseCommands<OrgReportView>, IOrgReportCommands
    {
        public override string RouteSuffix
        {
            get { return "OrgReports"; }
        }
    }
}