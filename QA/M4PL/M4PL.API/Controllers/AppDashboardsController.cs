/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AppDashboards
//Purpose:                                      End point to interact with App Dashboard
//====================================================================================================================================================*/

using M4PL.Business.Common;
using M4PL.Entities;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/AppDashboards")]
    public class AppDashboardsController : BaseApiController<AppDashboard>
    {
        private readonly IAppDashboardCommands _dashboardCommands;

        /// <summary>
        /// Function to get Administration's menu driver details
        /// </summary>
        /// <param name="dashboardCommands"></param>
        public AppDashboardsController(IAppDashboardCommands dashboardCommands)
            : base(dashboardCommands)
        {
            _dashboardCommands = dashboardCommands;
        }
    }
}