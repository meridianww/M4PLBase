using M4PL.Entities;
using M4PL_API_CommonUtils;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient
{
    public class API_Login
    {
        /// <summary>
        /// Function to get all Users data
        /// </summary>
        /// <returns></returns>
        public static bool GetLogin(string Email, string Password)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Login", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("emailId", Email);
            request.AddParameter("password", Password);
            var response = _client.Execute<bool>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
