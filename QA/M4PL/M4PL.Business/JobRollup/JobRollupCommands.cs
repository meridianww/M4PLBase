using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.JobRollup.JobRollupCommands;
using M4PL.Entities.JobRollup;
using System;

namespace M4PL.Business.JobRollup
{
	public class JobRollupCommands : BaseCommands<JobRollupList>, IJobRollupCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<JobRollupList> Get()
		{
			throw new NotImplementedException();
		}

		public JobRollupList Get(long id)
		{
			throw new NotImplementedException();
		}

		public List<JobRollupList> GetJobRollupList(long programId)
		{
			return _commands.GetJobRollupList(programId);
		}

		public IList<JobRollupList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public JobRollupList Patch(JobRollupList entity)
		{
			throw new NotImplementedException();
		}

		public JobRollupList Post(JobRollupList entity)
		{
			throw new NotImplementedException();
		}

		public JobRollupList Put(JobRollupList entity)
		{
			throw new NotImplementedException();
		}
	}
}
