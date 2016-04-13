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
    public class API_Contact
    {
        /// <summary>
        /// Function to get all Contacts data
        /// </summary>
        /// <returns></returns>
        public static List<Contact> GetAllContacts()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<List<Contact>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;

        }

        /// <summary>
        /// Function to Save Contact
        /// </summary>
        /// <returns></returns>
        public static int SaveContact(Contact obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
