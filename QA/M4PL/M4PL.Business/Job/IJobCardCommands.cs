using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
	/// perfoems basic CRUD operation on the Job Card Veiw Entity
	/// </summary>
	public interface IJobCardCommands : IBaseCommands<Entities.Job.JobCard>
    {
        Entities.Job.JobCard GetJobByProgram(long id, long parentId);

        IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false);
        IList<JobCardTileDetail> GetCardTileData(long companyId);
    }
}
