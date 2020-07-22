#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using DevExpress.DashboardWeb.Mvc;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web
{
	public class RouteConfig
	{
		public static void RegisterRoutes(RouteCollection routes)
		{
			routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
			routes.IgnoreRoute("{resource}.ashx/{*pathInfo}");
			routes.MapRoute(
				"Default",
				"{controller}/{action}/{id}",
				new { controller = "MvcBase", action = MvcConstants.ActionIndex, id = UrlParameter.Optional }
			);
			routes.MapDashboardRoute("api/dashboard");
		}
	}
}