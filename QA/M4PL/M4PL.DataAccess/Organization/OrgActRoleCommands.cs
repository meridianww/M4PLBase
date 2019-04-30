/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgActRoleCommands
Purpose:                                      Contains commands to perform CRUD on OrgActRole
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
    public class OrgActRoleCommands : BaseCommands<OrgActRole>
    {
        /// <summary>
        /// Gets list of OrgActRole records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<OrgActRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgActRoleView, EntitiesAlias.OrgActRole);
        }

        /// <summary>
        /// Gets the specific OrgActRole record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static OrgActRole Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetOrgActRole);
        }

        /// <summary>
        /// Creates a new OrgActRole record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgActRole"></param>
        /// <returns></returns>

        public static OrgActRole Post(ActiveUser activeUser, OrgActRole orgActRole)
        {
            var parameters = GetParameters(orgActRole);
            parameters.AddRange(activeUser.PostDefaultParams(orgActRole));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgActRole);
        }

        /// <summary>
        /// Updates the existing OrgActRole record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="orgActRole"></param>
        /// <returns></returns>

        public static OrgActRole Put(ActiveUser activeUser, OrgActRole orgActRole)
        {
            var parameters = GetParameters(orgActRole);
            parameters.AddRange(activeUser.PutDefaultParams(orgActRole.Id, orgActRole));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgActRole);
        }

        /// <summary>
        /// Deletes a specific OrgActRole record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of OrgActRole records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.OrgActRole, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the OrgActRole Module
        /// </summary>
        /// <param name="orgActRole"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(OrgActRole orgActRole)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", orgActRole.OrgID),
               new Parameter("@orgRoleSortOrder", orgActRole.OrgRoleSortOrder),
               new Parameter("@orgRefRoleId", orgActRole.OrgRefRoleId),
               new Parameter("@orgRoleDefault", orgActRole.OrgRoleDefault),
               new Parameter("@orgRoleTitle", orgActRole.OrgRoleTitle),
               new Parameter("@orgRoleContactId", orgActRole.OrgRoleContactID),
               new Parameter("@roleTypeId", orgActRole.RoleTypeId),
               //new Parameter("@orgLogical", orgActRole.OrgLogical),
               //new Parameter("@prgLogical", orgActRole.PrgLogical),
               //new Parameter("@prjLogical", orgActRole.PrjLogical),
               //new Parameter("@phsLogical", orgActRole.PhsLogical),
               //new Parameter("@jobLogical", orgActRole.JobLogical),
               //new Parameter("@prxContactDefault", orgActRole.PrxContactDefault),
               new Parameter("@prxJobDefaultAnalyst", orgActRole.PrxJobDefaultAnalyst),
               new Parameter("@prxJobDefaultResponsible", orgActRole.PrxJobDefaultResponsible),
               new Parameter("@prxJobGWDefaultAnalyst", orgActRole.PrxJobGWDefaultAnalyst),
               new Parameter("@prxJobGWDefaultResponsible", orgActRole.PrxJobGWDefaultResponsible),
               new Parameter("@statusId", orgActRole.StatusId)
           };
            return parameters;
        }
    }
}