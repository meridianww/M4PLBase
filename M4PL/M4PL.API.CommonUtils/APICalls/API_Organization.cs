using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RestSharp;
using M4PL.Entities;

namespace M4PL_API_CommonUtils.APICalls
{
    public class API_Organization
    {
        /// <summary>
        /// Function to get all Organizations data
        /// </summary>
        /// <returns></returns>
        public static List<Organization> GetAllOrganizations()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<List<Organization>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
