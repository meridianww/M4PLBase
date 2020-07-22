#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/02/2020
//Program Name:                                 JobAttachment
//Purpose:                                      End point to interact with JobAttachment module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobAttachmentController
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobAttachment")]
    public class JobAttachmentController : ApiController
    {
        private readonly IJobAttachmentCommands _jobAttachmentCommands;

        /// <summary>
        /// Function to get Job's Attachment details
        /// </summary>
        /// <param name="jobAttachmentCommands"></param>
        public JobAttachmentController(IJobAttachmentCommands jobAttachmentCommands)

        {
            _jobAttachmentCommands = jobAttachmentCommands;
        }
        /// <summary>
        /// Response
        /// </summary>
		public System.Web.HttpResponse Response { get; }

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobAttachment> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobAttachment.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobAttachment Get(long id)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobAttachment object passed as parameter.
        /// </summary>
        /// <param name="jobAttachment">Refers to jobAttachment object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobAttachment Post(JobAttachment jobAttachment)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Post(jobAttachment);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobAttachment object passed.
        /// </summary>
        /// <param name="jobAttachment">Refers to jobAttachment object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobAttachment Put(JobAttachment jobAttachment)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Put(jobAttachment);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobAttachment object passed.
        /// </summary>
        /// <param name="jobAttachment">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobAttachment Patch(JobAttachment jobAttachment)
        {
            _jobAttachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttachmentCommands.Patch(jobAttachment);
        }
        /// <summary>
        /// Get job attachment for download by order number
        /// </summary>
        /// <param name="orderNumber"></param>
        /// <returns></returns>
		[HttpGet]
        [Route("DownloadJobAttachment"), ResponseType(typeof(HttpResponseMessage))]
        public HttpResponseMessage DownloadJobAttachment(string orderNumber)
        {
            HttpResponseMessage response = Request.CreateResponse();
            IList<JobAttachment> fileAttachmentList = _jobAttachmentCommands.GetJobAttachment(orderNumber);
            if (fileAttachmentList?.Count > 0)
            {
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (ZipArchive zip = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
                    {
                        foreach (var fileAttachment in fileAttachmentList)
                        {
                            ZipArchiveEntry zipItem = zip.CreateEntry(fileAttachment.FileName);
                            using (MemoryStream originalFileMemoryStream = new MemoryStream(fileAttachment.FileContent))
                            {
                                using (Stream entryStream = zipItem.Open())
                                {
                                    originalFileMemoryStream.CopyTo(entryStream);
                                }
                            }
                        }
                    }

                    var streamSample = new MemoryStream(memoryStream.ToArray());
                    response.Content = new StreamContent(streamSample);
                    response.StatusCode = HttpStatusCode.OK;
                    response.Content.Headers.ContentLength = streamSample.Length;
                    response.Content.Headers.Add("Content-Disposition", "attachment; filename=" + orderNumber.Replace(" ", string.Empty) + ".zip");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/zip");
                }

                return response;
            }

            return Request.CreateResponse(HttpStatusCode.ExpectationFailed);
        }

        /// <summary>
        /// Get job attachment for download by invoice number
        /// </summary>
        /// <param name="invoiceNumber"></param>
        /// <returns></returns>
		[HttpGet]
        [Route("DownloadPdfAttachment"), ResponseType(typeof(HttpResponseMessage))]
        public HttpResponseMessage DownloadPdfAttachment(string invoiceNumber)
        {
            HttpResponseMessage response = Request.CreateResponse();
            IList<JobAttachment> fileAttachmentList = _jobAttachmentCommands.GetJobAttachmentByInvoiceNumber(invoiceNumber);
            byte[] finalBytes = null;
            List<byte[]> byteArrayList = null;
            byte[] fileBytes = null;
            if (fileAttachmentList?.Count > 0)
            {
                byteArrayList = new List<byte[]>();
                foreach (var fileAttachment in fileAttachmentList)
                {
                    fileBytes = _jobAttachmentCommands.GetFileByteArray(fileAttachment.FileContent, fileAttachment.FileName);
                    if (fileBytes != null) { byteArrayList.Add(fileBytes); }
                }

                if (byteArrayList?.Count > 0)
                {
                    finalBytes = _jobAttachmentCommands.GetCombindFileByteArray(byteArrayList);
                }

                var streamSample = new MemoryStream(finalBytes);
                response.Content = new StreamContent(streamSample);
                response.StatusCode = HttpStatusCode.OK;
                response.Content.Headers.ContentLength = streamSample.Length;
                response.Content.Headers.Add("Content-Disposition", "attachment; filename=" + invoiceNumber.Replace(" ", string.Empty) + ".pdf");
                response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                return response;
            }

            return Request.CreateResponse(HttpStatusCode.ExpectationFailed);
        }
    }
}