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
// Program Name:                                 OrgPocContactCommands
// Purpose:                                      Contains commands to perform CRUD on OrgPocContact
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
	public class OrgPocContactCommands : BaseCommands<OrgPocContact>
	{
		/// <summary>
		/// Gets list of OrgPocContact records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<OrgPocContact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgPocContactView, EntitiesAlias.OrgPocContact);
		}

		/// <summary>
		/// Gets the specific OrgPocContact record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static OrgPocContact Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetOrgPocContact);
		}

		/// <summary>
		/// Creates a new OrgPocContact record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgPocContact"></param>
		/// <returns></returns>

		public static OrgPocContact Post(ActiveUser activeUser, OrgPocContact orgPocContact)
		{
			var parameters = GetParameters(orgPocContact);
			// parameters.Add(new Parameter("@langCode", orgPocContact.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(orgPocContact));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgPocContact);
		}

		/// <summary>
		/// Updates the existing OrgPocContact record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgPocContact"></param>
		/// <returns></returns>

		public static OrgPocContact Put(ActiveUser activeUser, OrgPocContact orgPocContact)
		{
			var parameters = GetParameters(orgPocContact);
			// parameters.Add(new Parameter("@langCode", orgPocContact.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(orgPocContact.Id, orgPocContact));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgPocContact);
		}

		/// <summary>
		/// Deletes a specific OrgPocContact record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationPocContact);
			return 0;
		}

		/// <summary>
		/// Deletes list of OrgPocContact records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.OrgPocContact, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the OrgPocContact Module
		/// </summary>
		/// <param name="orgPocContact"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(OrgPocContact orgPocContact)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@orgId", orgPocContact.OrganizationId),
			   new Parameter("@contactId", orgPocContact.ContactMSTRID),
			   new Parameter("@pocCodeId", orgPocContact.ConCodeId),
			   new Parameter("@pocTitle", orgPocContact.ConTitle),
			   new Parameter("@pocTypeId", orgPocContact.ConTableTypeId),
			   new Parameter("@pocDefault", orgPocContact.ConIsDefault),
			   new Parameter("@pocSortOrder", orgPocContact.ConItemNumber),
			   new Parameter("@statusId", orgPocContact.StatusId),
			   new Parameter("@conCompanyId", orgPocContact.ConCompanyId),
		   };
			return parameters;
		}
	}
}