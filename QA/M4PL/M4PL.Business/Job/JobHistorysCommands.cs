#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobHistoryCommands;

namespace M4PL.Business.Job
{
	public class JobHistorysCommands : BaseCommands<JobHistory>, IJobHistorysCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public JobHistory Get(long id)
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// Get list of job data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Job.JobHistory> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			IList<IdRefLangName> statusLookup = CoreCache.GetIdRefLangNames("EN", 39);
			IList<ColumnSetting> columnSetting = CoreCache.GetColumnSettingsByEntityAlias("EN", Entities.EntitiesAlias.Job);
			return _commands.GetPagedData(ActiveUser, pagedDataInfo, columnSetting, statusLookup);
		}

		public JobHistory Patch(JobHistory entity)
		{
			throw new NotImplementedException();
		}

		public JobHistory Post(JobHistory entity)
		{
			throw new NotImplementedException();
		}

		public JobHistory Put(JobHistory entity)
		{
			throw new NotImplementedException();
		}
	}
}