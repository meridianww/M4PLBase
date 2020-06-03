/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/02/2020
//Program Name:                                 JobAttachment
//Purpose:                                      End point to interact with JobAttachment module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobAttachment")]
	public class JobAttachmentController : BaseApiController<JobAttachment>
	{
		private readonly IJobAttachmentCommands _jobAttachmentCommands;

		/// <summary>
		/// Function to get Job's Attachment details
		/// </summary>
		/// <param name="jobAttachmentCommands"></param>
		public JobAttachmentController(IJobAttachmentCommands jobAttachmentCommands)
			: base(jobAttachmentCommands)
		{
			_jobAttachmentCommands = jobAttachmentCommands;
		}

		public System.Web.HttpResponse Response { get; }

		[HttpGet]
		[Route("DownloadJobAttachment")]
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

		[AllowAnonymous]
		[HttpGet]
		[Route("DownloadPdfAttachment")]
		public HttpResponseMessage DownloadPdfAttachment(string orderNumber)
		{
			HttpResponseMessage response = Request.CreateResponse();
			IList<JobAttachment> fileAttachmentList = _jobAttachmentCommands.GetJobAttachment(orderNumber);
			byte[] finalBytes = null;
			List<byte[]> byteArrayList = null;
			byte[] fileBytes = null;
			if (fileAttachmentList?.Count > 0)
			{
				byteArrayList = new List<byte[]>();
				foreach (var fileAttachment in fileAttachmentList)
				{
					fileBytes = _jobAttachmentCommands.GetFileByteArray(fileAttachment.FileContent, fileAttachment.FileName);
					byteArrayList.Add(fileBytes);
				}

				if (byteArrayList?.Count > 0)
				{
					finalBytes = _jobAttachmentCommands.GetCombindFileByteArray(byteArrayList);
				}

				var streamSample = new MemoryStream(finalBytes);
				response.Content = new StreamContent(streamSample);
				response.StatusCode = HttpStatusCode.OK;
				response.Content.Headers.ContentLength = streamSample.Length;
				response.Content.Headers.Add("Content-Disposition", "attachment; filename=" + orderNumber.Replace(" ", string.Empty) + ".pdf");
				response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
				return response;
			}

			return Request.CreateResponse(HttpStatusCode.ExpectationFailed);
		}
	}
}