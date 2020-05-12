/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              17/12/2017
Program Name:                                 SystemAccountCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SystemAccountCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Administration.SystemAccountCommands;
using System;

namespace M4PL.Business.Administration
{
    public class SystemAccountCommands : BaseCommands<SystemAccount>, ISystemAccountCommands
    {
        /// <summary>
        /// Get list of systemAccounts data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<SystemAccount> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo).ToList();
        }

        /// <summary>
        /// Gets specific systemAccount record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public SystemAccount Get(long id)
        {
            var data = _commands.Get(ActiveUser, id);
            data.SysPassword = SecureString.Decrypt(data.SysPassword);
            return data;
        }

        /// <summary>
        /// Creates a new systemAccount record
        /// </summary>
        /// <param name="systemAccount"></param>
        /// <returns></returns>

        public SystemAccount Post(SystemAccount systemAccount)
        {
            systemAccount.SysPassword = SecureString.Encrypt(systemAccount.SysPassword);
            return _commands.Post(ActiveUser, systemAccount);
        }

        /// <summary>
        ///  Updates an existing systemAccount record
        /// </summary>
        /// <param name="systemAccount"></param>
        /// <returns></returns>

        public SystemAccount Put(SystemAccount systemAccount)
        {
            systemAccount.SysPassword = SecureString.Encrypt(systemAccount.SysPassword);
            return _commands.Put(ActiveUser, systemAccount);
        }

        /// <summary>
        /// Deletes a specific systemAccount record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of systemAccounts record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public SystemAccount Patch(SystemAccount entity)
        {
            throw new NotImplementedException();
        }
    }
}