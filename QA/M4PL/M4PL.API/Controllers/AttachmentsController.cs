/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Attachment
//Purpose:                                      End point to interact with Attachment
//====================================================================================================================================================*/

using M4PL.Business.Attachment;
using M4PL.Entities;
using M4PL.Entities.Support;
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

        /// <summary>
        /// GetAttachmentsByJobId
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetAttachmentsByJobId")]
        public List<Entities.Attachment> GetAttachmentsByJobId(long jobId)
        {
            return _attachmentCommands.GetAttachmentsByJobId(jobId);
        }

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetBOLDocumentByJobId")]
		public Entities.Document.DocumentData GetBOLDocumentByJobId(long jobId)
		{
			return _attachmentCommands.GetBOLDocumentByJobId(jobId);
		}

		/// <summary>
		/// GetBOLDocumentByJobId
		/// </summary>
		/// <param name="jobId"></param>
		/// <returns></returns>
		[AllowAnonymous]
		[HttpGet]
		[Route("GetTrackingDocumentByJobId")]
		public Entities.Document.DocumentData GetTrackingDocumentByJobId(long jobId)
		{
			return _attachmentCommands.GetTrackingDocumentByJobId(jobId);
		}

	}
}

