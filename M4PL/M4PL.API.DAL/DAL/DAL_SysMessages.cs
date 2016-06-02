//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Ramkumar 
//Date Programmed:                              2/6/2016
//Program Name:                                 System Messages
//Purpose:                                      Create, access, and review data from database for System Messages
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

namespace M4PL.DataAccess.DAL
{
    public class DAL_SysMessages
    {
      

        /// <summary>
        /// Function to get System Predefined Messages from the DB
        /// </summary>
        /// <returns></returns>
        public static List<disMessages> GetSysMessagesTemplates()
        {
            return SqlSerializer.Default.DeserializeMultiRecords<disMessages>(StoredProcedureNames.GetSysMessagesTemplates,  new Parameter[] { }, false, true);
        }
    }
}
