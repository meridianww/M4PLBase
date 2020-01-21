using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Job
{
    public class JobReportCommands : BaseCommands<JobReport>
    {
        /// <summary>
        /// Gets list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.JobReport);
        }

        /// <summary>
        /// Gets the specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public static JobReport Post(ActiveUser activeUser, JobReport jobReport)
        {
            var parameters = GetParameters(jobReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobReport));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// Updates the existing Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public static JobReport Put(ActiveUser activeUser, JobReport jobReport)
        {
            var parameters = GetParameters(jobReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobReport.Id, jobReport));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteJob);
        }

        /// <summary>
        /// Deletes list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Job, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Job Module
        /// </summary>
        /// <param name="JobReport"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobReport JobReport)
        {
            var parameters = new List<Parameter>
            {
            };
            return parameters;
        }


        /// <summary>
        /// Gets list of Job tree data
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>
        public static IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@CompanyId", companyId),
                new Parameter("@LocationCode", locationCode),
                new Parameter("@StartDate", startDate),
                new Parameter("@EndDate",endDate),
                new Parameter("@IsPBSReport",IsPBSReport)
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobVocReport>(StoredProceduresConstant.GetVocReportData, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static IList<JobAdvanceReport> GetDropDownDataForProgram(ActiveUser activeUser, long customerId, string entity)
        {
            var parameters = new List<Parameter>
                  {
                     new Parameter("@CustomerId", customerId),
                     new Parameter("@entity", entity)
                 };
            if (entity == "Program")
            {
                var programRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (programRecord.Any())
                {
                    programRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        ProgramCode = "ALL",
                        Id = 0,
                    });
                }
                return programRecord;
            }
            else if (entity == "Origin")
            {
                var originRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (originRecord.Any())
                {
                    originRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        Origin = "ALL",
                        Id = 0,
                    });
                }
                return originRecord;
            }
            else if (entity == "Destination")
            {
                var destinationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (destinationRecord.Any())
                {
                    destinationRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        Destination = "ALL",
                        Id = 0,
                    });
                }
                return destinationRecord;
            }
            else if (entity == "Brand")
            {
                var brandRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (brandRecord.Any())
                {
                    brandRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        Brand = "ALL",
                        Id = 0,
                    });
                }
                return brandRecord;
            }
            else if (entity == "GatewayStatus")
            {
                var gatewayStatusRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (gatewayStatusRecord.Any())
                {
                    gatewayStatusRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        GatewayStatus = "ALL",
                        Id = 0,
                    });
                }
                return gatewayStatusRecord;
            }
            else if (entity == "ServiceMode")
            {
                var serviceModeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (serviceModeRecord.Any())
                {
                    serviceModeRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        ServiceMode = "ALL",
                        Id = 0,
                    });
                }
                return serviceModeRecord;
            }
            else if (entity == "ProductType")
            {
                var productTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (productTypeRecord.Any())
                {
                    productTypeRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        ProductType = "ALL",
                        Id = 0,
                    });
                }
                return productTypeRecord;
            }
            else if (entity == "Scheduled")
            {
                var scheduledTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (scheduledTypeRecord.Any())
                {
                    scheduledTypeRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        ScheduledName = "ALL",
                        Id = 0,
                    });
                }
                return scheduledTypeRecord;
            }
            else if (entity == "OrderType")
            {
                var orderTypeTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (orderTypeTypeRecord.Any())
                {
                    orderTypeTypeRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        OrderTypeName = "ALL",
                        Id = 0,
                    });
                }
                return orderTypeTypeRecord;
            }
            else if (entity == "JobStatus")
            {
                var jobStatusTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (jobStatusTypeRecord.Any())
                {
                    jobStatusTypeRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        JobStatusIdName = "ALL",
                        Id = 0,
                    });
                }
                return jobStatusTypeRecord;
            }
            else if (entity == "JobChannel")
            {
                var jobChannelRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (jobChannelRecord.Any())
                {
                    jobChannelRecord.Insert(0, new Entities.Job.JobAdvanceReport
                    {
                        JobChannel = "ALL",
                        Id = 0,
                    });
                }
                return jobChannelRecord;
            }
            else
            {
                return null;
            }

        }
    }
}