﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Mvc;
using System.Web.Routing;
using M4PL.EF;
using M4PL.Web.Providers;

namespace M4PL.Web
{
    public class LogAttribute : System.Web.Mvc.ActionFilterAttribute
    {

        private static Guid Identifier;

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            Identifier = Guid.NewGuid();
            Log("OnActionExecuting", filterContext.RouteData);
        }

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            Log("OnActionExecuted", filterContext.RouteData);
        }

        public override void OnResultExecuting(ResultExecutingContext filterContext)
        {
            Log("OnResultExecuting", filterContext.RouteData);
        }

        public override void OnResultExecuted(ResultExecutedContext filterContext)
        {
            Log("OnResultExecuted", filterContext.RouteData);
        }

        private void Log(string methodName, RouteData routeData)
        {
            var dateTime = DateTime.Now;
            var controllerName = routeData.Values["Controller"];
            var actionName = routeData.Values["Action"];
            var message = String.Format("Identity:{0}, {1}- controller:{2} action:{3} DateTime:{4}", 
                Convert.ToString(Identifier), methodName, controllerName, actionName, dateTime);
            
            //DefaultConnection dbContext = new DefaultConnection();
            //dbContext.SYSTM000PerformanceLog.Add(new SYSTM000PerformanceLog()
            //{
            //    Identity = Identifier,
            //    Method = methodName,
            //    Controller = controllerName.ToString(),
            //    Action = actionName.ToString(),
            //    LogDateTime = dateTime
            //});
            //Debug.WriteLine(message);
        }
    }
}