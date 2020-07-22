#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Job;
using System.Collections.Generic;

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
