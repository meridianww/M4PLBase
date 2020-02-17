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
        JobDestination GetJobDestination(long id, long parentId);
        Entities.Job.JobCard GetJobByProgram(long id, long parentId);

        IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false);
        IList<JobCardTileDetail> GetCardTileData(long companyId);

        Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc);
        JobSeller PutJobSeller(JobSeller jobSeller);
        JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute);
        Job2ndPoc GetJob2ndPoc(long id, long parentId);
        JobSeller GetJobSeller(long id, long parentId);
        JobMapRoute GetJobMapRoute(long id);
        JobPod GetJobPod(long id);
        JobDestination PutJobDestination(JobDestination jobDestination);
    }
}
