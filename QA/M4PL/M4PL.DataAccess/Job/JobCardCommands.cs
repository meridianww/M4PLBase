
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
    public class JobCardCommands : BaseCommands<Entities.Job.JobCard>
    {
        /// <summary>
        /// Gets list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Job.JobCard> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = GetParameters(pagedDataInfo, activeUser, null);
            var results = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetJobCardView, parameters.ToArray(), storedProcedure: true);
            if (!(parameters[parameters.ToArray().Length - 1].Value is DBNull))
                pagedDataInfo.TotalCount = Convert.ToInt32(parameters[parameters.ToArray().Length - 1].Value);
            else pagedDataInfo.TotalCount = 0;

            return results;
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

        public static Entities.Job.JobCard GetJobByProgram(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.JobCard>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.JobCard();
        }

        public static IList<JobsSiteCode> GetJobsSiteCodeByProgram(ActiveUser activeUser, long id, long parentId, bool isNullFIlter = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            parameters.Add(new Parameter("@isNullFIlter", isNullFIlter));
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobsSiteCode>(StoredProceduresConstant.GetJobsSiteCodeByProgram, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<JobsSiteCode>();
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


            if (pagedDataInfo.Params != null)
            {
                var data = JsonConvert.DeserializeObject<JobCardRequest>(pagedDataInfo.Params);              
                if (!string.IsNullOrEmpty(data.CardName) && !string.IsNullOrWhiteSpace(data.CardName) && Convert.ToString(data.CardName).ToLower() != "all")
                    parameters.Add(new Parameter("@JobStatus", data.CardName));   
            }
            parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

            return parameters;
        }
    }
}