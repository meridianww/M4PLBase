
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using M4PL.Utilities;

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

        /// <summary>
        /// Gets list of Job card title
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public static IList<JobCardTileDetail> GetCardTileData(ActiveUser activeUser, long companyId)
        {
            var parameters = new List<Parameter>()
            {
            };

            var result = SqlSerializer.Default.DeserializeMultiRecords<JobCardTileDetail>(StoredProceduresConstant.GetCardTileData, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<JobCardTileDetail>();
        }

        /// <summary>
        /// Gets list of Job card title
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public static int GetCardTileDataCount(long companyId, long dashBoardRelationalId, List<DataAccess.Job.CustomEntity> permittedEntityIds, string whereCondition)
        {
            var uttDataTable = permittedEntityIds.ToDataTable();
            uttDataTable.RemoveColumnsFromDataTable(new List<string> { "EntityId" });
            var parameters = new List<Parameter>
            {
                new Parameter("@CompanyId", companyId),
                new Parameter("@dashboardRelationalId", dashBoardRelationalId),
                new Parameter("@PermissionEnityIds",  uttDataTable, "dbo.uttIDList"),
                new Parameter("@whereContition",whereCondition)
            };

            var result = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.GetCardTileDataCount, parameters.ToArray(), storedProcedure: true);
            return result;
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
                if (data.DashboardCategoryRelationId > 0)
                {
                    parameters.Add(new Parameter("@dashCategoryRelationId", data.DashboardCategoryRelationId));
                    if (data.CustomerId != null && data.CustomerId > 0)
                    {
                        pagedDataInfo.WhereCondition = string.Format(" {0} AND prg.PrgCustID = {1} ", pagedDataInfo.WhereCondition, data.CustomerId);
                    }

					parameters.Add(new Parameter("@where", pagedDataInfo.WhereCondition));
				}


            }
            parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

            return parameters;
        }

        public static List<CustomEntity> GetCustomEntityIdByEntityName(ActiveUser activeUser, EntitiesAlias entity)
        {
            var parameters = new[]
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@entity", entity.ToString()),
            };
            try
            {
                var result = SqlSerializer.Default.DeserializeMultiRecords<CustomEntity>(StoredProceduresConstant.GetCustomEntityIdByEntityName, parameters, false, storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {

                throw;
            }
        }


        public static IList<Entities.Job.JobCard> GetDropDownDataForJobCard(ActiveUser activeUser, long customerId, string entity)
        {
            var parameters = new List<Parameter>
                  {
                     new Parameter("@CustomerId", customerId),
                     new Parameter("@entity", entity),
                     new Parameter("@orgId",activeUser.OrganizationId),
                     new Parameter("@userId",activeUser.UserId),
                     new Parameter("@roleId",activeUser.RoleId)                   
                 };
            if (entity == "Origin")
            {
                var originRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return originRecord;
            }
            else if (entity == "Destination")
            {
                var destinationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return destinationRecord;
            }
            else if (entity == "Brand")
            {
                var brandRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return brandRecord;
            }
            else if (entity == "GatewayStatus")
            {
                var gatewayStatusRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return gatewayStatusRecord;
            }
            else if (entity == "ServiceMode")
            {
                var serviceModeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return serviceModeRecord;
            }
            else if (entity == "ProductType")
            {
                var productTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return productTypeRecord;
            }
            else
            {
                return null;
            }

        }
    }

    public class CustomEntity
    {
        public long EntityId { get; set; }
        public long ID { get; set; }

        public CustomEntity()
        {
            this.ID = this.EntityId;
        }
    }
}