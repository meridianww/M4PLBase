/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 SecurityByRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SecurityByRoleCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.SecurityByRoleCommands;

namespace M4PL.Business.Administration
{
    public class SecurityByRoleCommands : BaseCommands<SecurityByRole>, ISecurityByRoleCommands
    {
        /// <summary>
        /// Get list of securitybyrole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<SecurityByRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific securitybyrole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public SecurityByRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new securitybyrole record
        /// </summary>
        /// <param name="securityByRole"></param>
        /// <returns></returns>

        public SecurityByRole Post(SecurityByRole securityByRole)
        {
            return _commands.Post(ActiveUser, securityByRole);
        }

        /// <summary>
        /// Updates an existing securitybyrole record
        /// </summary>
        /// <param name="securityByRole"></param>
        /// <returns></returns>

        public SecurityByRole Put(SecurityByRole securityByRole)
        {
            return _commands.Put(ActiveUser, securityByRole);
        }

        /// <summary>
        /// Deletes a specific securitybyrole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of securitybyrole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public SecurityByRole Patch(SecurityByRole entity)
        {
            throw new NotImplementedException();
        }
    }
}