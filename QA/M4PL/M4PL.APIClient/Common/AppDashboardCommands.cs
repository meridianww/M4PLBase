/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AppDashboardCommands
//Purpose:                                      Client to consume M4PL API called APIController
//====================================================================================================================================================*/

namespace M4PL.APIClient.Common
{
    public class AppDashboardCommands : BaseCommands<ViewModels.AppDashboardView>, IAppDashboardCommands
    {
        /// <summary>
        /// Route to call Dashboards
        /// </summary>
        public override string RouteSuffix
        {
            get { return "AppDashboards"; }
        }
    }
}