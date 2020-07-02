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
// Program Name:                                 PrgEdiHeaderComments
// Purpose:                                      Contains commands to perform CRUD on PrgEdiHeader
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
	public class PrgEdiHeaderComments : BaseCommands<PrgEdiHeader>
	{
		/// <summary>
		/// Gets list of PrgEdiHeader records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<PrgEdiHeader> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgEdiHeaderView, EntitiesAlias.PrgEdiHeader);
		}

		/// <summary>
		/// Gets the specific PrgEdiHeader record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgEdiHeader Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetPrgEdiHeader);
		}

		/// <summary>
		/// Creates a new PrgEdiHeader record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgEdiHeader"></param>
		/// <returns></returns>

		public static PrgEdiHeader Post(ActiveUser activeUser, PrgEdiHeader prgEdiHeader)
		{
			var parameters = GetParameters(prgEdiHeader);
			parameters.AddRange(activeUser.PostDefaultParams(prgEdiHeader));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgEdiHeader);
		}

		/// <summary>
		/// Updates the existing PrgEdiHeader record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgEdiHeader"></param>
		/// <returns></returns>

		public static PrgEdiHeader Put(ActiveUser activeUser, PrgEdiHeader prgEdiHeader)
		{
			var parameters = GetParameters(prgEdiHeader);
			parameters.AddRange(activeUser.PutDefaultParams(prgEdiHeader.Id, prgEdiHeader));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgEdiHeader);
		}

		/// <summary>
		/// Deletes a specific PrgEdiHeader record
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
		/// Deletes list of PrgEdiHeader records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgEdiHeader, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the PrgEdiHeader Module
		/// </summary>
		/// <param name="prgEdiHeader"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(PrgEdiHeader prgEdiHeader)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@pehParentEDI", prgEdiHeader.PehParentEDI),
			   new Parameter("@pehProgramId", prgEdiHeader.PehProgramID),
			   new Parameter("@pehItemNumber", prgEdiHeader.PehItemNumber),
			   new Parameter("@pehEdiCode", prgEdiHeader.PehEdiCode),
			   new Parameter("@pehEdiTitle", prgEdiHeader.PehEdiTitle),
			   new Parameter("@pehTradingPartner", prgEdiHeader.PehTradingPartner),
			   new Parameter("@pehEdiDocument", prgEdiHeader.PehEdiDocument),
			   new Parameter("@pehEdiVersion", prgEdiHeader.PehEdiVersion),
			   new Parameter("@pehSCACCode", prgEdiHeader.PehSCACCode),
			   new Parameter("@pehAttachments", prgEdiHeader.PehAttachments),
			   new Parameter("@statusId", prgEdiHeader.StatusId),
			   new Parameter("@pehDateStart", prgEdiHeader.PehDateStart),
			   new Parameter("@pehDateEnd", prgEdiHeader.PehDateEnd),
			   new Parameter("@pehSndRcv", prgEdiHeader.PehSndRcv),
			   new Parameter("@pehInsertCode", prgEdiHeader.PehInsertCode),
			   new Parameter("@pehUpdateCode", prgEdiHeader.PehUpdateCode),
			   new Parameter("@pehCancelCode", prgEdiHeader.PehCancelCode),
			   new Parameter("@pehHoldCode", prgEdiHeader.PehHoldCode),
			   new Parameter("@pehOriginalCode", prgEdiHeader.PehOriginalCode),
			   new Parameter("@pehReturnCode", prgEdiHeader.PehReturnCode),
			   new Parameter("@uDF01", prgEdiHeader.UDF01),
			   new Parameter("@uDF02", prgEdiHeader.UDF02),
			   new Parameter("@uDF03", prgEdiHeader.UDF03),
			   new Parameter("@uDF04", prgEdiHeader.UDF04),
			   new Parameter("@uDF05", prgEdiHeader.UDF05),
			   new Parameter("@uDF06", prgEdiHeader.UDF06),
			   new Parameter("@uDF07", prgEdiHeader.UDF07),
			   new Parameter("@uDF08", prgEdiHeader.UDF08),
			   new Parameter("@uDF09", prgEdiHeader.UDF09),
			   new Parameter("@uDF10", prgEdiHeader.UDF10),
			   new Parameter("@PehInOutFolder", prgEdiHeader.PehInOutFolder),
			   new Parameter("@PehArchiveFolder", prgEdiHeader.PehArchiveFolder),
			   new Parameter("@PehProcessFolder", prgEdiHeader.PehProcessFolder),
			   new Parameter("@PehFtpServerUrl", prgEdiHeader.PehFtpServerUrl),
			   new Parameter("@PehFtpUsername", prgEdiHeader.PehFtpUsername),
			   new Parameter("@PehFtpPassword", prgEdiHeader.PehFtpPassword),
			   new Parameter("@PehFtpPort", prgEdiHeader.PehFtpPort),
			   new Parameter("@IsSFTPUsed", prgEdiHeader.IsSFTPUsed)
			};

			return parameters;
		}

		public static IList<TreeModel> GetEdiTree(long id, long? parentId, bool model)
		{
			var parameters = new[]
			{
				new Parameter("@orgId", id)
				,new Parameter("@parentId", parentId)
				,new Parameter("@isCustNode", model)
			};
			var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetProgramTreeViewData, parameters, storedProcedure: true);
			return result;
		}

		public static int GetProgramLevel(long id, long? programId)
		{
			var parameters = new[]
			{
				new Parameter("@orgId", id)
			   ,new Parameter("@programId", programId)
			};
			int result = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.GetProgramLevel, parameters, storedProcedure: true);
			return result;
		}
	}
}