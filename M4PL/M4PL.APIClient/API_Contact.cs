//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              11/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Contact
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
    public class API_Contact
    {
        /// <summary>
        /// Function to get all Contacts data
        /// </summary>
        /// <returns></returns>
        public static Response<Contact> GetAllContacts()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<Response<Contact>>(request);
            if (response.Data == null)
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

        /// <summary>
        /// Function to get Contact details
        /// </summary>
        /// <returns></returns>
        public static Response<Contact> GetContactDetails(int contactID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("ContactID", contactID);
            var response = _client.Execute<Response<Contact>>(request);
            if (response.Data == null)
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;

        }

        /// <summary>
        /// Function to Save Contact
        /// </summary>
        /// <returns></returns>
        public static Response<Contact> SaveContact(Contact obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.POST) { RequestFormat = DataFormat.Json };
            if (obj.ContactID > 0)
                request = new RestRequest("Contact/" + obj.ContactID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<Contact>>(request);
            if (response.Data == null)
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }

        /// <summary>
        /// Function to Remove Contact
        /// </summary>
        /// <returns></returns>
        public static Response<Contact> RemoveContact(int contactID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Contact", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("ContactID", contactID);
            var response = _client.Execute<Response<Contact>>(request);
            if (response.Data == null)
                return new Response<Contact> { Status = false, MessageType = MessageTypes.Exception, Message = response.ErrorMessage };
            return response.Data;
        }
    }
}
