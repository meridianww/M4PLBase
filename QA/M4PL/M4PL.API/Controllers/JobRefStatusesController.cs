/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobRefStatuses
//Purpose:                                      End point to interact with Job RefStatuses module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobRefStatuses")]
    public class JobRefStatusesController : BaseApiController<JobRefStatus>
    {
        private readonly IJobRefStatusCommands _jobRefStatusCommands;

        /// <summary>
        /// Function to get Job's RefStatuses details
        /// </summary>
        /// <param name="jobRefStatusCommands"></param>
        public JobRefStatusesController(IJobRefStatusCommands jobRefStatusCommands)
            : base(jobRefStatusCommands)
        {
            _jobRefStatusCommands = jobRefStatusCommands;
        }
    }
}