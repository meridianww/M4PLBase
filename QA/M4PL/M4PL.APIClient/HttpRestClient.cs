/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              13/10/2017
//Program Name:                                 HttpRestClient
//Purpose:                                      Represents HttpRestClient Details
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using RestSharp;
using System;

namespace M4PL.APIClient
{
    public class HttpRestClient
    {
        public static RestRequest RestAuthRequest(Method methodType, string routeSuffix, ActiveUser activeUser)
        {
            var request = new RestRequest(routeSuffix, methodType) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddHeader("Authorization", "bearer " + activeUser.AuthToken);
            request.OnBeforeDeserialization = resp =>
            {
                resp.ContentType = "application/json";
                resp.Content = resp.Content.Replace("[]", "{}");
            };

            return request;
        }

        internal static IRestRequest RestAuthRequest(Method gET, string v)
        {
            throw new NotImplementedException();
        }

        public static RestRequest RestRequest(Method methodType, string routeSuffix)
        {
            var request = new RestRequest(routeSuffix, methodType) { RequestFormat = DataFormat.Json };
            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.OnBeforeDeserialization = resp => { resp.ContentType = "application/json"; };
            return request;
        }
    }
}