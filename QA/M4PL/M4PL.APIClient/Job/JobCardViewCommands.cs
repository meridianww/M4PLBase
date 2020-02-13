﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{

    public class JobCardViewCommands : BaseCommands<JobCardViewView>, IJobCardViewCommands
    {
        /// <summary>
        /// Route to call JobAdvanceReport
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobCard"; }
        }
    }
}
