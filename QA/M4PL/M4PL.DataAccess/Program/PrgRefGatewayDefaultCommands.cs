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
// Program Name:                                 PrgRefGatewayDefaultCommands
// Purpose:                                      Contains commands to perform CRUD on PrgRefGatewayDefault
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Program
{
	public class PrgRefGatewayDefaultCommands : BaseCommands<PrgRefGatewayDefault>
	{
		/// <summary>
		/// Gets list of PrgRefGatewayDefault records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<PrgRefGatewayDefault> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetPrgRefGatewayDefaultView, EntitiesAlias.PrgRefGatewayDefault);
		}

		/// <summary>
		/// Gets the specific PrgRefGatewayDefault record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static PrgRefGatewayDefault Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetPrgRefGatewayDefault);
		}

		/// <summary>
		/// Creates a new PrgRefGatewayDefault record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>

		public static PrgRefGatewayDefault Post(ActiveUser activeUser, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			var parameters = GetParameters(prgRefGatewayDefault);
			parameters.AddRange(activeUser.PostDefaultParams(prgRefGatewayDefault));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgRefGatewayDefault);
		}

		public static PrgRefGatewayDefault PostWithSettings(ActiveUser activeUser, SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			var parameters = GetParameters(prgRefGatewayDefault, userSysSetting);
			parameters.AddRange(activeUser.PostDefaultParams(prgRefGatewayDefault));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertPrgRefGatewayDefault);
		}

		/// <summary>
		/// Updates the existing PrgRefGatewayDefault recordrecords
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>

		public static PrgRefGatewayDefault Put(ActiveUser activeUser, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			var parameters = GetParameters(prgRefGatewayDefault);
			parameters.AddRange(activeUser.PutDefaultParams(prgRefGatewayDefault.Id, prgRefGatewayDefault));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgRefGatewayDefault);
		}

		public static PrgRefGatewayDefault PutWithSettings(ActiveUser activeUser, SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			var parameters = GetParameters(prgRefGatewayDefault, userSysSetting);
			parameters.Add(new Parameter("@InstallStatusId", prgRefGatewayDefault.InstallStatusId));
			parameters.AddRange(activeUser.PutDefaultParams(prgRefGatewayDefault.Id, prgRefGatewayDefault));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgRefGatewayDefault);
		}

		public static PrgRefGatewayDefault GetProgramGateway(string orderType, string shipmentType, long programId, string statusCode, bool isScheduled)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@orderType", orderType),
               new Parameter("@shipmentType", shipmentType),
               new Parameter("@programId", programId),
               new Parameter("@StatusCode", statusCode),
               new Parameter("@IsScheduled", isScheduled)
			};

			return SqlSerializer.Default.DeserializeSingleRecord<PrgRefGatewayDefault>(StoredProceduresConstant.GetProgramGatewayByStatusCode, parameters.ToArray(), storedProcedure: true);
		}

		/// <summary>
		/// Deletes a specific PrgRefGatewayDefault record
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
		/// Deletes list of PrgRefGatewayDefault records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.PrgRefGatewayDefault, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the PrgRefGatewayDefault Module
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(PrgRefGatewayDefault prgRefGatewayDefault, SysSetting userSysSetting = null)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@pgdProgramId", prgRefGatewayDefault.PgdProgramID),
			   new Parameter("@pgdGatewaySortOrder", prgRefGatewayDefault.PgdGatewaySortOrder),
			   new Parameter("@pgdGatewayCode", prgRefGatewayDefault.PgdGatewayCode),
			   new Parameter("@pgdGatewayTitle", prgRefGatewayDefault.PgdGatewayTitle),
			   new Parameter("@pgdGatewayDuration", prgRefGatewayDefault.PgdGatewayDuration),
			   new Parameter("@unitTypeId", prgRefGatewayDefault.UnitTypeId),
			   new Parameter("@pgdGatewayDefault", prgRefGatewayDefault.PgdGatewayDefault),
			   new Parameter("@gatewayTypeId", prgRefGatewayDefault.GatewayTypeId),
			   new Parameter("@gatewayDateRefTypeId", prgRefGatewayDefault.GatewayDateRefTypeId),
			   new Parameter("@scanner", prgRefGatewayDefault.Scanner),
			   new Parameter("@pgdShipApptmtReasonCode", prgRefGatewayDefault.PgdShipApptmtReasonCode),
			   new Parameter("@pgdShipStatusReasonCode", prgRefGatewayDefault.PgdShipStatusReasonCode),
			   new Parameter("@pgdOrderType", prgRefGatewayDefault.PgdOrderType),
			   new Parameter("@pgdShipmentType", prgRefGatewayDefault.PgdShipmentType),
			   new Parameter("@statusId", prgRefGatewayDefault.StatusId),
			   new Parameter("@pgdGatewayResponsible", prgRefGatewayDefault.PgdGatewayResponsible),
			   new Parameter("@pgdGatewayDefaultComplete", prgRefGatewayDefault.PgdGatewayDefaultComplete),
			   new Parameter("@pgdGatewayAnalyst", prgRefGatewayDefault.PgdGatewayAnalyst),
			   new Parameter("@PgdGatewayStatusCode", prgRefGatewayDefault.PgdGatewayStatusCode),
			   new Parameter("@MappingId", prgRefGatewayDefault.MappingId),
			   new Parameter("@TransitionStatusId", prgRefGatewayDefault.TransitionStatusId),
			   new Parameter("@PgdGatewayDefaultForJob", prgRefGatewayDefault.PgdGatewayDefaultForJob),
			   new Parameter("@PgdGatewayNavOrderOption", prgRefGatewayDefault.PgdGatewayNavOrderOption)
              // new Parameter("@where",string.Format(" AND {0}.{1} ={2} AND {0}.{3}='{4}' AND {0}.{5}='{6}' ",prgRefGatewayDefault.GetType().Name ,PrgRefGatewayDefaultWhereColms.GatewayTypeId,prgRefGatewayDefault.GatewayTypeId.ToString(),PrgRefGatewayDefaultWhereColms.PgdOrderType,prgRefGatewayDefault.PgdOrderType, PrgRefGatewayDefaultWhereColms.PgdShipmentType,prgRefGatewayDefault.PgdShipmentType))
            };
			if (userSysSetting != null && userSysSetting.Settings != null)
			{
				var whereCondition = string.Empty;
				var itemNumberConditions = userSysSetting.Settings.Where(s => s.Entity == EntitiesAlias.PrgRefGatewayDefault && s.Name.Equals("ItemNumber"));
				foreach (var setting in itemNumberConditions)
				{
					if (setting != null && !string.IsNullOrEmpty(setting.Value))
					{
						var columnList = setting.Value.SplitComma();
						var properties = prgRefGatewayDefault.GetType().GetProperties();
						foreach (var columnName in columnList)
						{
							var propInfo = properties.FirstOrDefault(p => columnName.Contains(p.Name));
							if (propInfo != null)
							{
								if (!setting.ValueType.Equals("string", System.StringComparison.OrdinalIgnoreCase))
									whereCondition = whereCondition + " " + columnName + " " + propInfo.GetValue(prgRefGatewayDefault, null);
								else
									whereCondition = whereCondition + " " + columnName + " '" + propInfo.GetValue(prgRefGatewayDefault, null) + "'";
							}
						}
					}
				}
				parameters.Add(new Parameter("@where", whereCondition));
			}
			return parameters;
		}

		public static bool IsDefaultCompletedExist(string whereCondition, long programId)
		{
			bool isDefaultCompletedExist = false;
			var parameters = new List<Parameter>
			{
			   new Parameter("@WhereCondition", whereCondition),
			   new Parameter("@programId", programId)
			};

			try
			{
				isDefaultCompletedExist = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.IsDefaultCheckforProgramGatewayCombination, parameters.ToArray(), false, true);
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error occuring in method IsDefaultCheckforProgramGatewayCombination", "IsDefaultCheckforProgramGatewayCombination", Utilities.Logger.LogType.Error);
			}

			return isDefaultCompletedExist;
		}
	}
}