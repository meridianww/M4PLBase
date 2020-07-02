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
// Program Name:                                 OrgRefRoleCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgRefRoleCommands
//====================================================================================================================

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgRefRoleCommands;

namespace M4PL.Business.Organization
{
    public class OrgRefRoleCommands : BaseCommands<OrgRefRole>, IOrgRefRoleCommands
    {
        /// <summary>
        /// Get list of OrgRefRole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgRefRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific OrgRefRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgRefRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new OrgRefRole record
        /// </summary>
        /// <param name="orgRefRole"></param>
        /// <returns></returns>

        public OrgRefRole Post(OrgRefRole orgRefRole)
        {
            return _commands.Post(ActiveUser, orgRefRole);
        }

        /// <summary>
        /// Updates an existing OrgRefRole record
        /// </summary>
        /// <param name="orgRefRole"></param>
        /// <returns></returns>

        public OrgRefRole Put(OrgRefRole orgRefRole)
        {
            return _commands.Put(ActiveUser, orgRefRole);
        }

        /// <summary>
        /// Deletes a specific OrgRefRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of OrgRefRole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public OrgRefRole Patch(OrgRefRole entity)
        {
            throw new NotImplementedException();
        }
    }
}