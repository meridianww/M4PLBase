using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using RestSharp;
using Newtonsoft.Json;

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
        /// Function to get Contact details
        /// </summary>
        /// <returns></returns>
        public static Contact GetContactDetails(int contactID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("ContactID", contactID);
            var response = _client.Execute<Contact>(request);
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
            if (obj.ContactID > 0)
                request = new RestRequest("Contact/" + obj.ContactID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to Remove Contact
        /// </summary>
        /// <returns></returns>
        public static int RemoveContact(int contactID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("ContactID", contactID);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
