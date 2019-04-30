/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgActRoleCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgActRoleCommands;

namespace M4PL.Business.Organization
{
    public class OrgActRoleCommands : BaseCommands<OrgActRole>, IOrgActRoleCommands
    {
        public IList<OrgActRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public OrgActRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public OrgActRole Post(OrgActRole orgActRole)
        {
            return _commands.Post(ActiveUser, orgActRole);
        }

        public OrgActRole Put(OrgActRole orgActRole)
        {
            return _commands.Put(ActiveUser, orgActRole);
        }

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}