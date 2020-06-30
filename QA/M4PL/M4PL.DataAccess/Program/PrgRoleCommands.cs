/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgRoleCommands
Purpose:                                      Contains commands to perform CRUD on PrgRole
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgRoleCommands : BaseCommands<PrgRole>
    {
        /// <summary>
        /// Gets list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetProgramRoleView, EntitiesAlias.PrgRole);
        }

        /// <summary>
        /// Gets the specific SystemMessageCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgRole Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetProgramRole);
        }

        /// <summary>
        /// Creates a new SystemMessageCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="programRole"></param>
        /// <returns></returns>

        public static PrgRole Post(ActiveUser activeUser, PrgRole programRole)
        {
            var parameters = GetParameters(programRole);
            parameters.AddRange(activeUser.PostDefaultParams(programRole));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertProgramRole);
        }

        /// <summary>
        /// Updates the existing SystemMessageCode recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="programRole"></param>
        /// <returns></returns>

        public static PrgRole Put(ActiveUser activeUser, PrgRole programRole)
        {
            var parameters = GetParameters(programRole);
            parameters.AddRange(activeUser.PutDefaultParams(programRole.Id, programRole));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateProgramRole);
        }

        /// <summary>
        /// Deletes a specific SystemPageTableName record
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
        ///Deletes list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgRole, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the systemPageTabName Module
        /// </summary>
        /// <param name="programRole"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgRole programRole)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@orgId", programRole.OrgID),
               new Parameter("@programId", programRole.ProgramID),
               new Parameter("@prgRoleSortOrder", programRole.PrgRoleSortOrder),
               new Parameter("@orgRoleId", programRole.OrgRefRoleId),
               new Parameter("@prgRoleId", programRole.PrgRoleId),
               new Parameter("@prgRoleTitle", programRole.PrgRoleTitle),
               new Parameter("@prgRoleContactId", programRole.PrgRoleContactID),
               new Parameter("@roleTypeId", programRole.RoleTypeId),
               new Parameter("@statusId", programRole.StatusId),
               new Parameter("@prgRoleCode", programRole.ProgramRoleCode),
               new Parameter("@prxJobDefaultAnalyst", programRole.PrxJobDefaultAnalyst),
               new Parameter("@prxJobDefaultResponsible", programRole.PrxJobDefaultResponsible),
               new Parameter("@prxJobGWDefaultAnalyst", programRole.PrxJobGWDefaultAnalyst),
               new Parameter("@prxJobGWDefaultResponsible", programRole.PrxJobGWDefaultResponsible)
            };
            return parameters;
        }
    }
}