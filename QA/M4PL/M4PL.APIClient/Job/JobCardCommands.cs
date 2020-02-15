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
    }
}
