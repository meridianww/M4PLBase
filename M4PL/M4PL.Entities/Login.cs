//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              27/3/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Login 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Login
    {
        public Login()
        {

        }

        public Login(string email, string pwd)
        {
            this.Email = email;
            this.Password = pwd;
        }
        //Login Only
        public bool RememberMe { get; set; }
        public bool IsValidUser { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
