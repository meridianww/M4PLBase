using M4PL.Business;
using System;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace M4PL.API
{
    public class WebApiApplication : HttpApplication
    {
        private static bool _runThrough;
        private static readonly object LockObject = new object();

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            WebApiConfig.Register(Orbit.WebApi.Extensions.Startup.Config);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);

            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        public override void Init()
        {
            base.Init();
            // setup stuff & searches & etc
            lock (LockObject)
            {
                if (!_runThrough)
                    CoreCache.Initialize("EN"); //EN For English Language
            }

            // set run through
            _runThrough = true;
        }

        /// <summary>
        /// Applications the end request.
        /// </summary>
        protected void Application_EndRequest()
        {
            if (Orbit.WebApi.Core.Security.Configuration.Current.CookieAuthenticationEnabled)
            {
                var noResponseItem = HttpContext.Current.Items[string.Concat("remove-", Orbit.WebApi.Core.Security.Configuration.Current.AuthCookieName)];
                if (Convert.ToBoolean(noResponseItem))
                {
                    var rCookie = Context.Request.Cookies[Orbit.WebApi.Core.Security.Configuration.Current.AuthCookieName];
                    if (rCookie != null)
                    {
                        rCookie.Expires = DateTime.Now.AddDays(-1);
                    }

                    Context.Response.Cookies.Remove(Orbit.WebApi.Core.Security.Configuration.Current.AuthCookieName);
                }
            }
        }
    }
}