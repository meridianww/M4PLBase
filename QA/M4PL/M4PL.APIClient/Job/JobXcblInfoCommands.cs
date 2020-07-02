#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                 Prashant Aggarwal
// Date Programmed:                            19/02/2020
// Program Name:                                 JobEDIXcblCommands
// Purpose:                                      Client to consume M4PL API called JobEDIXcblController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Linq;

namespace M4PL.APIClient.Job
{
    public class JobXcblInfoCommands : BaseCommands<JobXcblInfoView>, IJobXcblInfoCommands
    {
        /// <summary>
        /// Route to call JobEDIXcbl
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobXcblInfos"; }
        }

        public JobXcblInfoView GetJobXcblInfo(long jobId, long gatewayId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobXcblInfoView>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetJobXcblInfo"), ActiveUser)
               .AddParameter("jobId", jobId).AddParameter("gatewayId", gatewayId)).Content).Results?.FirstOrDefault();
        }

        public bool AcceptJobXcblInfo(long jobId, long gatewayId)
        {
            return JsonConvert.DeserializeObject<ApiResult<bool>>(
           RestClient.Execute(
               HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "AcceptJobXcblInfo"), ActiveUser)
              .AddParameter("jobId", jobId).AddParameter("gatewayId", gatewayId)).Content).Results.FirstOrDefault();

        }

        public bool RejectJobXcblInfo(long gatewayId)
        {
            //var request = HttpRestClient.RestAuthRequest(Method.POST, string.Format("{0}/{1}", RouteSuffix, "RejectJobXcblInfo"), ActiveUser).AddParameter("gatewayId", gatewayId);
            //var result = RestClient.Execute(request);
            //return JsonConvert.DeserializeObject<ApiResult<bool>>(result.Content).Results?.FirstOrDefault();

            return JsonConvert.DeserializeObject<ApiResult<bool>>(
           RestClient.Execute(
               HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "RejectJobXcblInfo"), ActiveUser)
              .AddParameter("gatewayId", gatewayId).AddParameter("gatewayId", gatewayId)).Content).Results.FirstOrDefault();

        }
    }
}