
/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobCardView")]
    public class JobCardViewController : BaseApiController<JobCardView>
    {
        private readonly IJobCardViewCommands _jobCardViewCommands;

        /// <summary>
        /// Function to get Job's advance Report details
        /// </summary>
        /// <param name="jobCardViewCommands"></param>
        public JobCardViewController(IJobCardViewCommands jobCardViewCommands)
            : base(jobCardViewCommands)
        {
            _jobCardViewCommands = jobCardViewCommands;
        }

    }
}