#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobDocReferenceCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.JobDocReferenceCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using _attachmentCommands = M4PL.DataAccess.Attachment.AttachmentCommands;
using _commands = M4PL.DataAccess.Job.JobDocReferenceCommands;
using _commonCommands = M4PL.DataAccess.Common.CommonCommands;

namespace M4PL.Business.Job
{
	public class JobDocReferenceCommands : BaseCommands<JobDocReference>, IJobDocReferenceCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

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
			JobDocReference docReference = _commands.PostWithSettings(ActiveUser, userSysSetting, jobDocReference);
			if (docReference != null && docReference.Id > 0)
			{
				List<SystemReference> systemOptionList = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
				SystemReference documentOption = systemOptionList?.Where(x => x.SysLookupCode.Equals("JobDocReferenceType", StringComparison.OrdinalIgnoreCase) && x.SysOptionName.Equals("POD", StringComparison.OrdinalIgnoreCase))?.FirstOrDefault();
				if (jobDocReference.DocTypeId == documentOption.Id)
				{
					var jobDetails = DataAccess.Job.JobCommands.GetJobByProgram(ActiveUser, jobDocReference.JobID.ToLong(), 0);
					if (jobDetails != null && jobDetails.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() && !string.IsNullOrEmpty(jobDetails.JobGatewayStatus) && jobDetails.JobGatewayStatus.Equals("Delivered", StringComparison.OrdinalIgnoreCase))
					{
						JobGatewayCommands jobGatewayCommands = new JobGatewayCommands();
						jobGatewayCommands.ActiveUser = ActiveUser;
						var jobGatewayInfo = jobGatewayCommands.GetGatewayWithParent(0, jobDocReference.JobID.ToLong(), "Gateway", false, "POD Completion");
						if (jobGatewayInfo != null)
						{
							var updatedGateway = jobGatewayCommands.PostWithSettings(UpdateActiveUserSettings(), jobGatewayInfo);
						}
					}
				}
			}

			return docReference;
		}

		public StatusModel InsertJobDocumentData(JobDocumentAttachment jobDocumentAttachment, long jobId, string documentType)
		{
			StatusModel result = new StatusModel();
			string docType = string.Empty;
			List<SystemReference> systemOptionList = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
			SystemReference documentOption = systemOptionList?.Where(x => x.SysLookupCode.Equals("JobDocReferenceType", StringComparison.OrdinalIgnoreCase) && x.SysOptionName.Equals(documentType, StringComparison.OrdinalIgnoreCase))?.FirstOrDefault();
			SystemReference documentPODOption = systemOptionList?.Where(x => x.SysLookupCode.Equals("JobDocReferenceType", StringComparison.OrdinalIgnoreCase) && x.SysOptionName.Equals("POD", StringComparison.OrdinalIgnoreCase))?.FirstOrDefault();
			if (documentOption == null)
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
				JdrAttachment = jobDocumentAttachment.AttchmentData != null ? jobDocumentAttachment.AttchmentData.Count : 0,
				EnteredBy = ActiveUser.UserName,
				DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
				Id = _commands.GetNextSequence()
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
						DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
						EnteredBy = ActiveUser.UserName
					};

					var attachmentResult = _attachmentCommands.Post(ActiveUser, attachment);
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
			else if (docReferenceResult?.Id > 0 && jobDocumentAttachment.AttchmentData?.Count == 0)
			{
				try
				{
					if (documentPODOption.Id == documentOption.Id)
					{
						var jobDetails = DataAccess.Job.JobCommands.GetJobByProgram(ActiveUser, jobId, 0);
						if (jobDetails != null && jobDetails.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() && !string.IsNullOrEmpty(jobDetails.JobGatewayStatus) && jobDetails.JobGatewayStatus.Equals("Delivered", StringComparison.OrdinalIgnoreCase))
						{
							JobGatewayCommands jobGatewayCommands = new JobGatewayCommands();
							jobGatewayCommands.ActiveUser = ActiveUser;
							var jobGatewayInfo = jobGatewayCommands.GetGatewayWithParent(0, jobId, "Gateway", false, "POD Completion");
							if (jobGatewayInfo != null)
							{
								var updatedGateway = jobGatewayCommands.PostWithSettings(UpdateActiveUserSettings(), jobGatewayInfo);
							}
						}
					}
				}
				catch (Exception exp)
				{
					DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while Adding a document for Job.", "Cancel  Order", Utilities.Logger.LogType.Error);
				}

				result.StatusCode = (int)System.Net.HttpStatusCode.Created;
				result.Status = "Success";
				result.AdditionalDetail = "Document has been created but there are no attachment found in the request.";
			}
			else if (docReferenceResult?.Id <= 0)
			{
				result.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
				result.Status = "Failure";
				result.AdditionalDetail = "There is some issue issue while creating the document in the system.";
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

		public JobDocReference Patch(JobDocReference entity)
		{
			throw new NotImplementedException();
		}

		public long GetNextSequence()
		{
			return _commands.GetNextSequence();
		}

		protected SysSetting UpdateActiveUserSettings()
		{
			SysSetting userSysSetting = M4PL.Business.Common.CommonCommands.GetUserSysSettings();
			IList<RefSetting> refSettings = JsonConvert.DeserializeObject<IList<RefSetting>>(M4PL.Business.Common.CommonCommands.GetSystemSettings().SysJsonSetting);
			if (!string.IsNullOrEmpty(userSysSetting.SysJsonSetting) && (userSysSetting.Settings == null || !userSysSetting.Settings.Any()))
				userSysSetting.Settings = JsonConvert.DeserializeObject<IList<RefSetting>>(userSysSetting.SysJsonSetting);
			else
				userSysSetting.Settings = new List<RefSetting>();
			userSysSetting.SysJsonSetting = string.Empty; // To save storage in cache as going to use only Model not json.
			foreach (var setting in refSettings)
			{
				if (!setting.IsSysAdmin)
				{
					var userSetting = userSysSetting.Settings.FirstOrDefault(s => s.Name.Equals(setting.Name) && s.Entity == setting.Entity && s.Value.Equals(setting.Value));
					if (userSetting == null)
					{
						userSysSetting.Settings.Add(new RefSetting { Entity = setting.Entity, Name = setting.Name, Value = setting.Value });
						continue;
					}
					if (string.IsNullOrEmpty(userSetting.Value) || !setting.IsOverWritable)
						userSetting.Value = setting.Value;
				}
			}

			return userSysSetting;
		}
	}
}