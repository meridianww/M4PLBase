//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              17/5/2016
//Program Name:                                 Contact
//Purpose:                                      Business Logic specific to Error 
//
//==================================================================================================================================================== 

using M4PL.Entities;
using M4PL_API_DAL.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_ErrorLog
    {
        /// <summary>
        /// Logs the Exception to database
        /// </summary>
        /// <param name="errorLog"></param>
        public static void LogException(LogError errorLog)
        {
            DAL_ErrorLog.LogException(errorLog);
        }
    }
}
