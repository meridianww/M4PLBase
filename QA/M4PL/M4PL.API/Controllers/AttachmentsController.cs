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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 Attachment
//Purpose:                                      End point to interact with Attachment
//====================================================================================================================================================*/

using M4PL.Business.Attachment;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/Attachments")]
	public class AttachmentsController : BaseApiController<Attachment>
	{
		private readonly IAttachmentCommands _attachmentCommands;

		/// <summary>
		/// Function to get attachment details
		/// </summary>
		/// <param name="attachmentCommands"></param>
		public AttachmentsController(IAttachmentCommands attachmentCommands)
			: base(attachmentCommands)
		{
			_attachmentCommands = attachmentCommands;
		}

		[HttpDelete]
		[Route("DeleteAndUpdateAttachmentCount")]
		public virtual IList<IdRefLangName> DeleteAndUpdateAttachmentCount(string ids, int statusId, string parentTable, string fieldName)
		{
			BaseCommands.ActiveUser = ActiveUser;
			return _attachmentCommands.DeleteAndUpdateAttachmentCount(ids.Split(',').Select(long.Parse).ToList(), statusId, parentTable, fieldName);
		}

		#region API's To Get the Document For a Single Job

		/// <summary>
		/// GetAttachmentsByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetAttachmentsByJobId")]
		public Entities.Document.DocumentData GetAttachmentsByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetAllAvaliableAttachmentsForJob(selectedJobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetBOLDocumentByJobId")]
		public Entities.Document.DocumentData GetBOLDocumentByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetBOLDocumentByJobId(selectedJobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetPODDocumentByJobId")]
		public Entities.Document.DocumentData GetPODDocumentByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetPODDocumentByJobId(selectedJobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetTrackingDocumentByJobId")]
		public Entities.Document.DocumentData GetTrackingDocumentByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetTrackingDocumentByJobId(selectedJobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetPriceCodeReportByJobId")]
		public Entities.Document.DocumentData GetPriceCodeReportByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetPriceCodeReportDocumentByJobId(selectedJobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[AllowAnonymous]
		[HttpGet]
		[Route("GetCostCodeReportByJobId")]
		public Entities.Document.DocumentData GetCostCodeReportByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetCostCodeReportDocumentByJobId(selectedJobId);
		}

		#endregion

		#region API's to Get the Document For Multiple Jobs

		#endregion

		#region API's to Check the Different Job Document Existence

		[HttpGet]
		[Route("IsPriceCodeDataPresentForJob")]
		public Entities.Document.DocumentStatus IsPriceCodeDataPresentForJob(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.IsPriceCodeDataPresentForJob(selectedJobId);
		}

		[HttpGet]
		[Route("IsCostCodeDataPresentForJob")]
		public Entities.Document.DocumentStatus IsCostCodeDataPresentForJob(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.IsCostCodeDataPresentForJob(selectedJobId);
		}

		[HttpGet]
		[Route("GetDocumentStatusByJobId")]
		public Entities.Document.DocumentStatus GetDocumentStatusByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			return _attachmentCommands.GetDocumentStatusByJobId(selectedJobId);
		}

		#endregion
	}
}