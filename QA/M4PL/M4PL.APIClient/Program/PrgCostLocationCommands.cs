/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgCostLocationCommands
Purpose:                                      Client to consume M4PL API called PrgCostLocationController
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Program
{
    public class PrgCostLocationCommands : BaseCommands<PrgCostLocationView>, IPrgCostLocationCommands
    {
        public override string RouteSuffix
        {
            get { return "PrgCostLocations"; }
        }
        public  IList<TreeModel> CostLocationTree(bool isAssignedCostLocation, long programId, long? parentId, bool isChild)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            var route = string.Format("{0}/{1}", RouteSuffix, "CostLocation");
            try
            {
                var request = HttpRestClient.RestAuthRequest(Method.GET, route, ActiveUser)
                    .AddParameter("parentId", parentId).
                    AddParameter("isChild", isChild).
                    AddParameter("isAssignedCostLocation", isAssignedCostLocation).
                    AddParameter("programId", programId);
                var result = _restClient.Execute(request);
                return JsonConvert.DeserializeObject<ApiResult<TreeModel>>(result.Content).Results;
            }
            catch (Exception ex)
            {

                throw;
            }

        }

		public bool MapVendorCostLocations(bool assign, long parentId, List<PrgCostLocationView> ids)
		{
			string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
			RestClient _restClient = new RestClient(new Uri(_baseUri));

			var route = string.Format("{0}/{1}?assign={2}&parentId={3}", RouteSuffix, "MapVendorCostLocations", assign, parentId);

			var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
			   HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(ids)).Content).Results.FirstOrDefault();

			return result;
		}

		public bool MapVendorCostLocations(ProgramVendorMap programVendorMap)
		{
			string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
			RestClient _restClient = new RestClient(new Uri(_baseUri));
			var route = string.Format("{0}/{1}", RouteSuffix, "MapVendorCostLocations");

			var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
			   HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(programVendorMap)).Content).Results.FirstOrDefault();

			return result;
		}
	}
}
