#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 AppDashboardView
// Purpose:                                      Represents AppDashboard Details
//====================================================================================================================================================

using M4PL.Entities;

namespace M4PL.APIClient.ViewModels
{
	public class AppDashboardView : AppDashboard
	{
		private string controllerName;
		private bool canEdit;

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