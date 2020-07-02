#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Organization
{
	public class OrgReportCommands : BaseCommands<OrgReport>
	{
		/// <summary>
		/// Gets list of Organization records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<OrgReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.OrgReport);
		}

		/// <summary>
		/// Gets the specific Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static OrgReport Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
		}

		/// <summary>
		/// Creates a new Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgReport"></param>
		/// <returns></returns>

		public static OrgReport Post(ActiveUser activeUser, OrgReport orgReport)
		{
			var parameters = GetParameters(orgReport);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(orgReport));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
		}

		/// <summary>
		/// Updates the existing Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="orgReport"></param>
		/// <returns></returns>

		public static OrgReport Put(ActiveUser activeUser, OrgReport orgReport)
		{
			var parameters = GetParameters(orgReport);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(orgReport.Id, orgReport));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
		}

		/// <summary>
		/// Deletes a specific Organization record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganization);
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
		/// Gets list of parameters required for the Organization Module
		/// </summary>
		/// <param name="OrgReport"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(OrgReport OrgReport)
		{
			var parameters = new List<Parameter>
			{
			};
			return parameters;
		}
	}
}