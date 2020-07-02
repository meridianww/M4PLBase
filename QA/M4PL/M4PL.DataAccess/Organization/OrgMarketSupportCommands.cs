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
// Program Name:                                 OrgMarketSupportCommands
// Purpose:                                      Contains commands to perform CRUD on OrgMarketSupport
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
	public class OrgMarketSupportCommands : BaseCommands<OrgMarketSupport>
	{
		/// <summary>
		/// Gets list of Organization Market Support records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<OrgMarketSupport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetOrgMarketSupportView, EntitiesAlias.OrgMarketSupport);
		}

		/// <summary>
		/// Gets the specific Organization Market Support record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static OrgMarketSupport Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetOrgMarketSupport);
		}

		/// <summary>
		/// Creates a new Organization Market Support record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgMarketSupport"></param>
		/// <returns></returns>

		public static OrgMarketSupport Post(ActiveUser activeUser, OrgMarketSupport orgMarketSupport)
		{
			var parameters = GetParameters(orgMarketSupport);
			// parameters.Add(new Parameter("@langCode", orgMarketSupport.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(orgMarketSupport));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertOrgMarketSupport);
		}

		/// <summary>
		/// Updates the existing Organization Market Support record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgMarketSupport"></param>
		/// <returns></returns>

		public static OrgMarketSupport Put(ActiveUser activeUser, OrgMarketSupport orgMarketSupport)
		{
			var parameters = GetParameters(orgMarketSupport);
			// parameters.Add(new Parameter("@langCode", orgMarketSupport.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(orgMarketSupport.Id, orgMarketSupport));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateOrgMarketSupport);
		}

		/// <summary>
		/// Deletes a specific Organization Market Support record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationMarketSupport);
			return 0;
		}

		/// <summary>
		/// Deletes list of Organization Market Support records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids)
		{
			//return Delete(activeUser, ids, StoredProceduresConstant.DeleteOrganizationMarketSupport);
			return null;
		}

		/// <summary>
		/// Gets list of parameters required for the Organization Market Support Module
		/// </summary>
		/// <param name="orgMarketSupport"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(OrgMarketSupport orgMarketSupport)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@orgId", orgMarketSupport.OrganizationId),
			   new Parameter("@mrkOrder", orgMarketSupport.MrkOrder),
			   new Parameter("@mrkCode", orgMarketSupport.MrkCode),
			   new Parameter("@mrkTitle", orgMarketSupport.MrkTitle),
		   };
			return parameters;
		}
	}
}