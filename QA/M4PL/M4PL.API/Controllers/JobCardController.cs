
/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using System.Web.Http;
using M4PL.Business.Job;
using M4PL.Entities.Job;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobCard")]
    public class JobCardController : BaseApiController<Job>
    {
        private readonly IJobCardCommands _jobCardViewCommands;

        /// <summary>
        /// Function to get Job's advance Report details
        /// </summary>
        /// <param name="jobCardCommands"></param>
        public JobCardController(IJobCardCommands jobCardCommands)
            : base(jobCardCommands)
        {
            _jobCardViewCommands = jobCardCommands;
        }

    }
}