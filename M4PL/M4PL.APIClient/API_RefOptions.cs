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
    public class API_RefOptions
    {
        /// <summary>
        /// Function to get all Options
        /// </summary>
        /// <returns></returns>
        public static List<disRefOptions> GetRefOptions(string TableName, string ColumnName)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("TableName", TableName);
            request.AddParameter("ColumnName", ColumnName);
            var response = _client.Execute<List<disRefOptions>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
