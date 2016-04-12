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
    public class API_MenuDriver
    {
        /// <summary>
        /// Function to get all Roles
        /// </summary>
        /// <returns></returns>
        public static List<Roles> GetAllRoles()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<List<Roles>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to Add Role's data
        /// </summary>
        /// <returns></returns>
        public static int AddRole(Roles obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to Add Security By Role
        /// </summary>
        /// <returns></returns>
        public static int AddSecurityByRole(SecurityByRole obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver/PostSecurityByRole", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get all Menus
        /// </summary>
        /// <returns></returns>
        public static List<Menus> GetAllMenus(int Module = 0)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver/GetAllMenus", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("Module", Module);
            var response = _client.Execute<List<Menus>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get all Security Roles
        /// </summary>
        /// <returns></returns>
        public static List<SecurityByRole> GetAllSecurityRoles()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver/GetAllSecurityRoles", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<List<SecurityByRole>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

    }
}
