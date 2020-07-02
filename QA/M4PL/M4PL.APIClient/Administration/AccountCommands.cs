#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 AccountCommands
// Purpose:                                      Client to consume M4PL API called AccountController
//===================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using RestSharp;
using System.Configuration;
using System.Linq;

namespace M4PL.APIClient.Administration
{
    public class AccountCommands
    {
        /// <summary>
        /// Route to call active users
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public static ActiveUser GetActiveUser(Login login)
        {
            var activeUser = new ActiveUser();
            var result = new RestClient(ConfigurationManager.AppSettings["WebAPIURL"]).Execute(
                  HttpRestClient.RestRequest(Method.POST, "Account/Login")
                      .AddObject(login)).Content;
            UserToken token = null;

            try
            {
                token = JsonConvert.DeserializeObject<ApiResult<UserToken>>(result).Results?.FirstOrDefault();
            }
            catch (System.Exception)
            {
            }

            if (token != null)
                if (!string.IsNullOrEmpty(token.SystemMessage))
                    activeUser.SystemMessage = token.SystemMessage;
                else
                {
                    var tokenRequest = HttpRestClient.RestRequest(Method.GET, "Account/ActiveUser");
                    tokenRequest.AddHeader("Authorization", "bearer " + token.AccessToken);
                    activeUser = JsonConvert.DeserializeObject<ApiResult<ActiveUser>>(new RestClient(ConfigurationManager.AppSettings["WebAPIURL"]).Execute(tokenRequest).Content).Results?.FirstOrDefault();
                    activeUser.AuthToken = token.AccessToken;
                }
            return activeUser;
        }

        public static int LogOut(ActiveUser activeUser)
        {
            var request = HttpRestClient.RestRequest(Method.POST, "Account/LogOut");

            request.AddHeader("Content-Type", "application/json; charset=utf-8");
            request.AddHeader("Authorization", "bearer " + activeUser.AuthToken);
            request.OnBeforeDeserialization = resp =>
            {
                resp.ContentType = "application/json";
                resp.Content = resp.Content.Replace("[]", "{}");
            };
            var result = JsonConvert.DeserializeObject<ApiResult<int>>(new RestClient(ConfigurationManager.AppSettings["WebAPIURL"]).Execute(request).Content).Results?.FirstOrDefault();

            return result.HasValue ? (int)result : 0;
        }

        public static ActiveUser SwitchOrganization(Login login)
        {
            var activeUser = new ActiveUser();
            var token = JsonConvert.DeserializeObject<ApiResult<UserToken>>(new RestClient(ConfigurationManager.AppSettings["WebAPIURL"]).Execute(
                  HttpRestClient.RestRequest(Method.POST, "Account/SwitchOrganization")
                      .AddObject(login)).Content).Results?.FirstOrDefault();

            if (token != null)
                if (!string.IsNullOrEmpty(token.SystemMessage))
                    activeUser.SystemMessage = token.SystemMessage;
                else
                {
                    var tokenRequest = HttpRestClient.RestRequest(Method.GET, "Account/ActiveUser");
                    tokenRequest.AddHeader("Authorization", "bearer " + token.AccessToken);
                    activeUser = JsonConvert.DeserializeObject<ApiResult<ActiveUser>>(new RestClient(ConfigurationManager.AppSettings["WebAPIURL"]).Execute(tokenRequest).Content).Results?.FirstOrDefault();
                    activeUser.AuthToken = token.AccessToken;
                }
            return activeUser;
        }
    }
}