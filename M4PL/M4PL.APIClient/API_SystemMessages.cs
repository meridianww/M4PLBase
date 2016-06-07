//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/6/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Messages
//
//====================================================================================================================================================

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
        public static Response<disMessages> GetSysMessagesTemplates(string screenName = "")
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("screenName", screenName);
            var response = _client.Execute<Response<disMessages>>(request);
            if (response.Data == null)
                return new Response<disMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

        /// <summary>
        /// Function to get all system messages data
        /// </summary>
        /// <returns></returns>
        public static Response<disMessages> GetAllSystemMessages()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<Response<disMessages>>(request);
            if (response.Data == null)
                return new Response<disMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to get User Account details by SysMessageID
        /// </summary>
        /// <returns></returns>
        public static Response<SystemMessages> GetSystemMessageDetails(int sysMessageID, string screenName = "")
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("SystemMessagesID", sysMessageID);
            request.AddParameter("ScreenName", screenName);
            var response = _client.Execute<Response<SystemMessages>>(request);
            if (response.Data == null)
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Add/Edit User data
        /// </summary>
        /// <returns></returns>
        public static Response<SystemMessages> SaveSystemMessages(SystemMessages obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.POST) { RequestFormat = DataFormat.Json };
            if (obj.SysMessageID > 0)
                request = new RestRequest("SystemMessages/" + obj.SysMessageID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<SystemMessages>>(request);
            if (response.Data == null)
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Remove User data
        /// </summary>
        /// <returns></returns>
        public static Response<SystemMessages> RemoveSystemMessage(int sysMessageID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("SystemMessages", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("SystemMessagesID", sysMessageID);
            var response = _client.Execute<Response<SystemMessages>>(request);
            if (response.Data == null)
                return new Response<SystemMessages> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

    }
}
