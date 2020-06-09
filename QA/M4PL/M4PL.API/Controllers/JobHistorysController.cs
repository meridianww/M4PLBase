using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

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
