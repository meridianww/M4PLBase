using M4PL.Entities.JobRollup;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.JobRollup
{
	public interface IJobRollupCommands : IBaseCommands<JobRollupList>
	{
		 List<JobRollupList> GetJobRollupList(long programId);
	}
}
