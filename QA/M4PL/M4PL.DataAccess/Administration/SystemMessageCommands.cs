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
// Program Name:                                 SystemMessageCommands
// Purpose:                                      Contains commands to perform CRUD on SystemMessage
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
	public class SystemMessageCommands : BaseCommands<SystemMessage>
	{
		/// <summary>
		/// Gets list of  system message records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<SystemMessage> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSystemMessageView, EntitiesAlias.SystemMessage, langCode: true);
		}

		/// <summary>
		/// Gets a specific system message record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static SystemMessage Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetSystemMessage, langCode: true);
		}

		/// <summary>
		/// Creates a new system message record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="systemMessage"></param>
		/// <returns></returns>

		public static SystemMessage Post(ActiveUser activeUser, SystemMessage systemMessage)
		{
			var parameters = GetParameters(systemMessage);
			parameters.AddRange(activeUser.PostDefaultParams(systemMessage));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertSystemMessage);
		}

		/// <summary>
		/// Uodates the existing system message record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="systemMessage"></param>
		/// <returns></returns>

		public static SystemMessage Put(ActiveUser activeUser, SystemMessage systemMessage)
		{
			var parameters = GetParameters(systemMessage);
			parameters.AddRange(activeUser.PutDefaultParams(systemMessage.Id, systemMessage));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateSystemMessage);
		}

		/// <summary>
		/// Deletes the specific system message record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
			return 0;
		}

		/// <summary>
		/// Deletes list of system message record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.SystemMessage, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets the system message record details based on the SystemMessageCode
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="sysMsgCode"></param>
		/// <returns></returns>
		public static SystemMessage GetBySysMessageCode(ActiveUser activeUser, string sysMsgCode)
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Deletes the record based on the SystemMessageCode
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="sysMsgCode"></param>
		/// <returns></returns>

		public static SystemMessage DeleteBySysMessageCode(ActiveUser activeUser, string sysMsgCode)
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Gets the list of paramters required for the System Message Module
		/// </summary>
		/// <param name="systemMessage"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(SystemMessage systemMessage)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@langCode", systemMessage.LangCode),
			   new Parameter("@sysMessageCode", systemMessage.SysMessageCode),
			   new Parameter("@sysRefId", systemMessage.SysRefId),
			   new Parameter("@sysMessageScreenTitle", systemMessage.SysMessageScreenTitle),
			   new Parameter("@sysMessageTitle", systemMessage.SysMessageTitle),
			   new Parameter("@sysMessageDescription", systemMessage.SysMessageDescription),
			   new Parameter("@sysMessageInstruction", systemMessage.SysMessageInstruction),
			   new Parameter("@sysMessageButtonSelection", systemMessage.SysMessageButtonSelection),
			   new Parameter("@statusId", systemMessage.StatusId),
		   };
			return parameters;
		}
	}
}