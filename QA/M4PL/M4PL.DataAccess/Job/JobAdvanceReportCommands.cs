/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 JobAdvanceReportCommands
Purpose:                                      Contains commands to perform CRUD on JobAdvanceReportCommands
=============================================================================================================*/

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
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReport>
    {
        /// <summary>
        /// Gets list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobAdvanceReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = GetParameters(pagedDataInfo, activeUser, null);
            var results = SqlSerializer.Default.DeserializeMultiRecords<JobAdvanceReport>(StoredProceduresConstant.GetJobAdvanceReportView, parameters.ToArray(), storedProcedure: true);
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

        public static JobAdvanceReport Get(ActiveUser activeUser, long id)
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

        public static IList<JobAdvanceReportFilter> GetDropDownDataForProgram(ActiveUser activeUser, long customerId, string entity)
        {
            var parameters = new List<Parameter>
                  {
                     new Parameter("@CustomerId", customerId),
                     new Parameter("@entity", entity)
                 };
            if (entity == "Program")
            {
                var programRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                foreach (var item in programRecord)
                {
                    item.ProgramTitle = string.IsNullOrEmpty(item.ProgramTitle) ? item.ProgramCode : item.ProgramTitle + "("+ item.ProgramCode + ")";
                }
                //if (programRecord.Any())
                //{
                //    programRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        ProgramCode = "ALL",
                //        Id = 0,
                //    });
                //}
                return programRecord;
            }
            else if (entity == "Origin")
            {
                var originRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (originRecord.Any())
                //{
                //    originRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        Origin = "ALL",
                //        Id = 0,
                //    });
                //}
                return originRecord;
            }
            else if (entity == "Destination")
            {
                var destinationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (destinationRecord.Any())
                //{
                //    destinationRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        Destination = "ALL",
                //        Id = 0,
                //    });
                //}
                return destinationRecord;
            }
            else if (entity == "Brand")
            {
                var brandRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (brandRecord.Any())
                //{
                //    brandRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        Brand = "ALL",
                //        Id = 0,
                //    });
                //}
                return brandRecord;
            }
            else if (entity == "GatewayStatus")
            {
                var gatewayStatusRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (gatewayStatusRecord.Any())
                //{
                //    gatewayStatusRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        GatewayStatus = "ALL",
                //        Id = 0,
                //    });
                //}
                return gatewayStatusRecord;
            }
            else if (entity == "ServiceMode")
            {
                var serviceModeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (serviceModeRecord.Any())
                //{
                //    serviceModeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        ServiceMode = "ALL",
                //        Id = 0,
                //    });
                //}
                return serviceModeRecord;
            }
            else if (entity == "ProductType")
            {
                var productTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (productTypeRecord.Any())
                //{
                //    productTypeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        ProductType = "ALL",
                //        Id = 0,
                //    });
                //}
                return productTypeRecord;
            }
            else if (entity == "Scheduled")
            {
                var scheduledTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (scheduledTypeRecord.Any())
                {
                    scheduledTypeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        ScheduledName = "ALL",
                        Id = 0,
                    });
                }
                return scheduledTypeRecord;
            }
            else if (entity == "OrderType")
            {
                var orderTypeTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (orderTypeTypeRecord.Any())
                {
                    orderTypeTypeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        OrderTypeName = "ALL",
                        Id = 0,
                    });
                }
                return orderTypeTypeRecord;
            }
            else if (entity == "JobStatus")
            {
                var jobStatusTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (jobStatusTypeRecord.Any())
                {
                    jobStatusTypeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        JobStatusIdName = "ALL",
                        Id = 0,
                    });
                }
                return jobStatusTypeRecord;
            }
            else if (entity == "JobChannel")
            {
                var jobChannelRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                //if (jobChannelRecord.Any())
                //{
                //    jobChannelRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                //    {
                //        JobChannel = "ALL",
                //        Id = 0,
                //    });
                //}
                return jobChannelRecord;
            }
            else if (entity == "DateType")
            {
                var dateTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return dateTypeRecord;
            }
            else
            {
                return null;
            }

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
                var data = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(pagedDataInfo.Params);
                if (data.Scheduled == "Scheduled")
                    parameters.Add(new Parameter("@scheduled", " AND GWY.GwyDDPNew IS NOT NULL "));

                else if (data.Scheduled == "Not Scheduled")
                    parameters.Add(new Parameter("@scheduled", " AND GWY.GwyDDPNew IS NULL "));

                if (data.OrderType == "Original")
                    parameters.Add(new Parameter("@orderType", " AND GWY.GwyOrderType = 'Original' "));
                else if (data.OrderType == "Return")
                    parameters.Add(new Parameter("@orderType", " AND GWY.GwyOrderType = 'Return' "));

                if (!string.IsNullOrEmpty(data.DateTypeName) && !string.IsNullOrWhiteSpace(data.DateTypeName) && data.DateTypeName == "Schedule Date")
                {
                    parameters.Add(new Parameter("@DateType", data.StartDate == null || data.EndDate == null
               ? string.Format(" AND GWY.GwyDDPNew IS NOT NULL  AND GWY.GwyDDPNew BETWEEN '{0}' AND '{1}' ", DateTime.UtcNow.AddDays(-1), DateTime.UtcNow)
               : string.Format(" AND GWY.GwyDDPNew IS NOT NULL  AND GWY.GwyDDPNew BETWEEN '{0}' AND '{1}' ", data.StartDate, data.EndDate)));
                }
                if (!string.IsNullOrEmpty(data.JobStatus) && !string.IsNullOrWhiteSpace(data.JobStatus) && Convert.ToString(data.JobStatus).ToLower() !="all")
                    parameters.Add(new Parameter("@JobStatus", data.JobStatus));
                //if (!string.IsNullOrEmpty(data.Search) && !string.IsNullOrWhiteSpace(data.Search))
                //    parameters.Add(new Parameter("@SearchText", data.Search));
                if (!string.IsNullOrEmpty(data.Search) && !string.IsNullOrWhiteSpace(data.Search))
                    parameters.Add(new Parameter("@SearchText", data.Search));
                if (data.GatewayTitle != null && data.GatewayTitle.Count > 0 && !data.GatewayTitle.Contains("ALL")) {
                    string gatewayTitles = string.Format(" AND PrgGwty.PgdGatewayTitle IN ('{0}')", string.Join("','", data.GatewayTitle.OfType<string>()));
                    parameters.Add(new Parameter("@gatewayTitles", gatewayTitles));
                }
                   
            }

            parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

            return parameters;
        }
    }
}