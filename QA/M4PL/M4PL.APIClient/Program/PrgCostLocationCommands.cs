#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Nikhil
// Date Programmed:                              24/07/2019
// Program Name:                                 PrgCostLocationCommands
// Purpose:                                      Client to consume M4PL API called PrgCostLocationController
//=============================================================================================================
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Program
{
    public class PrgCostLocationCommands : BaseCommands<PrgCostLocationView>, IPrgCostLocationCommands
    {
        public override string RouteSuffix
        {
            get { return "PrgCostLocations"; }
        }
        public IList<TreeModel> CostLocationTree(bool isAssignedCostLocation, long programId, long? parentId, bool isChild)
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
                throw new Exception(ex.Message);
            }

        }

        public bool MapVendorCostLocations(bool assign, long parentId, List<PrgCostLocationView> ids)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));

            var route = string.Format("{0}/{1}?assign={2}&parentId={3}", RouteSuffix, "MapVendorCostLocations", assign, parentId);

            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(_restClient.Execute(
               HttpRestClient.RestAuthRequest(Method.POST, route, ActiveUser).AddJsonBody(ids)).Content).Results?.FirstOrDefault();

            return result.HasValue ? (bool)result : false;
        }

        public async Task<bool> MapVendorCostLocations(ProgramVendorMap programVendorMap)
        {
            string _baseUri = ConfigurationManager.AppSettings["WebAPIURL"];
            RestClient _restClient = new RestClient(new Uri(_baseUri));
            var route = string.Format("{0}/{1}/{2}", _baseUri, RouteSuffix, "MapVendorCostLocations");
            var result = await PostAsync<ApiResult<bool>>(route, programVendorMap, Encoding.UTF8, ActiveUser);

            return result.Results.FirstOrDefault();
        }

        protected async Task<T> PostAsync<T>(string url, object request, Encoding encoding, ActiveUser activeUser, NameValueCollection headers = null, string mediaType = "application/json")
        {
            if (string.IsNullOrEmpty(url))
                throw new ArgumentNullException(nameof(url));

            if (request == null)
                throw new ArgumentNullException(nameof(request));

            var json = JsonConvert.SerializeObject(request);
            var jsonRequest = new StringContent(json, encoding, mediaType);
            string responseContent = null;

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(mediaType));
                httpClient.DefaultRequestHeaders.Add("Authorization", "bearer " + activeUser.AuthToken);

                if (headers != null)
                {
                    foreach (var key in headers.AllKeys) httpClient.DefaultRequestHeaders.Add(key, headers[key]);
                }

                var httpResponse = await httpClient.PostAsync(url, jsonRequest);

                if (httpResponse.IsSuccessStatusCode)
                {
                    responseContent = await httpResponse.Content.ReadAsStringAsync().ConfigureAwait(false);
                }
            }
            return string.IsNullOrEmpty(responseContent) ? default(T) : JsonConvert.DeserializeObject<T>(responseContent);
        }
    }
}
