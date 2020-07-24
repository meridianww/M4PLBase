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

using M4PL.API.Filters;
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
    [CustomAuthorize]
    [RoutePrefix("api/Attachments")]
    public class AttachmentsController : ApiController
    {
        private readonly IAttachmentCommands _attachmentCommands;

        /// <summary>
        /// Function to get attachment details
        /// </summary>
        /// <param name="attachmentCommands"></param>
        public AttachmentsController(IAttachmentCommands attachmentCommands)

        {
            _attachmentCommands = attachmentCommands;
        }

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
        public virtual IQueryable<Attachment> PagedData(PagedDataInfo pagedDataInfo)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the attachment.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Attachment Get(long id)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new attachment object passed as parameter.
        /// </summary>
        /// <param name="attachment">Refers to attachment object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Attachment Post(Attachment attachment)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Post(attachment);
        }

        /// <summary>
        /// Put method is used to update record values completely based on attachment object passed.
        /// </summary>
        /// <param name="attachment">Refers to attachment object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Attachment Put(Attachment attachment)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Put(attachment);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Delete(id);
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
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on attachment object passed.
        /// </summary>
        /// <param name="attachment">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Attachment Patch(Attachment attachment)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _attachmentCommands.Patch(attachment);
        }
        [HttpDelete]
        [Route("DeleteAndUpdateAttachmentCount")]
        public virtual IList<IdRefLangName> DeleteAndUpdateAttachmentCount(string ids, int statusId, string parentTable, string fieldName)
        {
            _attachmentCommands.ActiveUser = Models.ApiContext.ActiveUser; ;
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
        [HttpGet]
        [Route("GetCostCodeReportByJobId")]
        public Entities.Document.DocumentData GetCostCodeReportByJobId(string jobId)
        {
            List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
            return _attachmentCommands.GetCostCodeReportDocumentByJobId(selectedJobId);
        }

        /// <summary>
        /// GetBOLDocumentByJobId
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetHistoryReportDocumentByJobId")]
        public Entities.Document.DocumentData GetHistoryReportDocumentByJobId(string jobId)
        {
            List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
            return _attachmentCommands.GetHistoryReportDocumentByJobId(selectedJobId);
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
        [Route("IsHistoryPresentForJob")]
        public Entities.Document.DocumentStatus IsHistoryPresentForJob(string jobId)
        {
            List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
            return _attachmentCommands.IsHistoryPresentForJob(selectedJobId);
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