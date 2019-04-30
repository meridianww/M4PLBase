/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 AppDashboardView
//Purpose:                                      Represents AppDashboard Details
//====================================================================================================================================================*/

using M4PL.Entities;
using System;
using System.Linq;

namespace M4PL.APIClient.ViewModels
{
    public class AppDashboardView : AppDashboard
    {
        string controllerName;
        bool canEdit;

        public AppDashboardView()
        {

        }

        public AppDashboardView(string controllerName, bool canEdit = false)
        {
            this.canEdit = canEdit;
            this.controllerName = controllerName;
        }

        public string ControllerName { get { return controllerName; } }

        public bool UserHasExportPermission
        {
            get
            {
                return true;
            }
        }

        public bool UserCanOpenDashboard
        {
            get
            {
                return true;
            }
        }
    }
}
