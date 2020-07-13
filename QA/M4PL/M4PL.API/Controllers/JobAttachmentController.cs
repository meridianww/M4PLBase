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

using M4PL.API.Models;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
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
	[RoutePrefix("api/JobAttachment")]
	public class JobAttachmentController : ApiController
	{
		private readonly IJobAttachmentCommands _jobAttachmentCommands;

        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

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