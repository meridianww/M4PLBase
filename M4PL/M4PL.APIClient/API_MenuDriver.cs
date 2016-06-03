//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              15/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Menu Driver
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
    public class API_MenuDriver
    {
        ///// <summary>
        ///// Function to get all Roles
        ///// </summary>
        ///// <returns></returns>
        //public static List<Roles> GetAllRoles()
        //{
        //    RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
        //    var request = new RestRequest("MenuDriver", Method.GET) { RequestFormat = DataFormat.Json };
        //    var response = _client.Execute<List<Roles>>(request);
        //    if (response.Data == null)
        //        throw new Exception(response.ErrorMessage);
        //    return response.Data;
        //}

        ///// <summary>
        ///// Function to Add Role's data
        ///// </summary>
        ///// <returns></returns>
        //public static int AddRole(Roles obj)
        //{
        //    RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
        //    var request = new RestRequest("MenuDriver", Method.POST) { RequestFormat = DataFormat.Json };
        //    request.AddHeader("Content-Type", "application/json; charset=utf-8");
        //    request.AddJsonBody(obj);
        //    var response = _client.Execute<int>(request);
        //    if (response.Data == null)
        //        throw new Exception(response.ErrorMessage);
        //    return response.Data;
        //}

        ///// <summary>
        ///// Function to Add Security By Role
        ///// </summary>
        ///// <returns></returns>
        //public static int AddSecurityByRole(SecurityByRole obj)
        //{
        //    RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
        //    var request = new RestRequest("MenuDriver/PostSecurityByRole", Method.POST) { RequestFormat = DataFormat.Json };
        //    request.AddHeader("Content-Type", "application/json; charset=utf-8");
        //    request.AddJsonBody(obj);
        //    var response = _client.Execute<int>(request);
        //    if (response.Data == null)
        //        throw new Exception(response.ErrorMessage);
        //    return response.Data;
        //}

        ///// <summary>
        ///// Function to get all Security Roles
        ///// </summary>
        ///// <returns></returns>
        //public static List<disSecurityByRole> GetAllSecurityRoles()
        //{
        //    RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
        //    var request = new RestRequest("MenuDriver/GetAllSecurityRoles", Method.GET) { RequestFormat = DataFormat.Json };
        //    var response = _client.Execute<List<disSecurityByRole>>(request);
        //    if (response.Data == null)
        //        throw new Exception(response.ErrorMessage);
        //    return response.Data;
        //}


        /// <summary>
        /// Function to get all Menus
        /// </summary>
        /// <returns></returns>
        public static Response<disMenus> GetAllMenus(int Module = 0)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver/GetAllMenus", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("Module", Module);
            var response = _client.Execute<Response<disMenus>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get User Account details by UserID
        /// </summary>
        /// <returns></returns>
        public static Response<Menus> GetMenuDetails(int menuID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("MenuID", menuID);
            var response = _client.Execute<Response<Menus>>(request);
            if (response.Data == null)
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to save Menu details
        /// </summary>
        /// <returns></returns>
        public static Response<Menus> SaveMenu(Menus obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver", Method.POST) { RequestFormat = DataFormat.Json };
            if (obj.MenuID > 0)
                request = new RestRequest("MenuDriver/" + obj.MenuID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<Menus>>(request);
            if (response.Data == null)
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Remove Menu
        /// </summary>
        /// <returns></returns>
        public static Response<Menus> RemoveMenu(int menuID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("MenuDriver", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("MenuID", menuID);
            var response = _client.Execute<Response<Menus>>(request);
            if (response.Data == null)
                return new Response<Menus> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

    }
}
