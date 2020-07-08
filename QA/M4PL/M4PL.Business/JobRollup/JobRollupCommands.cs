#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Entities.JobRollup;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.JobRollup.JobRollupCommands;

namespace M4PL.Business.JobRollup
{
    public class JobRollupCommands : BaseCommands<JobRollupList>, IJobRollupCommands
    {
     
        public List<JobRollupList> GetRollupByProgram(long programId)
        {
            return _commands.GetRollupByProgram(programId);
        }

        public List<JobRollupList> GetRollupByJob(long jobId)
        {
            return _commands.GetRollupByJob(jobId);
        }

             
    }
}
