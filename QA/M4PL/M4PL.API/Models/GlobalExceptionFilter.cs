#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              13/10/2017
//Program Name:                                 GlobalException
//Purpose:                                      Represents Exceptions of the system
//====================================================================================================================================================*/

using System;
using System.Globalization;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;

namespace M4PL.API.Models
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

            var message = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Message.ToString(CultureInfo.InvariantCulture) : string.Empty;
            var source = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Source.ToString(CultureInfo.InvariantCulture) : string.Empty;
            var StackTrace = ctx.Server.GetLastError() != null ? ctx.Server.GetLastError().Message.ToString(CultureInfo.InvariantCulture) : string.Empty;

            var errorLog = new ErrorLog
            {
                UserName = ctx.User.Identity.Name,
                ApplicationUrl = ctx.Request.Url + Environment.NewLine,
                Message = context.Exception.Message.ToString(CultureInfo.InvariantCulture),
                Source = (context.Exception).Source.ToString(CultureInfo.InvariantCulture),
                StackTrace = (context.Exception).StackTrace.ToString(CultureInfo.InvariantCulture)
            };

            // TODO:: Do a database log

            context.Response = context.Request.CreateResponse(
                HttpStatusCode.InternalServerError
                , new { Message = string.Format("Opps! something went wrong, please try again, {0}.", errorLog.Message) }
                , context.ActionContext.ControllerContext.Configuration.Formatters.JsonFormatter);
        }
    }
}