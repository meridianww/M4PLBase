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
// Program Name:                                 ScnOrderServiceCommands
// Purpose:                                      Contains commands to perform CRUD on ScnOrderService
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
	public class ScnOrderServiceCommands : BaseCommands<Entities.Scanner.ScnOrderService>
	{
		/// <summary>
		/// Gets list of ScnOrderServices
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Scanner.ScnOrderService> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnOrderServiceView, EntitiesAlias.ScnOrderService);
		}

		/// <summary>
		/// Gets the specific ScnOrderService
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrderService Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetScnOrderService);
		}

		/// <summary>
		/// Creates a new ScnOrderService
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnOrderService"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrderService Post(ActiveUser activeUser, Entities.Scanner.ScnOrderService scnOrderService)
		{
			var parameters = GetParameters(scnOrderService);
			parameters.AddRange(activeUser.PostDefaultParams(scnOrderService));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertScnOrderService);
		}

		/// <summary>
		/// Updates the existing ScnOrderService record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnOrderService"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrderService Put(ActiveUser activeUser, Entities.Scanner.ScnOrderService scnOrderService)
		{
			var parameters = GetParameters(scnOrderService);
			parameters.AddRange(activeUser.PutDefaultParams(scnOrderService.Id, scnOrderService));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnOrderService);
		}

		/// <summary>
		/// Deletes a specific ScnOrderService
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteScnOrderService);
			return 0;
		}

		/// <summary>
		/// Deletes list of ScnOrderServices
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.ScnOrderService, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the ScnOrderServices Module
		/// </summary>
		/// <param name="scnOrderService"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Scanner.ScnOrderService scnOrderService)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@servicesID", scnOrderService.ServicesID),
			   new Parameter("@servicesCode", scnOrderService.ServicesCode),
			   new Parameter("@jobID", scnOrderService.JobID),
			   new Parameter("@notes", scnOrderService.Notes),
			   new Parameter("@complete", scnOrderService.Complete),
		   };
			return parameters;
		}
	}
}