/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 CustomQueryableAttribute
//Purpose:                                      Represents system's Open Data
//====================================================================================================================================================*/

using System.Linq;
using System.Net.Http;
using System.Web.Http.Filters;
using System.Web.Http.OData;

namespace M4PL.API.Filters
{
    public class CustomQueryableAttribute : EnableQueryAttribute
    {
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            object responseObject;
            actionExecutedContext.Response.TryGetContentValue(out responseObject);
            var originalquery = responseObject as IQueryable<object>;
            var originalSize = new[] { "0" };
            if ((originalquery != null) && originalquery.Any())
            {
                originalSize = new[] { originalquery.Count().ToString() };
            }
            if (actionExecutedContext.ActionContext.ActionArguments.ContainsKey("pagedDataInfo"))
            {
                originalSize = new[] { (actionExecutedContext.ActionContext.ActionArguments["pagedDataInfo"] as Entities.Support.PagedDataInfo).TotalCount.ToString() };
            }
            actionExecutedContext.Response.Headers.Add("originalSize", originalSize);
            base.OnActionExecuted(actionExecutedContext);
        }
    }
}