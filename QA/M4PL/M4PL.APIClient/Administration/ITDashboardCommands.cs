using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Administration
{
    public class ITDashboardCommands : BaseCommands<ITDashboardView>, IITDashboardCommands
    {
        public override string RouteSuffix
        {
            get { return "ITDashboards"; }
        }

        public IList<ITDashboardView> GetCardTileData(string dashboardName)
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetCardTileData"), ActiveUser).AddParameter("dashboardName", dashboardName);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<ITDashboardView>>(result.Content).Results;
        }

        #region Default base methods

        public ITDashboardView Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public ITDashboardView Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<ITDashboardView> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public ITDashboardView Patch(ITDashboardView entity)
        {
            throw new NotImplementedException();
        }

        public ITDashboardView Post(ITDashboardView entity)
        {
            throw new NotImplementedException();
        }

        public ITDashboardView Put(ITDashboardView entity)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
