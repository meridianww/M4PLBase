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
// Program Name:                                 PrgRefAttributeDefaultCommands
// Purpose:                                      Contains commands to perform CRUD on PrgRefAttributeDefault
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
	public class PrgRefAttributeDefaultCommands : BaseCommands<PrgRefAttributeDefault>
	{
		/// <summary>
		/// Gets list of PrgRefAttributeDefault records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<PrgRefAttributeDefault> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgRefAttributeDefaultView, EntitiesAlias.PrgRefAttributeDefault);
		}

		/// <summary>
		/// Gets the specific PrgRefAttributeDefault record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgRefAttributeDefault Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetPrgRefAttributeDefault);
		}

		/// <summary>
		/// Creates a new PrgRefAttributeDefault record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgRefAttributeDefault"></param>
		/// <returns></returns>

		public static PrgRefAttributeDefault Post(ActiveUser activeUser, PrgRefAttributeDefault prgRefAttributeDefault)
		{
			var parameters = GetParameters(prgRefAttributeDefault);
			parameters.AddRange(activeUser.PostDefaultParams(prgRefAttributeDefault));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgRefAttributeDefault);
		}

		/// <summary>
		/// Updates the existing PrgRefAttributeDefault recordrecords
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgRefAttributeDefault"></param>
		/// <returns></returns>

		public static PrgRefAttributeDefault Put(ActiveUser activeUser, PrgRefAttributeDefault prgRefAttributeDefault)
		{
			var parameters = GetParameters(prgRefAttributeDefault);
			// parameters.Add(new Parameter("@langCode", prgRefAttributeDefault.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(prgRefAttributeDefault.Id, prgRefAttributeDefault));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgRefAttributeDefault);
		}

		/// <summary>
		/// Deletes a specific PrgRefAttributeDefault record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
			return 0;
		}

		/// <summary>
		/// Deletes list of PrgRefAttributeDefault records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgRefAttributeDefault, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the PrgRefAttributeDefault Module
		/// </summary>
		/// <param name="prgRefAttributeDefault"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(PrgRefAttributeDefault prgRefAttributeDefault)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@programId", prgRefAttributeDefault.ProgramID),
			   new Parameter("@attItemNumber", prgRefAttributeDefault.AttItemNumber),
			   new Parameter("@attCode", prgRefAttributeDefault.AttCode),
			   new Parameter("@attTitle", prgRefAttributeDefault.AttTitle),
			   new Parameter("@attQuantity", prgRefAttributeDefault.AttQuantity),
			   new Parameter("@unitTypeId", prgRefAttributeDefault.UnitTypeId),
			   new Parameter("@attDefault", prgRefAttributeDefault.AttDefault),
				new Parameter("@statusId", prgRefAttributeDefault.StatusId),
			};
			return parameters;
		}
	}
}