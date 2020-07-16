#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.Common;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Job
{
	public class JobHistoryCommands : BaseCommands<Entities.Job.JobHistory>
	{
		public static IList<JobHistory> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo, IList<ColumnSetting> columnSetting, IList<IdRefLangName> statusLookup)
		{
			var result = GetChangeHistory(pagedDataInfo.RecordId, activeUser, columnSetting, statusLookup);
			pagedDataInfo.TotalCount = result != null ? result.Count() : 0;
			return result;
		}

		public static List<JobHistory> GetChangeHistory(long jobId, ActiveUser activeUser, IList<ColumnSetting> columnSetting, IList<IdRefLangName> statusLookup)
		{
			List<JobHistory> changedDataList = null;
			List<Entities.Job.Job> changeHistoryData = DataAccess.Job.JobCommands.GetJobChangeHistory(jobId);
			if (changeHistoryData != null && changeHistoryData.Count > 1)
			{
				changedDataList = new List<JobHistory>();
				Entities.Job.Job originalDataModel = null;
				Entities.Job.Job changedDataModel = null;
				for (int i = 0; i < changeHistoryData.Count - 1; i++)
				{
					originalDataModel = changeHistoryData[i];
					changedDataModel = changeHistoryData[i + 1];
					List<ChangeHistoryData> changedData = CommonCommands.GetChangedValues(originalDataModel, changedDataModel, !string.IsNullOrEmpty(changedDataModel.ChangedBy) ? changedDataModel.ChangedBy : changedDataModel.EnteredBy, changedDataModel.DateChanged.HasValue ? (DateTime)changedDataModel.DateChanged : (DateTime)changedDataModel.DateEntered);
					if (changedData != null && changedData.Count > 0)
					{
						changedData.ForEach(x =>
						changedDataList.Add(new JobHistory()
						{
							FieldName = columnSetting != null && columnSetting.Where(y => y.ColColumnName == x.FieldName).Any() ?
							columnSetting.Where(y => y.ColColumnName == x.FieldName).First().ColAliasName : x.FieldName,
							ChangedBy = x.ChangedBy,
							ChangedDate = x.ChangedDate,
							OldValue = statusLookup != null && x.FieldName.Equals("StatusId", StringComparison.OrdinalIgnoreCase) ?
							statusLookup.FirstOrDefault(z => z.SysRefId == Convert.ToInt32(x.OldValue))?.LangName : x.OldValue,
							NewValue = statusLookup != null && x.FieldName.Equals("StatusId", StringComparison.OrdinalIgnoreCase) ?
							statusLookup.FirstOrDefault(z => z.SysRefId == Convert.ToInt32(x.NewValue))?.LangName : x.NewValue,
							JobID = jobId
						}));
					}
				}
			}

			return changedDataList;
		}
	}
}