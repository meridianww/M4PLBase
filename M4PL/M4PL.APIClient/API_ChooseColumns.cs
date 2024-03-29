﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              30/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Choose Columns
//
//====================================================================================================================================================

using M4PL.Entities;
using M4PL.Entities.DisplayModels;
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
        /// <param name="pageName"></param>
        /// <returns></returns>
        public static Response<disChooseColumns> GetAllColumns(string pageName, bool IsRestoreDefaults = false)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("ChooseColumns", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("PageName", pageName);
            request.AddParameter("IsRestoreDefault", IsRestoreDefaults);
            var response = _client.Execute<Response<disChooseColumns>>(request);
            if (response.Data == null)
                return new Response<disChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

        /// <summary>
        /// Function to save all selected columns to display to grid.
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static Response<ChooseColumns> SaveChoosedColumns(ChooseColumns obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("ChooseColumns", Method.POST) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<ChooseColumns>>(request);
            if (response.Data == null)
                return new Response<ChooseColumns> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

    }
}
