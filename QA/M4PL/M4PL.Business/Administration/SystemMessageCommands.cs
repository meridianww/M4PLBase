#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 SystemMessageCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SystemMessageCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.SystemMessageCommands;

namespace M4PL.Business.Administration
{
    public class SystemMessageCommands : BaseCommands<SystemMessage>, ISystemMessageCommands
    {
        /// <summary>
        /// Get list of message message data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<SystemMessage> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific system messsage record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public SystemMessage Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new system messsage record
        /// </summary>
        /// <param name="systemMessage"></param>
        /// <returns></returns>

        public SystemMessage Post(SystemMessage systemMessage)
        {
            return _commands.Post(ActiveUser, systemMessage);
        }

        /// <summary>
        /// Updates an existing system messsage record
        /// </summary>
        /// <param name="systemMessage"></param>
        /// <returns></returns>

        public SystemMessage Put(SystemMessage systemMessage)
        {
            return _commands.Put(ActiveUser, systemMessage);
        }

        /// <summary>
        /// Deletes a specific system messsage record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of system messsage records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Gets system messsage based on the System message code
        /// </summary>
        /// <param name="sysMsgCode"></param>
        /// <returns></returns>

        public SystemMessage GetBySysMessageCode(string sysMsgCode)
        {
            return _commands.GetBySysMessageCode(ActiveUser, sysMsgCode);
        }

        /// <summary>
        /// Delete system messsage based on the system message code
        /// </summary>
        /// <param name="sysMsgCode"></param>
        /// <returns></returns>

        public SystemMessage DeleteBySysMessageCode(string sysMsgCode)
        {
            return _commands.DeleteBySysMessageCode(ActiveUser, sysMsgCode);
        }

        public SystemMessage Patch(SystemMessage entity)
        {
            throw new NotImplementedException();
        }
    }
}