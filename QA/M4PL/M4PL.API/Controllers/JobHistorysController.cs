using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Business.Job;
using M4PL.Entities.Job;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobHistorysController
    /// </summary>
    [RoutePrefix("api/JobHistorys")]
    public class JobHistorysController : BaseApiController<JobHistory>
    {
        private readonly IJobHistorysCommands _jobHistorysController;
        /// <summary>
        /// JobHistorysController
        /// </summary>
        /// <param name="jobHistorysController"></param>
        public JobHistorysController(IJobHistorysCommands jobHistorysController)
           : base(jobHistorysController)
        {
            _jobHistorysController = jobHistorysController;
        }
    }
}
