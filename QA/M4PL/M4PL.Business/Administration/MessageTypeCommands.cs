/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 MessageTypeCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.MessageTypeCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.MessageTypeCommands;
using System;

namespace M4PL.Business.Administration
{
    public class MessageTypeCommands : BaseCommands<MessageType>, IMessageTypeCommands
    {
        /// <summary>
        /// Get list of message type data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<MessageType> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific message type record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public MessageType Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new message type record
        /// </summary>
        /// <param name="messageType"></param>
        /// <returns></returns>

        public MessageType Post(MessageType messageType)
        {
            return _commands.Post(ActiveUser, messageType);
        }

        /// <summary>
        /// Updates an existing message type record
        /// </summary>
        /// <param name="messageType"></param>
        /// <returns></returns>

        public MessageType Put(MessageType messageType)
        {
            return _commands.Put(ActiveUser, messageType);
        }

        /// <summary>
        /// Deletes a specific message type record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of message type record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Deletes message type based on the system message type
        /// </summary>
        /// <param name="sysMsgType"></param>
        /// <returns></returns>

        public MessageType DeleteBySysMsgType(string sysMsgType)
        {
            return _commands.DeleteBySysMsgType(ActiveUser, sysMsgType);
        }

        /// <summary>
        /// Get message type based on the System message type
        /// </summary>
        /// <param name="sysMsgType"></param>
        /// <returns></returns>

        public MessageType GetBySysMsgType(string sysMsgType)
        {
            return _commands.GetBySysMsgType(ActiveUser, sysMsgType);
        }

        public IList<MessageType> GetAllData()
        {
            throw new NotImplementedException();
        }

		public MessageType Patch(MessageType entity)
		{
			throw new NotImplementedException();
		}
	}
}