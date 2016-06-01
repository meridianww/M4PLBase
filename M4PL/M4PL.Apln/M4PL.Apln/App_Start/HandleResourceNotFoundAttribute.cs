using M4PL.Entities;
using M4PL_Apln.Controllers;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL_Apln.App_Start
{
    public class HandleResourceNotFoundAttribute : FilterAttribute, IExceptionFilter
    {
        public void OnException(ExceptionContext context)
        {
            Controller ctrl = context.Controller as Controller;
            if (ctrl == null || context.ExceptionHandled)
                return;

            Exception exception = context.Exception;
            if (exception == null)
                return;

            // Action method exceptions will be wrapped in a
            // TargetInvocationException since they're invoked using 
            // reflection, so we have to unwrap it.
            if (exception is TargetInvocationException)
                exception = exception.InnerException;

            context.ExceptionHandled = true;
            context.HttpContext.Response.Clear();
            context.HttpContext.Response.StatusCode = 404;

            this.ErrorLog(exception);
        }

        void ErrorLog(Exception exception)
        {
            var httpContext = HttpContext.Current;
            var currentController = "";
            var currentAction = "Index";
            var currentRouteData = RouteTable.Routes.GetRouteData(new HttpContextWrapper(httpContext));

            if (currentRouteData != null)
            {
                if (currentRouteData.Values["controller"] != null && !string.IsNullOrEmpty(currentRouteData.Values["controller"].ToString()))
                    currentController = currentRouteData.Values["controller"].ToString();

                if (currentRouteData.Values["action"] != null && !string.IsNullOrEmpty(currentRouteData.Values["action"].ToString()))
                    currentAction = currentRouteData.Values["action"].ToString();

                var controller = new ErrorPageController();
                var routeData = new RouteData();
                var action = "Index";

                if (exception is HttpException)
                {
                    var httpEx = exception as HttpException;
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
                httpContext.Response.StatusCode = exception is HttpException ? ((HttpException)exception).GetHttpCode() : 500;
                httpContext.Response.TrySkipIisCustomErrors = true;

                routeData.Values["controller"] = "ErrorPage";
                routeData.Values["action"] = action;

                if (exception != null)
                {
                    BAL_ErrorLog.LogException(new LogError
                    {
                        UserName = "",
                        ApplicationUrl = HttpContext.Current.Request.Url + Environment.NewLine,
                        Message = exception.Message != null ? exception.Message.ToString(CultureInfo.InvariantCulture) : "",
                        Source = exception.Source != null ? exception.Source.ToString(CultureInfo.InvariantCulture) : "",
                        StackTrace = exception.StackTrace != null ? exception.StackTrace.ToString(CultureInfo.InvariantCulture) : ""
                    });
                    controller.ViewData.Model = new HandleErrorInfo(exception ?? new Exception(), currentController, currentAction);
                }
                ((IController)controller).Execute(new RequestContext(new HttpContextWrapper(httpContext), routeData));
            }

        }
    }
}