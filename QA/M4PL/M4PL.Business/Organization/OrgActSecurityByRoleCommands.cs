/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSecurityByRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgActSecurityByRoleCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgActSecurityByRoleCommands;

namespace M4PL.Business.Organization
{
    public class OrgActSecurityByRoleCommands : BaseCommands<OrgActSecurityByRole>, IOrgActSecurityByRoleCommands
    {
        /// <summary>
        /// Get list of OrgActSecurityByRole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgActSecurityByRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific OrgActSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgActSecurityByRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new OrgActSecurityByRole record
        /// </summary>
        /// <param name="OrgActSecurityByRole"></param>
        /// <returns></returns>

        public OrgActSecurityByRole Post(OrgActSecurityByRole OrgActSecurityByRole)
        {
            return _commands.Post(ActiveUser, OrgActSecurityByRole);
        }

        /// <summary>
        /// Updates an existing OrgActSecurityByRole record
        /// </summary>
        /// <param name="OrgActSecurityByRole"></param>
        /// <returns></returns>

        public OrgActSecurityByRole Put(OrgActSecurityByRole OrgActSecurityByRole)
        {
            return _commands.Put(ActiveUser, OrgActSecurityByRole);
        }

        /// <summary>
        /// Deletes a specific OrgActSecurityByRole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of OrgActSecurityByRole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}