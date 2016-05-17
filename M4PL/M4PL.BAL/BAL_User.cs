//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/5/2016
//Program Name:                                 User
//Purpose:                                      Includes a business-logic layer that enforces User details
//
//==================================================================================================================================================== 

using M4PL.DataAccess.DAL;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_User
    {
        /// <summary>
        /// Function to Authenticate User when Login
        /// </summary>
        /// <param name="emailId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static bool AuthenticateUser(string emailId, string password)
        {
            //Call database layer

            if (emailId == "antony@gmail.com" && password.ToLower() == "password")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Function to Save user details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveUserAccount(User user)
        {
            return DAL_User.SaveUserAccount(user);
        }

        /// <summary>
        /// Function to Delete user details
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public static int RemoveUserAccount(long UserID)
        {
            return DAL_User.RemoveUserAccount(UserID);
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public static User GetUserAccount(long UserID)
        {
            return DAL_User.GetUserAccount(UserID);
        }

        /// <summary>
        /// Function to get the list of all users
        /// </summary>
        /// <returns></returns>
        public static List<disUser> GetAllUserAccounts(int UserId = 0)
        {
            return DAL_User.GetAllUserAccounts(UserId);
        }

    }
}
