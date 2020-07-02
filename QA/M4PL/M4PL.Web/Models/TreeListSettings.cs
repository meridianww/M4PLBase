#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 TreeListSettings
//Purpose:                                      Represents description for TreeListSettings
//====================================================================================================================================================*/

namespace M4PL.Web.Models
{
	public class TreeListSettings
	{
		public TreeListSettings()
		{
			AllowCheckNodes = true;
			AllowSelectNode = true;
			EnableAnimation = true;
			EnableHotTrack = true;
			ShowTreeLines = true;
			ShowExpandButtons = true;
		}

		public bool AllowCheckNodes { get; set; }
		public bool AllowSelectNode { get; set; }
		public bool CheckNodesRecursive { get; set; }
		public bool EnableAnimation { get; set; }
		public bool EnableHotTrack { get; set; }
		public bool ShowTreeLines { get; set; }
		public bool ShowExpandButtons { get; set; }
		public bool AllowDragDrop { get; set; }
	}
}