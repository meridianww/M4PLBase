﻿using M4PL.Entities;
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
