using M4PL.Entities;
using M4PL_API_CommonUtils;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;

namespace M4PL.API.App_Start
{
    /// <summary>
    /// This class is to handle and log exception to database
    /// </summary>
    public class GlobalExceptionFilterAttribute : ExceptionFilterAttribute
    {
        /// <summary>
        /// This method is used to log exception to database and return a generic error message 
        /// </summary>
        /// <param name="context"></param>
        public override void OnException(HttpActionExecutedContext context)
        {
            HttpContext ctx = HttpContext.Current;
            var message = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Message.ToString(CultureInfo.InvariantCulture) : "";
            var source = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Source.ToString(CultureInfo.InvariantCulture) : "";
            var StackTrace = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Message.ToString(CultureInfo.InvariantCulture) : "";
            
            var errorLog = new LogError
            {
                UserName = ctx.User.Identity.Name,
                ApplicationUrl = ctx.Request.Url + Environment.NewLine,
                Message = context.Exception.Message.ToString(CultureInfo.InvariantCulture),
                Source = (context.Exception).Source.ToString(CultureInfo.InvariantCulture),
                StackTrace = (context.Exception).StackTrace.ToString(CultureInfo.InvariantCulture)
            };

            BAL_ErrorLog.LogException(errorLog);
            context.Response = context.Request.CreateResponse(HttpStatusCode.OK, new Response<string> { Status = false, Message = "An error has occured" }, context.ActionContext.ControllerContext.Configuration.Formatters.JsonFormatter);
        }
    }
    public class ResponseException : HttpResponseMessage
    {

        public bool Status { get; set; }

        public string Message { get; set; }
    }
}