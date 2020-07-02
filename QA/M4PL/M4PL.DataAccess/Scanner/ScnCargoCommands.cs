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
// Program Name:                                 ScnCargoCommands
// Purpose:                                      Contains commands to perform CRUD on ScnCargo
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
	public class ScnCargoCommands : BaseCommands<Entities.Scanner.ScnCargo>
	{
		/// <summary>
		/// Gets list of ScnCargos
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Scanner.ScnCargo> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnCargoView, EntitiesAlias.ScnCargo);
		}

		/// <summary>
		/// Gets the specific ScnCargo
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargo Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetScnCargo);
		}

		/// <summary>
		/// Creates a new ScnCargo
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnCargo"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargo Post(ActiveUser activeUser, Entities.Scanner.ScnCargo scnCargo)
		{
			var parameters = GetParameters(scnCargo);
			parameters.AddRange(activeUser.PostDefaultParams(scnCargo));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertScnCargo);
		}

		/// <summary>
		/// Updates the existing ScnCargo record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnCargo"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnCargo Put(ActiveUser activeUser, Entities.Scanner.ScnCargo scnCargo)
		{
			var parameters = GetParameters(scnCargo);
			parameters.AddRange(activeUser.PutDefaultParams(scnCargo.Id, scnCargo));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnCargo);
		}

		/// <summary>
		/// Deletes a specific ScnCargo
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteScnCargo);
			return 0;
		}

		/// <summary>
		/// Deletes list of ScnCargos
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.ScnCargo, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the ScnCargos Module
		/// </summary>
		/// <param name="scnCargo"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Scanner.ScnCargo scnCargo)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@cargoID", scnCargo.CargoID),
			   new Parameter("@jobID", scnCargo.JobID),
			   new Parameter("@cgoLineItem", scnCargo.CgoLineItem),
			   new Parameter("@cgoPartNumCode", scnCargo.CgoPartNumCode),
			   new Parameter("@cgoQtyOrdered", scnCargo.CgoQtyOrdered),
			   new Parameter("@cgoQtyExpected", scnCargo.CgoQtyExpected),
			   new Parameter("@cgoQtyCounted", scnCargo.CgoQtyCounted),
			   new Parameter("@cgoQtyDamaged", scnCargo.CgoQtyDamaged),
			   new Parameter("@cgoQtyOnHold", scnCargo.CgoQtyOnHold),
			   new Parameter("@cgoQtyShort", scnCargo.CgoQtyShort),
			   new Parameter("@cgoQtyOver", scnCargo.CgoQtyOver),
			   new Parameter("@cgoQtyUnits", scnCargo.CgoQtyUnits),
			   new Parameter("@cgoStatus", scnCargo.CgoStatus),
			   new Parameter("@cgoInfoID", scnCargo.CgoInfoID),
			   new Parameter("@colorCD", scnCargo.ColorCD),
			   new Parameter("@cgoSerialCD", scnCargo.CgoSerialCD),
			   new Parameter("@cgoLong", scnCargo.CgoLong),
			   new Parameter("@cgoLat", scnCargo.CgoLat),
			   new Parameter("@cgoProFlag01", scnCargo.CgoProFlag01),
			   new Parameter("@cgoProFlag02", scnCargo.CgoProFlag02),
			   new Parameter("@cgoProFlag03", scnCargo.CgoProFlag03),
			   new Parameter("@cgoProFlag04", scnCargo.CgoProFlag04),
			   new Parameter("@cgoProFlag05", scnCargo.CgoProFlag05),
			   new Parameter("@cgoProFlag06", scnCargo.CgoProFlag06),
			   new Parameter("@cgoProFlag07", scnCargo.CgoProFlag07),
			   new Parameter("@cgoProFlag08", scnCargo.CgoProFlag08),
			   new Parameter("@cgoProFlag09", scnCargo.CgoProFlag09),
			   new Parameter("@cgoProFlag10", scnCargo.CgoProFlag10),
			   new Parameter("@cgoProFlag11", scnCargo.CgoProFlag11),
			   new Parameter("@cgoProFlag12", scnCargo.CgoProFlag12),
			   new Parameter("@cgoProFlag13", scnCargo.CgoProFlag13),
			   new Parameter("@cgoProFlag14", scnCargo.CgoProFlag14),
			   new Parameter("@cgoProFlag15", scnCargo.CgoProFlag15),
			   new Parameter("@cgoProFlag16", scnCargo.CgoProFlag16),
			   new Parameter("@cgoProFlag17", scnCargo.CgoProFlag17),
			   new Parameter("@cgoProFlag18", scnCargo.CgoProFlag18),
			   new Parameter("@cgoProFlag19", scnCargo.CgoProFlag19),
			   new Parameter("@cgoProFlag20", scnCargo.CgoProFlag20),
		   };
			return parameters;
		}
	}
}