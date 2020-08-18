﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              1/20/2020
// Program Name:                                 JobAdvanceReportCommands
// Purpose:                                      Contains commands to perform CRUD on JobAdvanceReportCommands
//=============================================================================================================

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
			JobAdvanceReportRequest jobAdvanceReportRequest = null;
			if (pagedDataInfo.Params != null)
			{
				jobAdvanceReportRequest = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(pagedDataInfo.Params);
			}

			var parameters = GetParameters(pagedDataInfo, activeUser, null, jobAdvanceReportRequest);
			var results = SqlSerializer.Default.DeserializeMultiRecords<JobAdvanceReport>(StoredProceduresConstant.GetJobAdvanceReportView, parameters.ToArray(), storedProcedure: true);
			if (results != null && results.Count > 0 && jobAdvanceReportRequest != null)
			{
				results.ForEach(x => { x.StartDate = jobAdvanceReportRequest.StartDate; x.EndDate = jobAdvanceReportRequest.EndDate; });
			}

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
					 new Parameter("@entity", entity),
					 new Parameter("@userId", activeUser.UserId),
					 new Parameter("@roleId", activeUser.RoleId),
					 new Parameter("@orgId", activeUser.OrganizationId)
				 };
			if (entity == "Program")
			{
				var programRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				foreach (var item in programRecord)
				{
					item.ProgramTitle = string.IsNullOrEmpty(item.ProgramTitle) ? item.ProgramCode : item.ProgramTitle + "(" + item.ProgramCode + ")";
				}
				return programRecord;
			}
			else if (entity == "Origin")
			{
				var originRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return originRecord;
			}
			else if (entity == "Destination")
			{
				var destinationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return destinationRecord;
			}
			else if (entity == "Brand")
			{
				var brandRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return brandRecord;
			}
			else if (entity == "GatewayStatus")
			{
				var gatewayStatusRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return gatewayStatusRecord;
			}
			else if (entity == "ServiceMode")
			{
				var serviceModeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return serviceModeRecord;
			}
			else if (entity == "ProductType")
			{
				var productTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
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
				return jobChannelRecord;
			}
			else if (entity == "DateType")
			{
				var dateTypeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				return dateTypeRecord;
			}
			else if (entity == "PackagingCode")
			{
				var packagingCodeRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				if (packagingCodeRecord.Any())
				{
					packagingCodeRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
					{
						PackagingCode = "ALL",
						Id = 0,
					});
				}
				return packagingCodeRecord;
			}
			else if (entity == "WeightUnit")
			{
				var weightUnitRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				if (weightUnitRecord.Any())
				{
					weightUnitRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
					{
						WeightUnit = "ALL",
						Id = 0,
					});
				}
				return weightUnitRecord;
			}
			else if (entity == "CargoTitle")
			{
				var cargoTitleRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobAdvanceReportFilter>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
				if (cargoTitleRecord.Any())
				{
					cargoTitleRecord.Insert(0, new Entities.Job.JobAdvanceReportFilter
					{
						CargoTitle = "ALL",
						Id = 0,
					});
				}
				return cargoTitleRecord;
			}
			else
			{
				return null;
			}
		}

		private static List<Parameter> GetParameters(PagedDataInfo pagedDataInfo, ActiveUser activeUser, Entities.Job.JobAdvanceReport jobAdvanceReport, JobAdvanceReportRequest jobAdvanceReportRequest)
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

			if (jobAdvanceReportRequest != null)
			{
				parameters.Add(new Parameter("@reportTypeId", jobAdvanceReportRequest.ReportType));
				parameters.Add(new Parameter("@scheduled", jobAdvanceReportRequest.Scheduled));
				parameters.Add(new Parameter("@orderType", jobAdvanceReportRequest.OrderType));

				parameters.Add(new Parameter("@PackagingCode", jobAdvanceReportRequest.PackagingCode));
				if (jobAdvanceReportRequest.CargoId.HasValue)
					parameters.Add(new Parameter("@CargoId", jobAdvanceReportRequest.CargoId));

				if (!string.IsNullOrEmpty(jobAdvanceReportRequest.DateTypeName) && !string.IsNullOrWhiteSpace(jobAdvanceReportRequest.DateTypeName) && jobAdvanceReportRequest.DateTypeName == "Schedule Date")
				{
					parameters.Add(new Parameter("@DateType", jobAdvanceReportRequest.StartDate == null || jobAdvanceReportRequest.EndDate == null
			   ? string.Format(" AND GWY.GwyDDPNew IS NOT NULL  AND GWY.GwyDDPNew >= '{0}' AND GWY.GwyDDPNew <= '{1}' ", Utilities.TimeUtility.GetPacificDateTime().Date.AddDays(-1), Utilities.TimeUtility.GetPacificDateTime().Date.AddSeconds(86399))
			   : string.Format(" AND GWY.GwyDDPNew IS NOT NULL  AND GWY.GwyDDPNew >= '{0}' AND GWY.GwyDDPNew <= '{1}' ", jobAdvanceReportRequest.StartDate, jobAdvanceReportRequest.EndDate)));
				}
				if (!string.IsNullOrEmpty(jobAdvanceReportRequest.JobStatus) && !string.IsNullOrWhiteSpace(jobAdvanceReportRequest.JobStatus) && Convert.ToString(jobAdvanceReportRequest.JobStatus).ToLower() != "all")
					parameters.Add(new Parameter("@JobStatus", jobAdvanceReportRequest.JobStatus));
				else
					parameters.Add(new Parameter("@JobStatus", "Active"));
				if (!string.IsNullOrEmpty(jobAdvanceReportRequest.Search) && !string.IsNullOrWhiteSpace(jobAdvanceReportRequest.Search))
					parameters.Add(new Parameter("@SearchText", jobAdvanceReportRequest.Search));
				if (jobAdvanceReportRequest.GatewayTitle != null && jobAdvanceReportRequest.GatewayTitle.Count > 0 && !jobAdvanceReportRequest.GatewayTitle.Contains("ALL"))
				{
					string gatewayTitles = string.Format(" AND  GWY.GwyGatewayCode IN ('{0}')", string.Join("','", jobAdvanceReportRequest.GatewayTitle.OfType<string>()));
					parameters.Add(new Parameter("@gatewayTitles", gatewayTitles));
				}
			}

			parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

			return parameters;
		}
	}
}