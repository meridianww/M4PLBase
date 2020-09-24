using M4PL.APIClient.ViewModels.NavRemittance;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;

namespace M4PL.APIClient.Finance
{
    public class NavRemittanceCommands : BaseCommands<NavRemittanceView>,
        INavRemittanceCommands
    {
        public override string RouteSuffix
        {
            get { return "NavRemittance"; }
        }
        public IList<NavRemittanceView> GetAllNavRemittance()
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetAllNavRemittance"), ActiveUser);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<List<NavRemittanceView>>>(result.Content).Results?.FirstOrDefault();
        }
    }
}
