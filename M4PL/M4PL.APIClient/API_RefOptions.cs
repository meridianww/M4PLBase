//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              8/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Ref Options
//
//====================================================================================================================================================

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

        /// <summary>
        /// Function to save the Grid Layout
        /// </summary>
        /// <param name="pagename"></param>
        /// <param name="strLayout"></param>
        /// <returns></returns>        
        public static int SaveGridLayout(GridLayout obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<int>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get last saved Layout of the Grid
        /// </summary>
        /// <param name="pagename"></param>
        /// <param name="userid"></param>
        /// <returns></returns>  
        public static StringBuilder GetSavedGridLayout(string pagename, int userid)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("userid", userid);
            request.AddParameter("pagename", pagename);
            var response = _client.Execute<StringBuilder>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        public static Response<SaveColumnsAlias> SaveAliasColumn(SaveColumnsAlias obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions/SaveAliasColumn", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<SaveColumnsAlias>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        public static Response<ColumnsAlias> GetAllColumnAliases(string pagename)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddParameter("pagename", pagename);
            var response = _client.Execute<Response<ColumnsAlias>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        public static long? GetNextPrevValue(string pageName, long id, short options = 0)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("RefOptions", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("id", id);
            request.AddParameter("options", options);
            request.AddParameter("pageName", pageName);
            var response = _client.Execute<long>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
