//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Ramkumar
//Date Programmed:                              2/6/2016
//Program Name:                                 System Messages
//Purpose:                                      Includes a business-logic layer that enforces System Messages
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
    public class BAL_SysMessages
    {
        static List<disMessages> lstmsg;
        /// <summary>
        /// Function to get System Predefined Messages from the DB
        /// </summary>
        /// <returns></returns>
        public static List<disMessages> GetSysMessagesTemplates(string screenName, string action = "")
        {
            if (lstmsg == null)
            {
                lstmsg = DAL_SysMessages.GetSysMessagesTemplates(screenName, action);
              
            }
            var lstmesh = from a in lstmsg
                           where a.SysScreenName.ToLower() == screenName.ToLower() 
                           where a.SysScreenAction.ToLower() == action.ToLower()
                           select a;
            return lstmesh.ToList<disMessages>();
           

            //return lstmsg;
        }

        /// <summary>
        /// Function to get the list of all System Messages
        /// </summary>
        /// <returns></returns>
        public static List<disMessages> GetAllSystemMessages(int UserId = 0)
        {
            return DAL_SysMessages.GetAllSystemMessages(UserId);
        }

        /// <summary>
        /// Function to get the details of selected System Message
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public static SystemMessages GetSystemMessageDetails(int SystemMessagesID)
        {
            return DAL_SysMessages.GetSystemMessageDetails(SystemMessagesID);
        }

        /// <summary>
        /// Function to Save SystemMessages details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveSystemMessages(SystemMessages value)
        {
            return DAL_SysMessages.SaveSystemMessages(value);
        }

        /// <summary>
        /// Function to Delete System Message details
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public static int RemoveSystemMessage(int SystemMessagesID)
        {
            return DAL_SysMessages.RemoveSystemMessage(SystemMessagesID);
        }
    }
}
