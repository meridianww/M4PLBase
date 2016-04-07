using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using RestSharp;

namespace M4PL.APIClient
{
    public class API_User
    {
        /// <summary>
        /// Function to get all Users data
        /// </summary>
        /// <returns></returns>
        public static List<User> GetAllUsers()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("User", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<List<User>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
