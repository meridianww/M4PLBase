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
    public class API_SystemMessages
    {
        /// <summary>
        /// Function to get all Contacts data
        /// </summary>
        /// <returns></returns>
        public static Response<disMessages> GetSysMessagesTemplates()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<Response<disMessages>>(request);
            if (response.Data == null)
                return new Response<disMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

      
    }
}
