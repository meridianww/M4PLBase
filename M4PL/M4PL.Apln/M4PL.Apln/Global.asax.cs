using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using DevExpress.Web.Mvc;

namespace M4PL_Apln
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static string Theme { get; set; }
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();
        }

        public void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Theme) && Theme.Length > 0)
            {
                DevExpressHelper.Theme = Theme;
                DevExpress.Web.ASPxWebControl.GlobalTheme = Theme;
            }
            else
            {
                DevExpressHelper.Theme = "Mulberry";
                DevExpress.Web.ASPxWebControl.GlobalTheme = "Office2010Black";
            }
        }
    }
}