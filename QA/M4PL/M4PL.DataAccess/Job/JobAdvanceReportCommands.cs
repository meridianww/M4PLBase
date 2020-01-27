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
using System.Collections.Generic;
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
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobAdvanceReportView, EntitiesAlias.JobAdvanceReport);
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
                if (programRecord.Any())
                {
                    programRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        ProgramCode = "ALL",
                        Id = 0,
                    });
                }
                return programRecord;
            }
            else if (entity == "Origin")
            {
                var originRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (originRecord.Any())
                {
                    originRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        Origin = "ALL",
                        Id = 0,
                    });
                }
                return originRecord;
            }
            else if (entity == "Destination")
            {
                var destinationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (destinationRecord.Any())
                {
                    destinationRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        Destination = "ALL",
                        Id = 0,
                    });
                }
                return destinationRecord;
            }
            else if (entity == "Brand")
            {
                var brandRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (brandRecord.Any())
                {
                    brandRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        Brand = "ALL",
                        Id = 0,
                    });
                }
                return brandRecord;
            }
            else if (entity == "GatewayStatus")
            {
                var gatewayStatusRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (gatewayStatusRecord.Any())
                {
                    gatewayStatusRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        GatewayStatus = "ALL",
                        Id = 0,
                    });
                }
                return gatewayStatusRecord;
            }
            else if (entity == "ServiceMode")
            {
                var serviceModeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (serviceModeRecord.Any())
                {
                    serviceModeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        ServiceMode = "ALL",
                        Id = 0,
                    });
                }
                return serviceModeRecord;
            }
            else if (entity == "ProductType")
            {
                var productTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                if (productTypeRecord.Any())
                {
                    productTypeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
                    {
                        ProductType = "ALL",
                        Id = 0,
                    });
                }
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
                if (jobChannelRecord.Any())
                {
                    jobChannelRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
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