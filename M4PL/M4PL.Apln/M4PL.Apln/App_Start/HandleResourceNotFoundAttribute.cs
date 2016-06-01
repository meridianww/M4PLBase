using M4PL.Entities;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

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

            BAL_ErrorLog.LogException(new LogError
            {
                UserName = "",
                ApplicationUrl = HttpContext.Current.Request.Url + Environment.NewLine,
                Message = exception.Message != null ? exception.Message.ToString(CultureInfo.InvariantCulture) : "",
                Source = exception.Source != null ? exception.Source.ToString(CultureInfo.InvariantCulture) : "",
                StackTrace = exception.StackTrace != null ? exception.StackTrace.ToString(CultureInfo.InvariantCulture) : ""
            });

            context.ExceptionHandled = true;
            context.HttpContext.Response.Clear();
            context.HttpContext.Response.StatusCode = 404;
        }
    }
}