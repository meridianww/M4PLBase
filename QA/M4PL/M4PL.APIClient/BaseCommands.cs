/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 BaseCommands
//Purpose:                                      Represents BaseCommands Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient
{
    public abstract class BaseCommands<TView>
    {
        protected readonly string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
        protected RestClient restClient;

        protected BaseCommands()
        {
            restClient = new RestClient(new Uri(_baseUri));
        }

        public ActiveUser ActiveUser { get; set; }

        public RestClient RestClient
        {
            get
            {
                restClient = new RestClient(new Uri(_baseUri));
                return restClient;
            }
        }

        public abstract string RouteSuffix { get; }

        public virtual IList<TView> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            var content = restClient.Execute(HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "PagedData"), ActiveUser).AddObject(pagedDataInfo)).Content;
            var apiResult = JsonConvert.DeserializeObject<ApiResult<TView>>(content);
            pagedDataInfo.TotalCount = ((apiResult != null) && apiResult.TotalResults > 0) ? apiResult.TotalResults : apiResult.ReturnedResults;
            return apiResult.Results;
        }

        public virtual TView Get(long id)
        {
            var result = JsonConvert.DeserializeObject<ApiResult<TView>>(
                restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix, ActiveUser).AddParameter("id", id)).Content).Results.FirstOrDefault();
            return result;
        }

        public virtual IList<TView> Get()
        {
            var result = JsonConvert.DeserializeObject<ApiResult<TView>>(
                restClient.Execute(
                    HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix, ActiveUser)).Content).Results;
            return result;
        }

        public virtual TView Post(TView entity)
        {
            var result = JsonConvert.DeserializeObject<ApiResult<TView>>(restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.POST, RouteSuffix, ActiveUser).AddObject(entity)).Content).Results.FirstOrDefault();
            return result;
        }

        public virtual TView Put(TView entity)
        {
            var result = JsonConvert.DeserializeObject<ApiResult<TView>>(
                  restClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.PUT, RouteSuffix, ActiveUser).AddObject(entity)).Content).Results.FirstOrDefault();
            return result;
        }

        public virtual TView Delete(long id)
        {
            var result = JsonConvert.DeserializeObject<ApiResult<TView>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.DELETE, RouteSuffix, ActiveUser).AddParameter("id", id)).Content).Results.FirstOrDefault();
            return result;
        }

        public virtual IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            var content = restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.DELETE, string.Format("{0}/{1}", RouteSuffix, "DeleteList"), ActiveUser).AddParameter("ids", string.Join(",", ids)).AddParameter("statusId", statusId)).Content;
            content = content.Replace("[[", "[").Replace("]]", "]");
            var result = JsonConvert.DeserializeObject<ApiResult<IdRefLangName>>(content).Results;
            return result;
        }
    }
}