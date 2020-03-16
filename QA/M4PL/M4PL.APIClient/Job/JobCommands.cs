/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Client to consume M4PL API called JobController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Job
{
    public class JobCommands : BaseCommands<JobView>, IJobCommands
    {
        /// <summary>
        /// Route to call Jobs
        /// </summary>
        public override string RouteSuffix
        {
            get { return "Jobs"; }
        }

        public JobDestination GetJobDestination(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobDestination>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "Destination"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }

        public Job2ndPoc GetJob2ndPoc(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<Job2ndPoc>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "Poc"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }

        public JobSeller GetJobSeller(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobSeller>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "Seller"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }

        public JobMapRoute GetJobMapRoute(long id)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobMapRoute>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "MapRoute"), ActiveUser).AddParameter("id", id)).Content).Results.FirstOrDefault();
        }

        public JobPod GetJobPod(long id)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobPod>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "Pod"), ActiveUser).AddParameter("id", id)).Content).Results.FirstOrDefault();
        }

        public JobDestination PutJobDestination(JobDestination jobDestination)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobDestination>>(RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "JobDestination"), ActiveUser).AddObject(jobDestination)).Content).Results.FirstOrDefault();
        }

        public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
        {
            return JsonConvert.DeserializeObject<ApiResult<Job2ndPoc>>(RestClient.Execute(
              HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "Job2ndPoc"), ActiveUser).AddObject(job2ndPoc)).Content).Results.FirstOrDefault();
        }

        public JobSeller PutJobSeller(JobSeller jobSeller)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobSeller>>(RestClient.Execute(
             HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "JobSeller"), ActiveUser).AddObject(jobSeller)).Content).Results.FirstOrDefault();
        }

        public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobMapRoute>>(RestClient.Execute(
             HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "JobMapRoute"), ActiveUser).AddObject(jobMapRoute)).Content).Results.FirstOrDefault();
        }

        public JobView GetJobByProgram(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobView>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobByProgram"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }
        public IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId,bool isNullFIlter = false)
        {

            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobsSiteCodeByProgram"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId).AddParameter("isNullFIlter", isNullFIlter);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<JobsSiteCode>>(result.Content).Results;

        }

        public bool GetIsJobDataViewPermission(long recordId)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetIsJobDataViewPermission"), ActiveUser).AddParameter("recordId", recordId);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<bool>>(result.Content).Results.FirstOrDefault();
        }
    }
}