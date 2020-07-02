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
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Job
{
	public class JobHistoryCommands : BaseCommands<Entities.Job.JobHistory>
	{
		public static IList<JobHistory> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			var result = GetChangeHistory(pagedDataInfo.RecordId, activeUser);
			pagedDataInfo.TotalCount = result != null ? result.Count() : 0;
			return result;
		}

		public static List<JobHistory> GetChangeHistory(long jobId, ActiveUser activeUser)
		{
			List<JobHistory> changedDataList = new List<JobHistory>();
			List<ChangeHistory> changeHistoryData = CommonCommands.GetChangeHistory(activeUser, jobId, EntitiesAlias.Job);
			if (changeHistoryData != null && changeHistoryData.Count > 0)
			{
				changedDataList = new List<JobHistory>();
				Entities.Job.Job originalDataModel = null;
				Entities.Job.Job changedDataModel = null;
				foreach (var historyData in changeHistoryData)
				{
					originalDataModel = JsonConvert.DeserializeObject<Entities.Job.Job>(historyData.OrigionalData);
					changedDataModel = JsonConvert.DeserializeObject<Entities.Job.Job>(historyData.ChangedData);
					List<JobHistory> changedData = CommonCommands.GetJobChangedValues(originalDataModel, changedDataModel, historyData.ChangedBy, historyData.ChangedDate, jobId);
					if (changedData != null && changedData.Count > 0)
					{
						changedData.ForEach(x => changedDataList.Add(x));
					}
				}
			}

			return changedDataList;
		}
	}
}