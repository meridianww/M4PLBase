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
        IList<JobCardTileDetail> GetCardTileData(long companyId, string whereCondition);

        IList<Entities.Job.JobCard> GetDropDownDataForJobCard(long customerId, string entity);
    }
}
