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
        public static List<disMessages> GetSysMessagesTemplates(string screenName, string action)
        {
            return SqlSerializer.Default.DeserializeMultiRecords<disMessages>(StoredProcedureNames.GetSysMessagesTemplates,
            new Parameter[] { new Parameter("@ScreenName", screenName), new Parameter("@ScreenAction", action) }, false, true);
        }

        /// <summary>
        /// Function to Delete System Message details
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public static int RemoveSystemMessage(int SystemMessagesID)
        {
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveSystemMessage, new Parameter("@SysMessageID", SystemMessagesID), true);
        }

        /// <summary>
        /// Function to Save SystemMessages details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveSystemMessages(SystemMessages value)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@SysMessageID",value.SysMessageID),
				new Parameter("@SysScreenName",value.SysScreenName),
				new Parameter("@SysMsgType",value.SysMsgType),
				new Parameter("@SysMessageCode",value.SysMessageCode),
				new Parameter("@sysMessageScreenTitle",value.sysMessageScreenTitle),
				new Parameter("@SysMessageTitle",value.SysMessageTitle),
				new Parameter("@SysMessageDescription",value.SysMessageDescription),
				new Parameter("@SysMessageInstruction",value.SysMessageInstruction),
				new Parameter("@SysMessageButtonSelection",value.SysMessageButtonSelection),
				new Parameter("@SysMessageDateEntered",value.SysMessageDateEntered),
				new Parameter("@SysMessageEnteredBy",value.SysMessageEnteredBy),
				new Parameter("@SysMessageDateChanged",value.SysMessageDateChanged),
				new Parameter("@SysMessageDateChangedBy",value.SysMessageDateChangedBy),
				new Parameter("@SysLanguageCode",value.SysLanguageCode)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveSystemMessages, parameters, true);
        }

        /// <summary>
        /// Function to get the details of selected System Message
        /// </summary>
        /// <param name="SystemMessagesID"></param>
        /// <returns></returns>
        public static SystemMessages GetSystemMessageDetails(int SystemMessagesID)
        {
            return SqlSerializer.Default.DeserializeSingleRecord<SystemMessages>(StoredProcedureNames.GetSystemMessageDetails, new Parameter("@SysMessageID", SystemMessagesID), false, true);
        }

        /// <summary>
        /// Function to get the list of all System Messages
        /// </summary>
        /// <returns></returns>
        public static List<disMessages> GetAllSystemMessages(int UserId = 0)
        {

            return SqlSerializer.Default.DeserializeMultiRecords<disMessages>(StoredProcedureNames.GetAllSystemMessages, new Parameter("@ColUserId", UserId), false, true);
        }
    }
}
