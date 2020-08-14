using M4PL.API.Filters;
using M4PL.Business.JobServices;
using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobService
    /// </summary>  
    [RoutePrefix("api/JobServices")]
    public class JobServicesController : ApiController
    {
        /// <summary>
        /// IJobServiceCommands
        /// </summary>
        private readonly IJobServiceCommands _jobServicesCommands;

        /// <summary>
        /// JobServicesController constructor
        /// </summary>
        /// <param name="jobServiceCommands"></param>
        public JobServicesController(IJobServiceCommands jobServiceCommands)
        {
            _jobServicesCommands = jobServiceCommands;
        }

        /// <summary>
        /// Get Search Order Result by search string
        /// </summary>
        /// <param name="search"></param>
        /// <returns></returns>   
        [AllowAnonymous]
        public async Task<HttpResponseMessage> GetSearchOrder(string search)
        {
            if (string.IsNullOrEmpty(search)) return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            var result = await _jobServicesCommands.GetSearchOrder(search, Models.ApiContext.ActiveUser);
            if (result != null)
                return Request.CreateResponse(HttpStatusCode.OK, result);
            else
                return Request.CreateResponse(HttpStatusCode.NotFound, new List<SearchOrder>());
        }
        /// <summary>
        /// GetOrderDetailsById
        /// </summary>
        /// <param name="Id"></param>
        /// <returns>Order details by Job Id</returns>
        [AllowAnonymous]
        public async Task<HttpResponseMessage> GetOrderDetailsById(long Id)
        {
            if (Id <= 0) return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            var result = await _jobServicesCommands.GetOrderDetailsById(Id, Models.ApiContext.ActiveUser);
            if (result != null)
                return Request.CreateResponse(HttpStatusCode.OK, result);
            else
                return Request.CreateResponse(HttpStatusCode.NotFound, new OrderDetails());
        }

        /// <summary>
        /// InsertComment
        /// </summary>
        /// <param name="gatwayId"></param>
        /// <param name="jobGatewayComment"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        public bool InsertComment(JobGatewayComment jobGatewayComment)
        {
            return _jobServicesCommands.InsertComment(jobGatewayComment, Models.ApiContext.ActiveUser);
        }
    }
}
