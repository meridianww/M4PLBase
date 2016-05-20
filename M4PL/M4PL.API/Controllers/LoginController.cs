//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              27/3/2016
//Program Name:                                 Login
//Purpose:                                      Returns serialized data for Login Webpage
//
//==================================================================================================================================================== 

using M4PL.Entities;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Security;

namespace M4PL.API.Controllers
{
    public class LoginController : ApiController
    {
        /// <summary>
        /// Function to Authenticate User when Login
        /// </summary>
        /// <param name="emailId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public bool Get(string emailId, string password)
        {
            var res = BAL_User.AuthenticateUser(emailId, password);
            if (res)
                FormsAuthentication.SetAuthCookie(emailId, true);
            return res;
        }
    }
}
