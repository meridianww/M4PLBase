﻿#region Copyright

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
//Date Programmed:                              10/10/2017
//Program Name:                                 ScannerAreaRegistration
//Purpose:                                      Contains route related to ScannerArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Scanner
{
	public class ScannerAreaRegistration : AreaRegistration
	{
		public override string AreaName
		{
			get
			{
				return "Scanner";
			}
		}

		public override void RegisterArea(AreaRegistrationContext context)
		{
			context.MapRoute(
				"Scanner_default",
				"Scanner/{controller}/{action}/{id}",
				new { action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
			);
		}
	}
}