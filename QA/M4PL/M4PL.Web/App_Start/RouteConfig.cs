/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 RouteConfig
Purpose:                                      Contains the Configuration related to Route
==========================================================================================================*/
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