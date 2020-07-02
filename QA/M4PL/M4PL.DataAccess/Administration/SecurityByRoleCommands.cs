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
// Program Name:                                 SecurityByRoleCommands
// Purpose:                                      Contains commands to perform CRUD on SecurityByRole
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
	public class SecurityByRoleCommands : BaseCommands<SecurityByRole>
	{
		/// <summary>
		/// Gets list of SecurityByRole details
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<SecurityByRole> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSecurityByRoleView, EntitiesAlias.SecurityByRole);
		}

		/// <summary>
		/// Gets specific record detail related to SecurityByRole based on ActiveUser and Id
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static SecurityByRole Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetSecurityByRole);
		}

		/// <summary>
		/// Creates a new SecurityByRole in the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="securityByRole"></param>
		/// <returns></returns>

		public static SecurityByRole Post(ActiveUser activeUser, SecurityByRole securityByRole)
		{
			var parameters = GetParameters(securityByRole);
			parameters.AddRange(activeUser.PostDefaultParams(securityByRole));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertSecurityByRole);
		}

		/// <summary>
		/// Updates the Specific record in the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="securityByRole"></param>
		/// <returns></returns>
		public static SecurityByRole Put(ActiveUser activeUser, SecurityByRole securityByRole)
		{
			var parameters = GetParameters(securityByRole);
			parameters.AddRange(activeUser.PutDefaultParams(securityByRole.Id, securityByRole));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateSecurityByRole);
		}

		/// <summary>
		/// Deletes the specific record from the database.
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteSecurityByRole);
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
			return Delete(activeUser, ids, EntitiesAlias.SecurityByRole, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets the list of parameters required for the SecurityByRole Module
		/// </summary>
		/// <param name="securityByRole"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(SecurityByRole securityByRole)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@orgId", securityByRole.OrgId),
				new Parameter("@secLineOrder ", securityByRole.SecLineOrder),
				new Parameter("@mainModuleId", securityByRole.SecMainModuleId),
				new Parameter("@menuOptionLevelId", securityByRole.SecMenuOptionLevelId),
				new Parameter("@menuAccessLevelId", securityByRole.SecMenuAccessLevelId),
				new Parameter("@statusId", securityByRole.StatusId),
				new Parameter("@actRoleId", securityByRole.OrgRefRoleId),
			};
			return parameters;
		}
	}
}