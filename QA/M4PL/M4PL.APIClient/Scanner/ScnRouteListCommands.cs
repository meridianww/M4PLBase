#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Janardana
// Date Programmed:                              28/07/2018
// Program Name:                                 ScnRouteListCommands
// Purpose:                                      Client to consume M4PL API called ScnRouteListController
//=================================================================================================================

namespace M4PL.APIClient.Scanner
{
	public class ScnRouteListCommands : BaseCommands<ViewModels.Scanner.ScnRouteListView>, IScnRouteListCommands
	{
		/// <summary>
		/// Route to call ScnRouteList
		/// </summary>
		public override string RouteSuffix
		{
			get { return "ScnRouteLists"; }
		}
	}
}