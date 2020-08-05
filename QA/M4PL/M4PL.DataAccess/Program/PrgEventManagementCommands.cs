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
// Program Name:                                 ProgramCommands
// Purpose:                                      Contains commands to perform CRUD on Program
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Program
{
	public class PrgEventManagementCommands : BaseCommands<PrgEventManagement>
	{
		/// <summary>
		/// Gets list of Program records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<PrgEventManagement> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return new List<PrgEventManagement>() { new PrgEventManagement() { Id = 1, EventName = "POD Upload", StatusId = 1, EventTypeId = 4, EventShortName ="PU", FromMail = "prashant.aggarwal@dreamorbit.com", Description = "This is test email.", ToEmail = "kirty.anurag@dreamorbit.com", CcEMail = "Manoj.kumar@dreamorbit.com" } };
			////return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetProgramEventManagementView, EntitiesAlias.Program);
		}

		/// <summary>
		/// Gets the specific Program record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgEventManagement Get(ActiveUser activeUser, long id)
		{
			return new PrgEventManagement() { Id = 1, IsBodyHtml = true, EventName = "POD Upload", EventTypeId = 4, StatusId= 1, EventShortName = "PU", FromMail = "prashant.aggarwal@dreamorbit.com", Description = "This is test email.", ToEmail = "kirty.anurag@dreamorbit.com", CcEMail = "Manoj.kumar@dreamorbit.com" };
			////return Get(activeUser, id, StoredProceduresConstant.GetProgramEventManagement);
		}

		/// <summary>
		/// Creates a new Program record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgEventManagement"></param>
		/// <returns></returns>

		public static PrgEventManagement Post(ActiveUser activeUser, PrgEventManagement prgEventManagement)
		{
			var parameters = GetParameters(prgEventManagement);
			// parameters.Add(new Parameter("@langCode", program.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(prgEventManagement));
			return Post(activeUser, parameters, StoredProceduresConstant.InsProgramEventManagement);
		}

		/// <summary>
		/// Updates the existing Program recordrecords
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgEventManagement"></param>
		/// <returns></returns>

		public static PrgEventManagement Put(ActiveUser activeUser, PrgEventManagement prgEventManagement)
		{
			var parameters = GetParameters(prgEventManagement);
			// parameters.Add(new Parameter("@langCode", program.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(prgEventManagement.Id, prgEventManagement));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdProgramEventManagement);
		}

		/// <summary>
		/// Deletes a specific Program record
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
		/// Deletes list of Program records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgEventManagement, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the Program Module
		/// </summary>
		/// <param name="PrgEventManagement"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Program.PrgEventManagement PrgEventManagement)
		{
			var parameters = new List<Parameter>
			{
			};
			return parameters;
		}
	}
}