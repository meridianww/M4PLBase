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
        /// <summary>
        /// Function to get System Predefined Messages from the DB
        /// </summary>
        /// <returns></returns>
        public static List<disMessages> GetSysMessagesTemplates(string screenName)
        {
            return DAL_SysMessages.GetSysMessagesTemplates(screenName);
        }
    }
}
