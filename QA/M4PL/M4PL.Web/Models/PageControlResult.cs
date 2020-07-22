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
//Program Name:                                 PageControlResult
//Purpose:                                      Represents description for Page Control Result of the system
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
	public class PageControlResult
	{
		public bool IsPopup { get; set; }

		public IList<PageInfo> PageInfos { get; set; }

		public MvcRoute CallBackRoute { get; set; }

		public string ParentUniqueName { get; set; }

		public int SelectedTabIndex { get; set; }

		public bool EnableTabClick { get; set; }
	}
}