﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                 Prashant Aggarwal
// Date Programmed:                            19/02/2020
// Program Name:                                 JobEDIXcblCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobEDIXcblCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using System;
using System.Collections.Generic;
using System.Linq;
using _commands = M4PL.DataAccess.Job.JobXcblInfoCommands;

namespace M4PL.Business.Job
{
	public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>, IJobXcblInfoCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<JobXcblInfo> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Patch(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Post(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Put(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId)
		{
			XCBLSummaryHeaderModel summaryHeaderModel = _commands.GetXCBLDataBySummaryHeaderId(ActiveUser, gatewayId);
			List<JobUpdateDecisionMaker> decisionMakerList = _commands.GetJobUpdateDecisionMaker();
			string gatewayCode = _commands.GetJobGatewayCode(gatewayId);

			if (!string.IsNullOrEmpty(gatewayCode))
			{
				decisionMakerList = decisionMakerList.Where(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) &&
									 !string.IsNullOrEmpty(obj.JobColumnName) &&
									 obj.IsAutoUpdate &&
									 string.Equals(obj.ActionCode, gatewayCode, StringComparison.OrdinalIgnoreCase)).ToList();
			}

			Entities.Job.Job job = _commands.GetJobById(ActiveUser, jobId);
			JobXcblInfo jobXcblInfo = new JobXcblInfo();

			if (summaryHeaderModel != null && decisionMakerList != null && decisionMakerList.Any() && job != null
				&& !string.IsNullOrEmpty(gatewayCode))
			{
				var columnAlias=Common.CommonCommands.GetColumnSettingsByEntityAlias(EntitiesAlias.Job,false);
				foreach (var item in decisionMakerList)
				{
					//JobXcblInfo jobXcblInfo = new JobXcblInfo();

					if (item.XCBLTableName == "SummaryHeader")
					{				

						IdentifyJobChanges(jobId, jobXcblInfo, item, job, summaryHeaderModel.SummaryHeader, columnAlias.Where(x => x.ColColumnName == item.JobColumnName)?.FirstOrDefault()?.ColAliasName);
					}
					else if (item.XCBLTableName == "Address")
					{
						if (summaryHeaderModel.Address != null && summaryHeaderModel.Address.Any())
						{
							foreach (var address in summaryHeaderModel.Address)
							{
								string existsingValueColumnName = string.Empty;
								object existingValue = string.Empty;
								object updatedValue = string.Empty;

								if (address.AddressTypeId == (int)Entities.xCBLAddressType.ShipFrom)
								{
									existsingValueColumnName = "JobOrigin" + item.JobColumnName;
								}
								else if (address.AddressTypeId == (int)Entities.xCBLAddressType.ShipTo)
								{
									existsingValueColumnName = "JobDelivery" + item.JobColumnName;
								}

								if (!string.IsNullOrEmpty(existsingValueColumnName))
								{
									existingValue = GetValuesFromItemByPropertyName(job, existsingValueColumnName);
									updatedValue = GetValuesFromItemByPropertyName(address, item.xCBLColumnName);
									AddItemToJobXcblInfoList(jobId, updatedValue, existingValue, existsingValueColumnName, jobXcblInfo, columnAlias.Where(x => x.ColColumnName == existsingValueColumnName)?.FirstOrDefault()?.ColAliasName);
								}
							}
						}
					}
					else if (item.XCBLTableName == "LineItem")
					{
						if (summaryHeaderModel.LineDetail != null && summaryHeaderModel.LineDetail.Any())
						{
							foreach (var lineDetail in summaryHeaderModel.LineDetail)
							{
								IdentifyJobChanges(jobId, jobXcblInfo, item, job, lineDetail, columnAlias.Where(x => x.ColColumnName == item.JobColumnName)?.FirstOrDefault()?.ColAliasName);
							}
						}
					}
					else if (item.XCBLTableName == "CustomAttribute")
					{
						IdentifyJobChanges(jobId, jobXcblInfo, item, job, summaryHeaderModel.CustomAttribute, columnAlias.Where(x => x.ColColumnName == item.JobColumnName)?.FirstOrDefault()?.ColAliasName);
					}
					else if (item.XCBLTableName == "UserDefinedField")
					{
						IdentifyJobChanges(jobId, jobXcblInfo, item, job, summaryHeaderModel.UserDefinedField, columnAlias.Where(x => x.ColColumnName == item.JobColumnName)?.FirstOrDefault()?.ColAliasName);
					}
				}
			}

			return jobXcblInfo;
		}

		private void IdentifyJobChanges(long jobId, JobXcblInfo jobXcblInfo, JobUpdateDecisionMaker item, object oldValueObject, object newValueObject, string columnAlias = "")
		{
			object existingValue = oldValueObject.GetType().GetProperty(item.JobColumnName).GetValue(oldValueObject);
			object updatedValue = newValueObject.GetType().GetProperty(item.xCBLColumnName).GetValue(newValueObject);
			AddItemToJobXcblInfoList(jobId, updatedValue, existingValue, item.JobColumnName, jobXcblInfo, columnAlias);
		}

		public string GetValuesFromItemByPropertyName(object item, string propertyName)
		{
			object value = item.GetType().GetProperty(propertyName).GetValue(item);
			return Convert.ToString(value);
		}

		private void AddItemToJobXcblInfoList(long jobId, object updatedValue, object existingvalue, string jobColumnName, JobXcblInfo jobXcblInfo,string columnAlias="")
		{
			string updatedValueString = Convert.ToString(updatedValue);

			if (!string.IsNullOrEmpty(updatedValueString) && updatedValueString != Convert.ToString(existingvalue))
			{
				jobXcblInfo.JobId = jobId;
				//jobXcblInfo.CustomerSalesOrderNumber = customerSalesOrder;
				if (jobXcblInfo.ColumnMappingData == null)
					jobXcblInfo.ColumnMappingData = new List<ColumnMappingData>();
				jobXcblInfo.ColumnMappingData.Add(new ColumnMappingData()
				{
					ColumnName = jobColumnName,
					UpdatedValue = updatedValueString,
					ExistingValue = Convert.ToString(existingvalue),
					ColumnAlias= columnAlias?? jobColumnName
				});
			}
		}

		public bool AcceptJobXcblInfo(long jobId, long gatewayId)
		{
			JobXcblInfo jobxcblInfo = GetJobXcblInfo(jobId, gatewayId);
			jobxcblInfo.JobGatewayId = gatewayId;
			return _commands.AcceptJobXcblInfo(ActiveUser, jobxcblInfo);
		}

		public bool RejectJobXcblInfo(long gatewayId)
		{
			return _commands.RejectJobXcblInfo(ActiveUser, gatewayId);
		}
	}
}