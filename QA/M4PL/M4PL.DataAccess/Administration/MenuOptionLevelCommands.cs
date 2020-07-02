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
// Program Name:                                 MenuOptionLevelCommands
// Purpose:                                      Contains commands to perform CRUD on MenuOptionLevel
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
	public class MenuOptionLevelCommands : BaseCommands<MenuOptionLevel>
	{
		/// <summary>
		/// Gets the list of Menu optionlevel records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<MenuOptionLevel> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetMenuOptionLevelView, EntitiesAlias.MenuOptionLevel, langCode: true);
		}

		/// <summary>
		/// Gets the specific record details of Menuoption level
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static MenuOptionLevel Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetMenuOptionLevel, langCode: true);
		}

		/// <summary>
		/// Creates a new records for Menu option level in the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="menuOptionLevel"></param>
		/// <returns></returns>

		public static MenuOptionLevel Post(ActiveUser activeUser, MenuOptionLevel menuOptionLevel)
		{
			var parameters = GetParameters(menuOptionLevel);
			parameters.Add(new Parameter("@langCode", menuOptionLevel.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(menuOptionLevel));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertMenuOptionLevel);
		}

		/// <summary>
		/// Updates the specific record in the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="menuOptionLevel"></param>
		/// <returns></returns>
		public static MenuOptionLevel Put(ActiveUser activeUser, MenuOptionLevel menuOptionLevel)
		{
			var parameters = GetParameters(menuOptionLevel);
			parameters.Add(new Parameter("@langCode", menuOptionLevel.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(menuOptionLevel.Id, menuOptionLevel));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateMenuOptionLevel);
		}

		/// <summary>
		/// Deletes specific record from the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuOptionLevel);
			return 0;
		}

		/// <summary>
		/// Deletes list of records from the database
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>
		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids)
		{
			//return Delete(activeUser, ids, StoredProceduresConstant.DeleteMenuOptionLevel);
			return null;
		}

		/// <summary>
		/// Gets the list of parameters required for the Menuoption level Module
		/// </summary>
		/// <param name="menuOptionLevel"></param>
		/// <returns></returns>
		private static List<Parameter> GetParameters(MenuOptionLevel menuOptionLevel)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@sysRefId", menuOptionLevel.SysRefId),
				new Parameter("@molOrder", menuOptionLevel.MolOrder),
				new Parameter("@molMenuLevelTitle", menuOptionLevel.MolMenuLevelTitle),
				new Parameter("@molMenuAccessDefault", menuOptionLevel.MolMenuAccessDefault),
				new Parameter("@molMenuAccessOnly", menuOptionLevel.MolMenuAccessOnly),
			};
			return parameters;
		}
	}
}