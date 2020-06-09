using M4PL.Entities.JobRollup;
using System.Collections.Generic;

namespace M4PL.Business.JobRollup
{
    public interface IJobRollupCommands : IBaseCommands<JobRollupList>
    {
        List<JobRollupList> GetRollupByProgram(long programId);

        List<JobRollupList> GetRollupByJob(long jobId);
    }
}
