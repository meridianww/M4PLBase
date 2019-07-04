/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgRefRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgRefRoleCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgRefRoleCommands;
using System;

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

        public IList<OrgRefRole> Get()
        {
            throw new NotImplementedException();
        }
    }
}