/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SubSecurityByRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SubSubSecurityByRoleCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.SubSecurityByRoleCommands;

namespace M4PL.Business.Administration
{
    public class SubSecurityByRoleCommands : BaseCommands<SubSecurityByRole>, ISubSecurityByRoleCommands
    {
        /// <summary>
        /// Get list of SubSubSecurityByRole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<SubSecurityByRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific SubSubSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public SubSecurityByRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new SubSubSecurityByRole record
        /// </summary>
        /// <param name="subSecurityByRole"></param>
        /// <returns></returns>

        public SubSecurityByRole Post(SubSecurityByRole subSecurityByRole)
        {
            return _commands.Post(ActiveUser, subSecurityByRole);
        }

        /// <summary>
        /// Updates an existing SubSubSecurityByRole record
        /// </summary>
        /// <param name="subSecurityByRole"></param>
        /// <returns></returns>

        public SubSecurityByRole Put(SubSecurityByRole subSecurityByRole)
        {
            return _commands.Put(ActiveUser, subSecurityByRole);
        }

        /// <summary>
        /// Deletes a specific SubSubSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of SubSubSecurityByRole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public SubSecurityByRole Patch(SubSecurityByRole entity)
        {
            throw new NotImplementedException();
        }
    }
}