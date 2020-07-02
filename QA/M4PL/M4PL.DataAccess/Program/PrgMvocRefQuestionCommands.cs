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
// Program Name:                                 PrgMvocRefQuestion
// Purpose:                                      Contains commands to perform CRUD on PrgMvocRefQuestion
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
	public class PrgMvocRefQuestionCommands : BaseCommands<PrgMvocRefQuestion>
	{
		/// <summary>
		/// Gets list of PrgMvocRefQuestion records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<PrgMvocRefQuestion> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgMvocRefQuestionView, EntitiesAlias.PrgMvocRefQuestion);
		}

		/// <summary>
		/// Gets the specific PrgMvocRefQuestion record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgMvocRefQuestion Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetPrgMvocRefQuestion);
		}

		/// <summary>
		/// Creates a new PrgMvocRefQuestion record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgMvocRefQuestion"></param>
		/// <returns></returns>

		public static PrgMvocRefQuestion Post(ActiveUser activeUser, PrgMvocRefQuestion prgMvocRefQuestion)
		{
			var parameters = GetParameters(prgMvocRefQuestion);
			// parameters.Add(new Parameter("@langCode", prgMvocRefQuestion.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(prgMvocRefQuestion));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgMvocRefQuestion);
		}

		/// <summary>
		/// Updates the existing PrgMvocRefQuestion recordrecords
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgMvocRefQuestion"></param>
		/// <returns></returns>

		public static PrgMvocRefQuestion Put(ActiveUser activeUser, PrgMvocRefQuestion prgMvocRefQuestion)
		{
			var parameters = GetParameters(prgMvocRefQuestion);
			// parameters.Add(new Parameter("@langCode", prgMvocRefQuestion.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(prgMvocRefQuestion.Id, prgMvocRefQuestion));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgMvocRefQuestion);
		}

		/// <summary>
		/// Deletes a specific PrgMvocRefQuestion record
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
		/// Deletes list of PrgMvocRefQuestion records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgMvocRefQuestion, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the PrgMvocRefQuestion Module
		/// </summary>
		/// <param name="prgMvocRefQuestion"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(PrgMvocRefQuestion prgMvocRefQuestion)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@mVOCID", prgMvocRefQuestion.MVOCID),
			   new Parameter("@queQuestionNumber", prgMvocRefQuestion.QueQuestionNumber),
			   new Parameter("@queCode", prgMvocRefQuestion.QueCode),
			   new Parameter("@queTitle", prgMvocRefQuestion.QueTitle),
			   new Parameter("@quesTypeId", prgMvocRefQuestion.QuesTypeId),
			   new Parameter("@queType_YNAnswer", prgMvocRefQuestion.QueType_YNAnswer),
			   new Parameter("@queType_YNDefault", prgMvocRefQuestion.QueType_YNDefault),
			   new Parameter("@queType_RangeLo", prgMvocRefQuestion.QueType_RangeLo),
			   new Parameter("@queType_RangeHi", prgMvocRefQuestion.QueType_RangeHi),
			   new Parameter("@queType_RangeAnswer", prgMvocRefQuestion.QueType_RangeAnswer),
			   new Parameter("@queType_RangeDefault", prgMvocRefQuestion.QueType_RangeDefault),
			   new Parameter("@statusId", prgMvocRefQuestion.StatusId),
			   new Parameter("@queDescriptionText", prgMvocRefQuestion.QueDescriptionText),
			};
			return parameters;
		}
	}
}