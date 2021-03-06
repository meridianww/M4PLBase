﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Test connecting web with API for Organization
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
    public class API_Organization
    {
        /// <summary>
        /// Function to get all Organizations data
        /// </summary>
        /// <returns></returns>
        public static Response<Organization> GetAllOrganizations()
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization", Method.GET) { RequestFormat = DataFormat.Json };
            var response = _client.Execute<Response<Organization>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get Organizations data
        /// </summary>
        /// <returns></returns>
        public static Response<Organization> GetOrganizationDetails(int organizationID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("OrganizationID", organizationID);
            var response = _client.Execute<Response<Organization>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to Add Organization
        /// </summary>
        /// <returns></returns>
        public static Response<Organization> SaveOrganization(Organization obj)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization", Method.POST) { RequestFormat = DataFormat.Json };
            if (obj.OrganizationID > 0)
                request = new RestRequest("Organization/" + obj.OrganizationID.ToString(), Method.PUT) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddJsonBody(obj);
            var response = _client.Execute<Response<Organization>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to get all Organizations data
        /// </summary>
        /// <returns></returns>
        public static List<int> GetOrgSortOrder(int organizationID = 0)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization/GetOrgSortOrder", Method.GET) { RequestFormat = DataFormat.Json };
            request.AddParameter("OrganizationID", organizationID);
            var response = _client.Execute<List<int>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }

        /// <summary>
        /// Function to Remove Organization
        /// </summary>
        /// <returns></returns>
        public static Response<Organization> RemoveOrganization(int organizationID)
        {
            RestClient _client = new RestClient { BaseUrl = new Uri(M4PL_Constants.M4PL_API) };
            var request = new RestRequest("Organization", Method.DELETE) { RequestFormat = DataFormat.Json };
            request.AddParameter("OrganizationID", organizationID);
            var response = _client.Execute<Response<Organization>>(request);
            if (response.Data == null)
                throw new Exception(response.ErrorMessage);
            return response.Data;
        }
    }
}
