/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 BaseCommands
Purpose:
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess
{
    public abstract class BaseCommands<TEntity> where TEntity : class, new()
    {
        public static IList<TEntity> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo, string storedProcName, EntitiesAlias entitiesAlias, bool langCode = false)
        {
            var parameters = pagedDataInfo.PagedDataDefaultParams(activeUser, entitiesAlias, langCode).ToArray();

            var results = SqlSerializer.Default.DeserializeMultiRecords<TEntity>(storedProcName, parameters, storedProcedure: true);
            if (!(parameters[parameters.Length - 1].Value is DBNull))
                pagedDataInfo.TotalCount = Convert.ToInt32(parameters[parameters.Length - 1].Value);
            else pagedDataInfo.TotalCount = 0;
            return results;
        }

        public static TEntity Get(ActiveUser activeUser, long id, string storedProcName, bool langCode = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(id, langCode);
            var result = SqlSerializer.Default.DeserializeSingleRecord<TEntity>(storedProcName, parameters.ToArray(), storedProcedure: true);
            return result ?? new TEntity();
        }

        public static IList<TEntity> Get(ActiveUser activeUser, string storedProcName, bool langCode = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(langCode);
            var result = SqlSerializer.Default.DeserializeMultiRecords<TEntity>(storedProcName, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<TEntity>();
        }

        public static TEntity Post(ActiveUser activeUser, List<Parameter> entityParams, string storedProcName)
        {
            var result = SqlSerializer.Default.DeserializeSingleRecord<TEntity>(storedProcName, entityParams.ToArray(), storedProcedure: true);
            return result;
        }

        public static TEntity Put(ActiveUser activeUser, List<Parameter> entityParams, string storedProcName)
        {
            var result = SqlSerializer.Default.DeserializeSingleRecord<TEntity>(storedProcName, entityParams.ToArray(), storedProcedure: true);
            return result;
        }

        public static int Delete(ActiveUser activeUser, long id, string storedProcName)
        {
            var parameters = activeUser.DeleteDefaultParams(id);
            var result = SqlSerializer.Default.ExecuteRowCount(storedProcName, parameters.ToArray(), true);
            return result;
        }

		public static TEntity Patch(ActiveUser activeUser, List<Parameter> entityParams, string storedProcName)
		{
			var result = SqlSerializer.Default.DeserializeSingleRecord<TEntity>(storedProcName, entityParams.ToArray(), storedProcedure: true);
			return result;
		}

        public static SetCollection GetSetCollection(SetCollection sets, ActiveUser activeUser, List<Parameter> entityParams, string storedProcName)
        {
            SqlSerializer.Default.DeserializeMultiSets(sets, storedProcName, entityParams.ToArray(), storedProcedure: true);

            return sets;
        }

		public static bool ExecuteScaler(string storedProcName, List<Parameter> parameters)
		{
			bool result = SqlSerializer.Default.ExecuteScalar<bool>(storedProcName, parameters.ToArray(), false, true);

			return result;
		}

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, EntitiesAlias entity, int statusId, ReservedKeysEnum fieldName)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@entity", entity.ToString()),
                new Parameter("@ids", string.Join(",", ids)),
                new Parameter("@separator", ","),
                new Parameter("@statusId", statusId),
                new Parameter("@fieldName", fieldName.ToString())
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(StoredProceduresConstant.UpdateEntityField, parameters, storedProcedure: true);
            return result;
        }
    }
}