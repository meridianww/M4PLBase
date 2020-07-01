/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 JobDocReferenceCommands
Purpose:                                      Client to consume M4PL API called JobDocReferenceController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Linq;

namespace M4PL.APIClient.Job
{
    public class JobDocReferenceCommands : BaseCommands<JobDocReferenceView>, IJobDocReferenceCommands
    {
        /// <summary>
        /// Route to call JobDocRefStatus
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobDocReferences"; }
        }

        public JobDocReferenceView PutWithSettings(JobDocReferenceView jobDocReferenceView)
        {
            var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPut");
            var result = JsonConvert.DeserializeObject<ApiResult<JobDocReferenceView>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.PUT, newRouteSuffix, ActiveUser).AddObject(jobDocReferenceView)).Content).Results?.FirstOrDefault();
            return result;
        }

        public JobDocReferenceView PostWithSettings(JobDocReferenceView jobDocReferenceView)
        {
            var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "SettingPost");
            var result = JsonConvert.DeserializeObject<ApiResult<JobDocReferenceView>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.POST, newRouteSuffix, ActiveUser).AddObject(jobDocReferenceView)).Content).Results?.FirstOrDefault();
            return result;
        }


        public long GetNextSequence()
        {
            var newRouteSuffix = string.Format("{0}/{1}", RouteSuffix, "GetNextSequence");
            var result = JsonConvert.DeserializeObject<ApiResult<long>>(
                 restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, newRouteSuffix, ActiveUser)).Content).Results?.FirstOrDefault();
            return result.HasValue ? (long)result : 0;
        }
    }
}