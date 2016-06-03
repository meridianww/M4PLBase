//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/5/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for User
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

namespace M4PL.APIClient
{
    public class API_User
    {
        /// <summary>
        /// Function to get all Users data
        /// </summary>
        /// <returns></returns>
        public static Response<disUser> GetAllUsers()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("User", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<Response<disUser>>(request);
            if (response.Data == null)
                return new Response<disUser> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to get User Account details by UserID
        /// </summary>
        /// <returns></returns>
        public static Response<User> GetUserAccount(int userID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("User", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("UserID", userID);
            var response = _client.Execute<Response<User>>(request);
            if (response.Data == null)
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Add/Edit User data
        /// </summary>
        /// <returns></returns>
        public static Response<User> SaveUser(User obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("User", Method.POST) { RequestFormat = DataFormat.Json };
            if (obj.SysUserID > 0)
                request = new RestRequest("User/" + obj.SysUserID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<User>>(request);
            if (response.Data == null)
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Remove User data
        /// </summary>
        /// <returns></returns>
        public static Response<User> RemoveUserAccount(int userID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("User", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("UserID", userID);
            var response = _client.Execute<Response<User>>(request);
            if (response.Data == null)
                return new Response<User> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

    }
}
