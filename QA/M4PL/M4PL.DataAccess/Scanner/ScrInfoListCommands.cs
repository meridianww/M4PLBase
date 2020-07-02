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
// Program Name:                                 ScrInfoListCommands
// Purpose:                                      Contains commands to perform CRUD on ScrInfoList
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
	public class ScrInfoListCommands : BaseCommands<Entities.Scanner.ScrInfoList>
	{
		/// <summary>
		/// Gets list of ScrInfoLists
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Scanner.ScrInfoList> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScrInfoListView, EntitiesAlias.ScrInfoList);
		}

		/// <summary>
		/// Gets the specific ScrInfoList
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScrInfoList Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetScrInfoList);
		}

		/// <summary>
		/// Creates a new ScrInfoList
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scrInfoList"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScrInfoList Post(ActiveUser activeUser, Entities.Scanner.ScrInfoList scrInfoList)
		{
			var parameters = GetParameters(scrInfoList);
			parameters.AddRange(activeUser.PostDefaultParams(scrInfoList));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertScrInfoList);
		}

		/// <summary>
		/// Updates the existing ScrInfoList record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scrInfoList"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScrInfoList Put(ActiveUser activeUser, Entities.Scanner.ScrInfoList scrInfoList)
		{
			var parameters = GetParameters(scrInfoList);
			parameters.AddRange(activeUser.PutDefaultParams(scrInfoList.Id, scrInfoList));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateScrInfoList);
		}

		/// <summary>
		/// Deletes a specific ScrInfoList
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteScrInfoList);
			return 0;
		}

		/// <summary>
		/// Deletes list of ScrInfoLists
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.ScrInfoList, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the ScrInfoLists Module
		/// </summary>
		/// <param name="scrInfoList"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Scanner.ScrInfoList scrInfoList)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@infoListID", scrInfoList.InfoListID),
			   new Parameter("@infoListDesc", scrInfoList.InfoListDesc),
			   new Parameter("@infoListPhoto", scrInfoList.InfoListPhoto),
			   new Parameter("@catalogTitle", scrInfoList.CatalogTitle),
		   };
			return parameters;
		}
	}
}