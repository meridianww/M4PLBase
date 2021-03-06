﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobGatewayCommands
// Purpose:                                      Client to consume M4PL API called JobGatewayController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Job
{
    public class JobGatewayCommands : BaseCommands<JobGatewayView>, IJobGatewayCommands
    {
        /// <summary>
        /// Route to call JobGateways
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobGateways"; }
        }

        public JobGatewayView GetGatewayWithParent(long id, long parentId, string entityFor = null, bool is3PlAction = false, string gatewayCode = null)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobGatewayView>>(
             RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GatewayWithParent"), ActiveUser)
                 .AddParameter("id", id)
                 .AddParameter("parentId", parentId)
                 .AddParameter("entityFor", entityFor)
                 .AddParameter("is3PlAction", is3PlAction)
                 .AddParameter("gatewayCode", gatewayCode)).Content).Results?.FirstOrDefault();
        }

        public JobGatewayComplete GetJobGatewayComplete(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobGatewayComplete>>(
             RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GatewayComplete"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results?.FirstOrDefault();
        }

        public JobGatewayComplete PutJobGatewayComplete(JobGatewayComplete jobGateway)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobGatewayComplete>>(
                RestClient.Execute(HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "GatewayComplete"), ActiveUser).AddObject(jobGateway)).Content).Results?.FirstOrDefault();
        }

        //public IList<JobAction> GetJobAction(long jobId)
        //{
        //    var content = RestClient.Execute(HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobAction"), ActiveUser).AddParameter("jobId", jobId)).Content;
        //    var apiResult = JsonConvert.DeserializeObject<ApiResult<JobAction>>(content);
        //    return apiResult.Results;
        //}
        public JobGatewayView PutJobAction(JobGatewayView jobGatewayView)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobGatewayView>>(
                RestClient.Execute(HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "JobAction"), ActiveUser).AddObject(jobGatewayView)).Content).Results?.FirstOrDefault();
        }

        public JobGatewayView PutWithSettings(JobGatewayView jobGatewayView)
        {
            var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPut");
            var result = JsonConvert.DeserializeObject<ApiResult<JobGatewayView>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.PUT, newRouteSuffix, ActiveUser).AddObject(jobGatewayView)).Content).Results?.FirstOrDefault();
            return result;
        }

        public JobGatewayView PostWithSettings(JobGatewayView jobGatewayView)
        {
            var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPost");
            var result = JsonConvert.DeserializeObject<ApiResult<JobGatewayView>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.POST, newRouteSuffix, ActiveUser).AddObject(jobGatewayView)).Content).Results?.FirstOrDefault();
            return result;
        }

        public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobActionCode>>(
             RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobActionCodeByTitle"), ActiveUser)
                 .AddParameter("jobId", jobId).AddParameter("gwyTitle", gwyTitle)).Content).Results?.FirstOrDefault();
        }
        public List<JobActionGateway> GetActionsByJobIds(string jobIds)
        {
            return JsonConvert.DeserializeObject<ApiResult<List<JobActionGateway>>>(
                         RestClient.Execute(
                             HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetActionsByJobIds"), ActiveUser)
                             .AddParameter("jobIds", jobIds)).Content).Results?.FirstOrDefault();
        }
    }
}