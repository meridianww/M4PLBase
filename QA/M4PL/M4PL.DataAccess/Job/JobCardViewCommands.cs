
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace M4PL.DataAccess.Job
{
    public class JobCardViewCommands : BaseCommands<JobCardView>
    {
        /// <summary>
        /// Gets list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobCardView> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = GetParameters(pagedDataInfo, activeUser, null);
            var results = SqlSerializer.Default.DeserializeMultiRecords<JobCardView>(StoredProceduresConstant.GetJobAdvanceReportView, parameters.ToArray(), storedProcedure: true);
            if (!(parameters[parameters.ToArray().Length - 1].Value is DBNull))
                pagedDataInfo.TotalCount = Convert.ToInt32(parameters[parameters.ToArray().Length - 1].Value);
            else pagedDataInfo.TotalCount = 0;

            return results;
        }

        /// <summary>
        /// Gets the specific JobAdvanceReport record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobCardView Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobAdvanceReport);
        }

        /// <summary>
        /// Deletes a specific JobAdvanceReport record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return 0;
        }

        /// <summary>
        /// Deletes list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobAdvanceReport, statusId, ReservedKeysEnum.StatusId);
        }
        
        private static List<Parameter> GetParameters(PagedDataInfo pagedDataInfo, ActiveUser activeUser, Entities.Job.JobAdvanceReport jobAdvanceReport)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@entity", pagedDataInfo.Entity.ToString()),
               new Parameter("@pageNo", pagedDataInfo.PageNumber),
               new Parameter("@pageSize", pagedDataInfo.PageSize),
               new Parameter("@orderBy", pagedDataInfo.OrderBy),
               new Parameter("@where", pagedDataInfo.WhereCondition),
               new Parameter("@parentId", pagedDataInfo.ParentId),
               new Parameter("@isNext", pagedDataInfo.IsNext),
               new Parameter("@isEnd", pagedDataInfo.IsEnd),
               new Parameter("@recordId", pagedDataInfo.RecordId),
               new Parameter("@groupBy", pagedDataInfo.GroupBy),
               new Parameter("@IsExport", pagedDataInfo.IsJobParentEntity),
               new Parameter("@groupByWhere", pagedDataInfo.GroupByWhereCondition)
            };

            parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

            return parameters;
        }
    }
}