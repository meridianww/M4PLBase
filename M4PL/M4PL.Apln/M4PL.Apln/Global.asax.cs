using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using DevExpress.Web.Mvc;
using M4PL_Apln.Controllers;
using M4PL_BAL;
using M4PL.Entities;
using System.Globalization;

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
            ModelBinders.Binders.DefaultBinder = new DevExpress.Web.Mvc.DevExpressEditorsBinder();
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


        public void Application_Error(object sender, EventArgs e)
        {
            var httpContext = ((MvcApplication)sender).Context;
            var currentController = "";
            var currentAction = "Index";
            var currentRouteData = RouteTable.Routes.GetRouteData(new HttpContextWrapper(httpContext));

            if (currentRouteData != null)
            {
                if (currentRouteData.Values["controller"] != null && !string.IsNullOrEmpty(currentRouteData.Values["controller"].ToString()))
                    currentController = currentRouteData.Values["controller"].ToString();

                if (currentRouteData.Values["action"] != null && !string.IsNullOrEmpty(currentRouteData.Values["action"].ToString()))
                    currentAction = currentRouteData.Values["action"].ToString();

                var ex = Server.GetLastError();
                var controller = new ErrorPageController();
                var routeData = new RouteData();
                var action = "Index";

                if (ex is HttpException)
                {
                    var httpEx = ex as HttpException;
                    switch (httpEx.GetHttpCode())
                    {
                        case 400:
                            action = "Error400";
                            break;
                        case 401:
                            action = "Error401";
                            break;
                        case 500:
                            action = "Error500";
                            break;
                        case 403:
                            action = "Error403";
                            break;
                        case 404:
                            action = "Error404";
                            break;
                        default:
                            action = "Index";
                            break;
                    }
                }

                httpContext.ClearError();
                httpContext.Response.Clear();
                httpContext.Response.StatusCode = ex is HttpException ? ((HttpException)ex).GetHttpCode() : 500;
                httpContext.Response.TrySkipIisCustomErrors = true;

                routeData.Values["controller"] = "ErrorPage";
                routeData.Values["action"] = action;

                if (ex != null)
                {
                    BAL_ErrorLog.LogException(new LogError
                    {
                        UserName = "",
                        ApplicationUrl = HttpContext.Current.Request.Url + Environment.NewLine,
                        Message = ex.Message != null ? ex.Message.ToString(CultureInfo.InvariantCulture) : "",
                        Source = ex.Source != null ? ex.Source.ToString(CultureInfo.InvariantCulture) : "",
                        StackTrace = ex.StackTrace != null ? ex.StackTrace.ToString(CultureInfo.InvariantCulture) : ""
                    });
                    controller.ViewData.Model = new HandleErrorInfo(ex ?? new Exception(), currentController, currentAction);
                }                
                ((IController)controller).Execute(new RequestContext(new HttpContextWrapper(httpContext), routeData));
            }
            else
            {
                Server.ClearError();
                Server.Transfer("/ErrorPage");
            }
        }
      
    }
}