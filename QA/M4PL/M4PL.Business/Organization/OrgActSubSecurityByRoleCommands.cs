/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSubSecurityByRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgActSubSecurityByRoleCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgActSubSecurityByRoleCommands;

namespace M4PL.Business.Organization
{
    public class OrgActSubSecurityByRoleCommands : BaseCommands<OrgActSubSecurityByRole>, IOrgActSubSecurityByRoleCommands
    {
        /// <summary>
        /// Get list of OrgActSubSecurityByRole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgActSubSecurityByRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific OrgActSubSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgActSubSecurityByRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new OrgActSubSecurityByRole record
        /// </summary>
        /// <param name="OrgActSubSecurityByRole"></param>
        /// <returns></returns>

        public OrgActSubSecurityByRole Post(OrgActSubSecurityByRole OrgActSubSecurityByRole)
        {
            return _commands.Post(ActiveUser, OrgActSubSecurityByRole);
        }

        /// <summary>
        /// Updates an existing OrgActSubSecurityByRole record
        /// </summary>
        /// <param name="OrgActSubSecurityByRole"></param>
        /// <returns></returns>

        public OrgActSubSecurityByRole Put(OrgActSubSecurityByRole OrgActSubSecurityByRole)
        {
            return _commands.Put(ActiveUser, OrgActSubSecurityByRole);
        }

        /// <summary>
        /// Deletes a specific OrgActSubSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of OrgActSubSecurityByRole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}