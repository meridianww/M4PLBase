/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobDocReferenceCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.JobDocReferenceCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobDocReferenceCommands;
using _attachmentCommands = M4PL.DataAccess.Attachment.AttachmentCommands;
using _commonCommands = M4PL.DataAccess.Common.CommonCommands;
using System;
using M4PL.Entities.Administration;
using System.Linq;
using M4PL.Entities;

namespace M4PL.Business.Job
{
    public class JobDocReferenceCommands : BaseCommands<JobDocReference>, IJobDocReferenceCommands
    {
        /// <summary>
        /// Get list of job reference data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobDocReference> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobDocReference Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        public JobDocReference Post(JobDocReference jobDocReference)
        {
            return _commands.Post(ActiveUser, jobDocReference);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        public JobDocReference PostWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            return _commands.PostWithSettings(ActiveUser, userSysSetting, jobDocReference);
        }

		public StatusModel InsertJobDocumentData(JobDocumentAttachment jobDocumentAttachment, long jobId, string documentType)
		{
			StatusModel result = new StatusModel();
			List<SystemReference> systemOptionList = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
			SystemReference documentOption = systemOptionList?.Where(x => x.SysLookupCode.Equals("JobDocReferenceType", StringComparison.OrdinalIgnoreCase) && x.SysOptionName.Equals(documentType, StringComparison.OrdinalIgnoreCase))?.FirstOrDefault();
			if(documentOption == null)
			{
				return new StatusModel()
				{
					StatusCode = (int)System.Net.HttpStatusCode.ExpectationFailed,
					Status = "Failure",
					AdditionalDetail = "Passed document type is not a valid one."
				};
			}

			JobDocReference documentReference = new JobDocReference()
			{
				JobID = jobId,
				JdrCode = jobDocumentAttachment.DocumentCode,
				JdrTitle = jobDocumentAttachment.DocumentTitle,
				DocTypeId = documentOption.Id,
				StatusId = 1,
				EnteredBy = ActiveUser.UserName,
				DateEntered = DateTime.UtcNow
			};

			JobDocReference docReferenceResult = _commands.Post(ActiveUser, documentReference);
			if (docReferenceResult?.Id > 0 && jobDocumentAttachment.AttchmentData?.Count > 0)
			{
				Entities.Attachment attachment = null;
				foreach (var attachmentData in jobDocumentAttachment.AttchmentData)
				{
					attachment = new Entities.Attachment()
					{
						AttTableName = Entities.EntitiesAlias.JobDocReference.ToString(),
						AttPrimaryRecordID = docReferenceResult?.Id,
						AttTitle = attachmentData.AttachmentTitle,
						AttFileName = attachmentData.AttchmentName,
						AttTypeId = 1,
						StatusId = 1,
						DateEntered = DateTime.UtcNow,
						EnteredBy = ActiveUser.UserName
					};

					var attachmentResult =  _attachmentCommands.Post(ActiveUser, attachment);
					if (attachmentResult?.Id > 0)
					{
						ByteArray byteArray = new ByteArray()
						{
							Bytes = attachmentData.AttachmentData,
							DocumentText = null,
							Entity = EntitiesAlias.Attachment,
							FieldName = "AttData",
							FileName = null,
							Id = attachmentResult.Id,
							IsPopup = false,
							Type = SQLDataTypes.varbinary
						};

						_commonCommands.SaveBytes(byteArray, ActiveUser);
					}
				}
			}
			else if(docReferenceResult?.Id > 0 && jobDocumentAttachment.AttchmentData?.Count == 0)
			{
				result.StatusCode = (int)System.Net.HttpStatusCode.Created;
				result.Status = "Success";
				result.AdditionalDetail = "Document has been created but there are no attachment found in the request.";
			}
			else if(docReferenceResult?.Id <= 0)
			{
				result.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
				result.Status = "Failure";
				result.AdditionalDetail = "Document has been created but there are no attachment found in the request.";
			}

			if (string.IsNullOrEmpty(result.Status))
			{
				result.StatusCode = (int)System.Net.HttpStatusCode.OK;
				result.Status = "Success";
			}

			return result;
		}

		/// <summary>
		/// Updates an existing job reference record
		/// </summary>
		/// <param name="jobDocReference"></param>
		/// <returns></returns>

		public JobDocReference Put(JobDocReference jobDocReference)
        {
            return _commands.Put(ActiveUser, jobDocReference);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        public JobDocReference PutWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            return _commands.PutWithSettings(ActiveUser, userSysSetting, jobDocReference);
        }

        /// <summary>
        /// Deletes a specific job reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job reference record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<JobDocReference> Get()
        {
            throw new NotImplementedException();
        }

		public JobDocReference Patch(JobDocReference entity)
		{
			throw new NotImplementedException();
		}
	}
}