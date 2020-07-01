//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/25/2019
//Program Name:                                 NavCustomerCommands
//Purpose:                                      Client to consume M4PL API called NavCustomerCommands
//===================================================================================================================
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.APIClient.Finance
{
    /// <summary>
    /// Route to call Nav Vendor
    /// </summary>
    public class NavCustomerCommands : BaseCommands<NavCustomerView>,
        INavCustomerCommands
    {
        public override string RouteSuffix
        {
            get { return "NavCustomer"; }
        }

        public IList<NavCustomerView> GetAllNavCustomer()
        {
            var request = HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "GetAllNavCustomer"), ActiveUser);
            var result = RestClient.Execute(request);
            return JsonConvert.DeserializeObject<ApiResult<List<NavCustomerView>>>(result.Content).Results?.FirstOrDefault();
        }
    }
}
