#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

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