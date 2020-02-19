/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgRefGatewayDefaultCommands
Purpose:                                      Contains commands to perform CRUD on PrgRefGatewayDefault
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;

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
            parameters.AddRange(activeUser.PutDefaultParams(prgRefGatewayDefault.Id, prgRefGatewayDefault));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdatePrgRefGatewayDefault);
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
    }
}