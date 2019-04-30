/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 MessageTypeCommands
Purpose:                                      Contains commands to perform CRUD on MessageType
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class MessageTypeCommands : BaseCommands<MessageType>
    {
        /// <summary>
        /// Gets the list of Messagetype records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<MessageType> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetMessageTypeView, EntitiesAlias.MessageType, langCode: true);
        }

        /// <summary>
        /// Gets the specific Messagetype record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static MessageType Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetMessageType, langCode: true);
        }

        /// <summary>
        /// Creates a new Messagetype record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="messageType"></param>
        /// <returns></returns>
        public static MessageType Post(ActiveUser activeUser, MessageType messageType)
        {
            var parameters = GetParameters(messageType);
            // parameters.Add(new Parameter("@langCode", messageType.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(messageType));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertMessageType);
        }

        /// <summary>
        /// Updates the exisiting Messagetype record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="messageType"></param>
        /// <returns></returns>

        public static MessageType Put(ActiveUser activeUser, MessageType messageType)
        {
            var parameters = GetParameters(messageType);
            // parameters.Add(new Parameter("@langCode", messageType.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(messageType.Id, messageType));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateMessageType);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
            return 0;
        }

        /// <summary>
        /// Deletes a specific Messagetype record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.MessageType, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets a specific record based on messageType
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="sysMsgType"></param>
        /// <returns></returns>
        public static MessageType GetBySysMsgType(ActiveUser activeUser, string sysMsgType)
        {
            //var parameters = new[]
            //{
            //    new Parameter("@msgType", sysMsgType)
            //};
            //return SqlSerializer.Default.DeserializeSingleRecord<MessageType>(StoredProceduresConstant.GetMessageTypes,
            //    parameters, storedProcedure: true);
            throw new NotImplementedException();
        }

        /// <summary>
        /// Delete records based on messageType
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="sysMsgType"></param>
        /// <returns></returns>
        public static MessageType DeleteBySysMsgType(ActiveUser activeUser, string sysMsgType)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Gets list of paramters required for the message type Module
        /// </summary>
        /// <param name="messageType"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(MessageType messageType)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@langCode", messageType.LangCode),
               new Parameter("@sysRefId", messageType.SysRefId),
               new Parameter("@sysMsgtypeTitle", messageType.SysMsgtypeTitle),
                new Parameter("@statusId", messageType.StatusId),
           };
            return parameters;
        }
    }
}