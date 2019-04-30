/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSubSecurityByRoleCommands
Purpose:                                      Contains commands to perform CRUD on OrgActSubSecurityByRole
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrgActSubSecurityByRoleCommands : BaseCommands<OrgActSubSecurityByRole>
    {
        /// <summary>
        /// Gets list of OrgActSubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<OrgActSubSecurityByRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgActSubSecurityByRoleView, EntitiesAlias.OrgActSubSecurityByRole);
        }

        /// <summary>
        /// Gets specific record detail based on the Id and Active user Details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static OrgActSubSecurityByRole Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrgActSubSecurityByRole);
        }

        /// <summary>
        /// Creates a new OrgActSubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="OrgActSubSecurityByRole"></param>
        /// <returns></returns>
        public static OrgActSubSecurityByRole Post(ActiveUser activeUser, OrgActSubSecurityByRole OrgActSubSecurityByRole)
        {
            var parameters = GetParameters(OrgActSubSecurityByRole);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(OrgActSubSecurityByRole));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgActSubSecurityByRole);
        }

        /// <summary>
        /// Updates the specific OrgActSubSecurityByRole
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="OrgActSubSecurityByRole"></param>
        /// <returns></returns>
        public static OrgActSubSecurityByRole Put(ActiveUser activeUser, OrgActSubSecurityByRole OrgActSubSecurityByRole)
        {
            var parameters = GetParameters(OrgActSubSecurityByRole);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(OrgActSubSecurityByRole.Id, OrgActSubSecurityByRole));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgActSubSecurityByRole);
        }

        /// <summary>
        /// Deletes the Role from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrgActSubSecurityByRole);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.OrgActSubSecurityByRole, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the parameters required for the OrgActSubSecurityByRole module
        /// </summary>
        /// <param name="OrgActSubSecurityByRole"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(OrgActSubSecurityByRole OrgActSubSecurityByRole)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@secByRoleId", OrgActSubSecurityByRole.SecByRoleId),
                new Parameter("@refTableName", OrgActSubSecurityByRole.RefTableName),
                new Parameter("@menuOptionLevelId", OrgActSubSecurityByRole.SubsMenuOptionLevelId),
                new Parameter("@menuAccessLevelId", OrgActSubSecurityByRole.SubsMenuAccessLevelId),
                new Parameter("@statusId", OrgActSubSecurityByRole.StatusId),
            };
            return parameters;
        }
    }
}