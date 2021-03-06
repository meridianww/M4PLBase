﻿#region Copyright

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
// Program Name:                                 OrganizationCommands
// Purpose:                                      Contains commands to perform CRUD on Organization
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
	public class OrganizationCommands : BaseCommands<Entities.Organization.Organization>
	{
		/// <summary>
		/// Gets list of Organization records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Organization.Organization> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrganizationView, EntitiesAlias.Organization);
		}

		/// <summary>
		/// Gets the specific Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Organization.Organization Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetOrganization);
		}

		/// <summary>
		/// Creates a new Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="organization"></param>
		/// <returns></returns>

		public static Entities.Organization.Organization Post(ActiveUser activeUser, Entities.Organization.Organization organization)
		{
			var parameters = GetParameters(organization);
			// parameters.Add(new Parameter("@langCode", organization.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(organization));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertOrganization);
		}

		/// <summary>
		/// Updates the existing Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="organization"></param>
		/// <returns></returns>

		public static Entities.Organization.Organization Put(ActiveUser activeUser, Entities.Organization.Organization organization)
		{
			var parameters = GetParameters(organization);
			// parameters.Add(new Parameter("@langCode", organization.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(organization.Id, organization));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrganization);
		}

		/// <summary>
		/// Deletes a specific Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganization);
			return 0;
		}

		/// <summary>
		/// Deletes list of Organization records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.Organization, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Updates the existing Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="organization"></param>
		/// <returns></returns>

		public static Entities.Organization.Organization Patch(ActiveUser activeUser, Entities.Organization.Organization organization)
		{
			var parameters = GetParameterPartial(organization);
			parameters.AddRange(activeUser.PutDefaultParams(organization.Id, organization));
			return Patch(activeUser, parameters, StoredProceduresConstant.UpdatePartialOrganization);
		}

		/// <summary>
		/// Gets list of parameters required for the Organization Module
		/// </summary>
		/// <param name="organization"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Organization.Organization organization)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@orgCode", organization.OrgCode),
			   new Parameter("@orgTitle", organization.OrgTitle),
			   new Parameter("@orgGroupId", organization.OrgGroupId),
			   new Parameter("@orgSortOrder", organization.OrgSortOrder),
			   new Parameter("@statusId", organization.StatusId),
			   new Parameter("@orgContactId", null),
			   new Parameter("@orgWorkAddressId", organization.OrgWorkAddressId.HasValue &&  organization.OrgWorkAddressId > 0 ? organization.OrgWorkAddressId : null),
			   new Parameter("@orgBusinessAddressId", organization.OrgBusinessAddressId.HasValue &&  organization.OrgBusinessAddressId > 0 ? organization.OrgBusinessAddressId : null),
			   new Parameter("@orgCorporateAddressId", organization.OrgCorporateAddressId.HasValue &&  organization.OrgCorporateAddressId > 0 ? organization.OrgCorporateAddressId : null),
			   new Parameter("@BusinessAddress1", organization.BusinessAddress1),
			   new Parameter("@BusinessAddress2", organization.BusinessAddress2),
			   new Parameter("@BusinessCity", organization.BusinessCity),
			   new Parameter("@BusinessZipPostal", organization.BusinessZipPostal),
			   new Parameter("@BusinessStateId", organization.BusinessStateId),
			   new Parameter("@BusinessCountryId", organization.BusinessCountryId),
			   new Parameter("@CorporateAddress1", organization.CorporateAddress1),
			   new Parameter("@CorporateAddress2", organization.CorporateAddress2),
			   new Parameter("@CorporateCity", organization.CorporateCity),
			   new Parameter("@CorporateZipPostal", organization.CorporateZipPostal),
			   new Parameter("@CorporateStateId", organization.CorporateStateId),
			   new Parameter("@CorporateCountryId", organization.CorporateCountryId),
			   new Parameter("@WorkAddress1", organization.WorkAddress1),
			   new Parameter("@WorkAddress2", organization.WorkAddress2),
			   new Parameter("@WorkCity", organization.WorkCity),
			   new Parameter("@WorkZipPostal", organization.WorkZipPostal),
			   new Parameter("@WorkStateId", organization.WorkStateId),
			   new Parameter("@WorkCountryId", organization.WorkCountryId),
		   };
			return parameters;
		}

		/// <summary>
		/// Gets list of parameters required for the Organization Module
		/// </summary>
		/// <param name="organization"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameterPartial(Entities.Organization.Organization organization)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@orgCode", organization.OrgCode),
			   new Parameter("@orgTitle", organization.OrgTitle),
			   new Parameter("@orgGroupId", organization.OrgGroupId),
			   new Parameter("@orgSortOrder", organization.OrgSortOrder),
			   new Parameter("@statusId", organization.StatusId),
			   new Parameter("@orgContactId", null),
		   };
			return parameters;
		}
	}
}