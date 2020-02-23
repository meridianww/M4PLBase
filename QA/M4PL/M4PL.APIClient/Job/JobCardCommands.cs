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

        public IList<JobCardTileDetail> GetCardTileData(long companyId)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetCardTileData"), ActiveUser).AddParameter("companyId", companyId);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<JobCardTileDetail>>(result.Content).Results;
        }
    }
}
