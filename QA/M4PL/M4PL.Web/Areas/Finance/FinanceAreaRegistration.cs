#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance
{
	public class FinanceAreaRegistration : AreaRegistration
	{
		public override string AreaName
		{
			get
			{
				return "Finance";
			}
		}

		public override void RegisterArea(AreaRegistrationContext context)
		{
			context.MapRoute(
				"Finance_default",
				"Finance/{controller}/{action}/{id}",
				new { MvcConstants.ActionIndex, id = UrlParameter.Optional }
			);
		}
	}
}