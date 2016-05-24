using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Mvc;
using System.Net.Http;
using System.Web.Http.Filters;
using M4PL_API_CommonUtils;

namespace M4PL.API.App_Start
{
    public class ValidateModelAttribute : System.Web.Http.Filters.ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (actionContext.ModelState.IsValid == false)
            {
                var errorList = actionContext.ModelState.Values.SelectMany(m => m.Errors.Select(e => e.ErrorMessage)).ToList();
                string errorMsg = "";
                foreach (var item in errorList)
                {
                    errorMsg += item + ". \n";
                }

                var output = new Response<string> { Status = false, Data = null, Message = errorMsg, DataList = null };
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.OK, output, actionContext.ControllerContext.Configuration.Formatters.JsonFormatter);

            }
        }
    }
}