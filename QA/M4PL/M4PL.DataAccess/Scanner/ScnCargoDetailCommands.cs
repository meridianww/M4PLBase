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
// Program Name:                                 ScnCargoDetailCommands
// Purpose:                                      Contains commands to perform CRUD on ScnCargoDetail
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
	public class ScnCargoDetailCommands : BaseCommands<Entities.Scanner.ScnCargoDetail>
	{
		/// <summary>
		/// Gets list of ScnCargoDetails
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Scanner.ScnCargoDetail> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnCargoDetailView, EntitiesAlias.ScnCargoDetail);
		}

		/// <summary>
		/// Gets the specific ScnCargoDetail
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargoDetail Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetScnCargoDetail);
		}

		/// <summary>
		/// Creates a new ScnCargoDetail
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnCargoDetail"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargoDetail Post(ActiveUser activeUser, Entities.Scanner.ScnCargoDetail scnCargoDetail)
		{
			var parameters = GetParameters(scnCargoDetail);
			parameters.AddRange(activeUser.PostDefaultParams(scnCargoDetail));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertScnCargoDetail);
		}

		/// <summary>
		/// Updates the existing ScnCargoDetail record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnCargoDetail"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargoDetail Put(ActiveUser activeUser, Entities.Scanner.ScnCargoDetail scnCargoDetail)
		{
			var parameters = GetParameters(scnCargoDetail);
			parameters.AddRange(activeUser.PutDefaultParams(scnCargoDetail.Id, scnCargoDetail));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnCargoDetail);
		}

		/// <summary>
		/// Deletes a specific ScnCargoDetail
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteScnCargoDetail);
			return 0;
		}

		/// <summary>
		/// Deletes list of ScnCargoDetails
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.ScnCargoDetail, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the ScnCargoDetails Module
		/// </summary>
		/// <param name="scnCargoDetail"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Scanner.ScnCargoDetail scnCargoDetail)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@cargoDetailID", scnCargoDetail.CargoDetailID),
			   new Parameter("@cargoID", scnCargoDetail.CargoID),
			   new Parameter("@detSerialNumber", scnCargoDetail.DetSerialNumber),
			   new Parameter("@detQtyCounted", scnCargoDetail.DetQtyCounted),
			   new Parameter("@detQtyDamaged", scnCargoDetail.DetQtyDamaged),
			   new Parameter("@detQtyShort", scnCargoDetail.DetQtyShort),
			   new Parameter("@detQtyOver", scnCargoDetail.DetQtyOver),
			   new Parameter("@detPickStatus", scnCargoDetail.DetPickStatus),
			   new Parameter("@detLong", scnCargoDetail.DetLong),
			   new Parameter("@detLat", scnCargoDetail.DetLat),
		   };
			return parameters;
		}
	}
}