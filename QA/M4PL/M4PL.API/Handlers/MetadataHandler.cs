/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MetadataHandler
//Purpose:                                      For Handling Async API calls and process API result
//====================================================================================================================================================*/

using M4PL.API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;

namespace M4PL.API.Handlers
{
    public class MetadataHandler : DelegatingHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            return base.SendAsync(request, cancellationToken).ContinueWith(
                task =>
                {
                    if (ResponseIsValid(task.Result))
                    {
                        object responseObject;
                        task.Result.TryGetContentValue(out responseObject);

                        if (responseObject is IQueryable)
                        {
                            ProcessObject(responseObject as IQueryable<object>, task.Result, true, request.Method);
                        }
                        else
                        {
                            var list = new List<object>();
                            list.Add(responseObject);
                            ProcessObject(responseObject as IEnumerable<object>, task.Result, false, request.Method);
                        }
                    }

                    return task.Result;
                }
            );
        }

        private void ProcessObject<T>(IEnumerable<T> responseObject, HttpResponseMessage response, bool isIQueryable,
            HttpMethod method) where T : class
        {
            var metadata = new Metadata<T>(response, isIQueryable);
            var originalSize = new string[1] as IEnumerable<string>;
            response.Headers.TryGetValues("originalSize", out originalSize);
            response.Headers.Remove("originalSize");
            if (originalSize != null)
                metadata.TotalResults = Convert.ToInt32(originalSize.FirstOrDefault());
            response.Content = new ObjectContent<Metadata<T>>(metadata, GlobalConfiguration.Configuration.Formatters[0]);
        }

        private bool ResponseIsValid(HttpResponseMessage response)
        {
            if ((response == null) || (response.StatusCode != HttpStatusCode.OK) || !(response.Content is ObjectContent))
                return false;
            return true;
        }
    }
}