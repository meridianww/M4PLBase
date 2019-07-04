/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SystemReferenceCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SystemReferenceCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.SystemReferenceCommands;
using System;

namespace M4PL.Business.Administration
{
    public class SystemReferenceCommands : BaseCommands<SystemReference>, ISystemReferenceCommands
    {
        /// <summary>
        /// Deletes a specific system reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of system reference record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Get list of system reference data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>

        public IList<SystemReference> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific system reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public SystemReference Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new system reference record
        /// </summary>
        /// <param name="systemReference"></param>
        /// <returns></returns>

        public SystemReference Post(SystemReference systemReference)
        {
            return _commands.Post(ActiveUser, systemReference);
        }

        /// <summary>
        /// Updates an existing system reference record
        /// </summary>
        /// <param name="systemReference"></param>
        /// <returns></returns>

        public SystemReference Put(SystemReference systemReference)
        {
            return _commands.Put(ActiveUser, systemReference);
        }

        public SystemReference Get(long id, long parentId)
        {
            return _commands.Get(ActiveUser, id);
        }

        public IList<IdRefLangName> GetDeletedRecordLookUpIds(string allIds)
        {
            return _commands.GetDeletedRecordLookUpIds(ActiveUser, allIds);
        }

        public IList<SystemReference> Get()
        {
            throw new NotImplementedException();
        }
    }
}