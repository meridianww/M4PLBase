//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              2/5/2016
//Program Name:                                 User
//Purpose:                                      Create, access, and review data from database for User
//
//==================================================================================================================================================== 

using M4PL.DataAccess.Serializer;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL_API_DAL.DAL;

namespace M4PL.DataAccess.DAL
{
    public class DAL_User
    {
        /// <summary>
        /// Function to Save user details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveUserAccount(User user)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",user.SysUserID),
				new Parameter("@SysUserContactID",user.SysUserContactID),
				new Parameter("@SysScreenName",user.SysScreenName),
				new Parameter("@SysPassword",user.SysPassword),
				new Parameter("@SysComments",user.SysComments),
				new Parameter("@SysStatusAccount",user.SysStatusAccount),
				new Parameter("@SysEnteredBy",user.SysEnteredBy),
				new Parameter("@SysDateChangedBy",user.SysDateChangedBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveUserAccount, parameters, true);
        }

        /// <summary>
        /// Function to Delete user details
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public static int RemoveUserAccount(long UserID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",UserID)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveUserAccount, parameters, true);
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="UserID"></param>
        /// <returns></returns>
        public static User GetUserAccount(long UserID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",UserID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<User>(StoredProcedureNames.GetUserAccount, parameters, false, true);
        }

        /// <summary>
        /// Function to get the list of all users
        /// </summary>
        /// <returns></returns>
        public static List<disUser> GetAllUserAccounts(int UserId = 0)
        {
            return SqlSerializer.Default.DeserializeMultiRecords<disUser>(StoredProcedureNames.GetAllUserAccounts, new Parameter("@ColUserId", UserId), false, true);
        }

    }
}
