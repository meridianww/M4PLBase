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
    public class API_ChooseColumns
    {
        /// <summary>
        /// Function to get all Columns data for opened page
        /// </summary>
        /// <returns></returns>
        public static Response<ColumnsChild> GetAllColumns(string pageName)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("ChooseColumns", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("PageName", pageName);
            var response = _client.Execute<Response<ColumnsChild>>(request);
            if (response.Data == null)
                return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

        public static Response<ColumnsChild> SaveChoosedColumns(ColumnsChild obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("ChooseColumns", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<ColumnsChild>>(request);
            if (response.Data == null)
                return new Response<ColumnsChild> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }
        
    }
}
