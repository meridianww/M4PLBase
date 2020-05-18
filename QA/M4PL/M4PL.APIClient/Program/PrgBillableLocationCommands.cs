/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgBillableLocation
Purpose:                                       Client to consume M4PL API called PrgBillableLocationController
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using RestSharp;
using Newtonsoft.Json;
using M4PL.Entities.Support;
using System.Linq;

namespace M4PL.APIClient.Program
{
    public class PrgBillableLocationCommands : BaseCommands<PrgBillableLocationView>, IPrgBillableLocationCommands
    {
        public override string RouteSuffix
        {
            get { return "PrgBillableLocation"; }
        }

        public IList<TreeModel> BillableLocationTree(bool isAssignedBillableLocation, long programId, long? parentId, bool isChild)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(
            _restClient.Execute(
                HttpRestClient.RestAuthRequest(Method.GET, RouteSuffix + "/BillableLocation", ActiveUser).AddParameter("parentId", parentId)
                .AddParameter("isChild", isChild).AddParameter("isAssignedBillableLocation", isAssignedBillableLocation).AddParameter("programId", programId)).Content).Results;
        }

        public bool MapVendorPriceLocations(bool assign, long parentId, List<PrgCostLocationView> ids)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            var route = string.Format("{0}/{1}?assign={2}&parentId={3}", RouteSuffix, "MapVendorPriceLocations", assign, parentId);

            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(ids)).Content).Results?.FirstOrDefault();

            return result.HasValue ? (bool)result : false;
        }

        public bool MapVendorBillableLocations(ProgramVendorMap programVendorMap)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            var route = string.Format("{0}/{1}", RouteSuffix, "MapVendorBillableLocations");

            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(programVendorMap)).Content).Results?.FirstOrDefault();

            return result.HasValue ? (bool)result : false;
        }
    }
}
