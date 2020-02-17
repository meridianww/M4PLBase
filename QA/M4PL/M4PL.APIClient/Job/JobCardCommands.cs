using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using Newtonsoft.Json;
using RestSharp;

namespace M4PL.APIClient.Job
{

    public class JobCardCommands : BaseCommands<JobCardView>, IJobCardCommands
    {
        /// <summary>
        /// Route to call JobAdvanceReport
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobCard"; }
        }

        public JobDestination GetJobDestination(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobDestination>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "Destination"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }
        public JobCardView GetJobByProgram(long id, long parentId)
        {
            return JsonConvert.DeserializeObject<ApiResult<JobCardView>>(
            RestClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobByProgram"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId)).Content).Results.FirstOrDefault();
        }
        public IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {

            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "JobsSiteCodeByProgram"), ActiveUser).AddParameter("id", id).AddParameter("parentId", parentId).AddParameter("isNullFIlter", isNullFIlter);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<JobsSiteCode>>(result.Content).Results;

        }

        public IList<JobCardTileDetail> GetCardTileData(long companyId)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetCardTileData"), ActiveUser).AddParameter("companyId", companyId);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<JobCardTileDetail>>(result.Content).Results;
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
    }
}
