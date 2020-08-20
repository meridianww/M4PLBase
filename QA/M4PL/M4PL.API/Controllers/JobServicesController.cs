﻿using M4PL.API.Filters;
using M4PL.Business.JobServices;
using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Script.Serialization;

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

        /// <summary>
        /// UploadDocument
        /// </summary>
        /// <param name="jobDocument"></param>
        /// <returns></returns>
        [HttpPost]
        [CustomAuthorize]
        public async Task<bool> UploadDocument(HttpRequestMessage request)
        {
            var response = request.Content.ReadAsStringAsync().Result;
            JobDocument jobDocument = JsonConvert.DeserializeObject<JobDocument>(response);
            return _jobServicesCommands.UploadDocument(jobDocument, Models.ApiContext.ActiveUser);
        }
    }
}
