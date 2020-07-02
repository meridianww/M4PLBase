#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 OrgRefRoleCommands
// Purpose:                                      Contains commands to perform CRUD on OrgRefRole
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
	public class OrgRefRoleCommands : BaseCommands<OrgRefRole>
	{
		/// <summary>
		/// Gets list of OrgRefRole records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<OrgRefRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgRefRoleView, EntitiesAlias.OrgRefRole);
		}

		/// <summary>
		/// Gets the specific OrgRefRole record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static OrgRefRole Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetOrgRefRole);
		}

		/// <summary>
		/// Creates a new OrgRefRole record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgRefRole"></param>
		/// <returns></returns>

		public static OrgRefRole Post(ActiveUser activeUser, OrgRefRole orgRefRole)
		{
			var parameters = GetParameters(orgRefRole);
			parameters.AddRange(activeUser.PostDefaultParams(orgRefRole));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgRefRole);
		}

		/// <summary>
		/// Updates the existing OrgRefRole record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgRefRole"></param>
		/// <returns></returns>

		public static OrgRefRole Put(ActiveUser activeUser, OrgRefRole orgRefRole)
		{
			var parameters = GetParameters(orgRefRole);
			parameters.AddRange(activeUser.PutDefaultParams(orgRefRole.Id, orgRefRole));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgRefRole);
		}

		/// <summary>
		/// Deletes a specific OrgRefRole record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationRefRole);
			return 0;
		}

		/// <summary>
		/// Deletes list of OrgRefRole records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.OrgRefRole, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the OrgRefRole Module
		/// </summary>
		/// <param name="orgRefRole"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(OrgRefRole orgRefRole)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@orgId", orgRefRole.OrganizationId),
			   new Parameter("@orgRoleSortOrder", orgRefRole.OrgRoleSortOrder),
			   new Parameter("@orgRoleCode", orgRefRole.OrgRoleCode),
			   new Parameter("@orgRoleDefault", orgRefRole.OrgRoleDefault),
			   new Parameter("@orgRoleTitle", orgRefRole.OrgRoleTitle),
               //new Parameter("@orgRoleContactId", orgRefRole.OrgRoleContactID),
               new Parameter("@roleTypeId", orgRefRole.RoleTypeId),
               //new Parameter("@orgLogical", orgRefRole.OrgLogical),
               //new Parameter("@prgLogical", orgRefRole.PrgLogical),
               //new Parameter("@prjLogical", orgRefRole.PrjLogical),
               //new Parameter("@jobLogical", orgRefRole.JobLogical),
               //new Parameter("@prxContactDefault", orgRefRole.PrxContactDefault),
               new Parameter("@prxJobDefaultAnalyst", orgRefRole.PrxJobDefaultAnalyst),
			   new Parameter("@prxJobDefaultResponsible", orgRefRole.PrxJobDefaultResponsible),
			   new Parameter("@prxJobGWDefaultAnalyst", orgRefRole.PrxJobGWDefaultAnalyst),
			   new Parameter("@prxJobGWDefaultResponsible", orgRefRole.PrxJobGWDefaultResponsible),
               //new Parameter("@phsLogical", orgRefRole.PhsLogical),
               new Parameter("@statusId", orgRefRole.StatusId),
			};
			return parameters;
		}
	}
}