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
//Program Name:                                 TreeListResult
//Purpose:                                      Represents description for TreeListResult
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
	public class TreeListResult
	{
		public string KeyFieldName { get; set; }
		public string ParentFieldName { get; set; }
		public string SelectedNode { get; set; }
		public MvcRoute CallBackRoute { get; set; }
		public MvcRoute DragAndDropRoute { get; set; }
		public MvcRoute MenuRouteCallBack { get; set; }
		public MvcRoute ContentRouteCallBack { get; set; }
		public IList<Filter> Filters { get; set; }
		public ICommonCommands CommonCommands { get; set; }
		public TreeListSettings TreeListSettings { get; set; }
	}
}