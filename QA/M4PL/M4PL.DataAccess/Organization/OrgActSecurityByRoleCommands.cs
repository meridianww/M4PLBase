/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSecurityByRoleCommands
Purpose:                                      Contains commands to perform CRUD on OrgActSecurityByRole
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrgActSecurityByRoleCommands : BaseCommands<OrgActSecurityByRole>
    {
        /// <summary>
        /// Gets list of OrgActSecurityByRole details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<OrgActSecurityByRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgActSecurityByRoleView, EntitiesAlias.OrgActSecurityByRole);
        }

        /// <summary>
        /// Gets specific record detail related to OrgActSecurityByRole based on ActiveUser and Id
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static OrgActSecurityByRole Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrgActSecurityByRole);
        }

        /// <summary>
        /// Creates a new OrgActSecurityByRole in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="OrgActSecurityByRole"></param>
        /// <returns></returns>

        public static OrgActSecurityByRole Post(ActiveUser activeUser, OrgActSecurityByRole OrgActSecurityByRole)
        {
            var parameters = GetParameters(OrgActSecurityByRole);
            parameters.AddRange(activeUser.PostDefaultParams(OrgActSecurityByRole));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgActSecurityByRole);
        }

        /// <summary>
        /// Updates the Specific record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="OrgActSecurityByRole"></param>
        /// <returns></returns>
        public static OrgActSecurityByRole Put(ActiveUser activeUser, OrgActSecurityByRole OrgActSecurityByRole)
        {
            var parameters = GetParameters(OrgActSecurityByRole);
            parameters.AddRange(activeUser.PutDefaultParams(OrgActSecurityByRole.Id, OrgActSecurityByRole));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgActSecurityByRole);
        }

        /// <summary>
        /// Deletes the specific record from the database.
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrgActSecurityByRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of records from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.OrgActSecurityByRole, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the list of parameters required for the OrgActSecurityByRole Module
        /// </summary>
        /// <param name="OrgActSecurityByRole"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(OrgActSecurityByRole OrgActSecurityByRole)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@orgId", OrgActSecurityByRole.OrgId),
                new Parameter("@secLineOrder ", OrgActSecurityByRole.SecLineOrder),
                new Parameter("@mainModuleId", OrgActSecurityByRole.SecMainModuleId),
                new Parameter("@menuOptionLevelId", OrgActSecurityByRole.SecMenuOptionLevelId),
                new Parameter("@menuAccessLevelId", OrgActSecurityByRole.SecMenuAccessLevelId),
                new Parameter("@statusId", OrgActSecurityByRole.StatusId),
                new Parameter("@actRoleId", OrgActSecurityByRole.OrgActRoleId),
                new Parameter("@where", string.Format(" AND {0}={1} ", OrgActSecurityByRoleColumns.OrgActRoleId.ToString(), OrgActSecurityByRole.OrgActRoleId)),
            };
            return parameters;
        }
    }
}