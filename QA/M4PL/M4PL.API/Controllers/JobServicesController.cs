using M4PL.API.Filters;
using M4PL.Business.JobServices;
using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
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
        /// GetGatewayDetailsByJobID
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        [AllowAnonymous]
        public async Task<HttpResponseMessage> GetGatewayDetailsByJobID(long Id)
        {
            if (Id <= 0) return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            var result = await _jobServicesCommands.GetGatewayDetailsByJobID(Id, Models.ApiContext.ActiveUser);
            if (result != null)
                return Request.CreateResponse(HttpStatusCode.OK, result);
            else
                return Request.CreateResponse(HttpStatusCode.NotFound, new OrderGatewayDetails());
        }
        /// <summary>
        /// GetDocumentDetailsByJobID
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        [CustomAuthorize]
        public async Task<HttpResponseMessage> GetDocumentDetailsByJobID(long Id)
        {
            if (Id <= 0) return Request.CreateResponse(HttpStatusCode.BadRequest, false);
            var result = await _jobServicesCommands.GetDocumentDetailsByJobID(Id, Models.ApiContext.ActiveUser);
            if (result != null)
                return Request.CreateResponse(HttpStatusCode.OK, result);
            else
                return Request.CreateResponse(HttpStatusCode.NotFound, new OrderDocumentDetails());
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
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        public bool UploadDocument()
        {
            var httpRequest = HttpContext.Current.Request;
            JobDocument jobDocument = new JobDocument();
            jobDocument.JobId = Convert.ToInt64(httpRequest.Params["JobId"]);
            jobDocument.JdrCode = httpRequest.Params["JdrCode"];
            jobDocument.DocTypeId = Convert.ToInt32(httpRequest.Params["DocTypeId"]);
            jobDocument.StatusId = 1;
            jobDocument.JdrTitle = !string.IsNullOrEmpty(jobDocument.JdrCode) ? new string(jobDocument.JdrCode.Take(20).ToArray()) : string.Empty;

            if (httpRequest.Files.Count > 0)
            {
                List<DocumentAttachment> listDocumentAttachment = new List<DocumentAttachment>();
                for (var i = 0; i < httpRequest.Files.Count; i++)
                {
                    byte[] fileData = null;
                    var postedFile = httpRequest.Files[i];
                    using (var binaryReader = new BinaryReader(postedFile.InputStream))
                    {
                        fileData = binaryReader.ReadBytes(postedFile.ContentLength);
                    }
                    listDocumentAttachment.Add(new DocumentAttachment()
                    {
                        Name = postedFile.FileName,
                        Content = fileData
                    });
                }
                jobDocument.DocumentAttachment = listDocumentAttachment;
            }
            return _jobServicesCommands.UploadDocument(jobDocument, Models.ApiContext.ActiveUser);
        }

        /// <summary>
        /// GetJobGatewayNotes
        /// </summary>
        /// <param name="gatewayId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetJobGatewayNotes")]
        public string GetJobGatewayNotes(long gatewayId)
        {
            return _jobServicesCommands.GetJobGatewayNotes(gatewayId, Models.ApiContext.ActiveUser);
        }
    }
}
