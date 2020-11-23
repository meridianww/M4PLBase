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
//Program Name:                                 JobDocReference
//Purpose:                                      End point to interact with JobDocReference module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;
using _commonCommands = M4PL.Business.Common.CommonCommands;
namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Job Document Reference
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/JobDocReferences")]
	public class JobDocReferencesController : ApiController
	{
		private readonly IJobDocReferenceCommands _jobDocReferenceCommands;

		/// <summary>
		/// Function to get Job's Document Reference details
		/// </summary>
		/// <param name="jobDocReferenceCommands"></param>
		public JobDocReferencesController(IJobDocReferenceCommands jobDocReferenceCommands)
			
		{
			_jobDocReferenceCommands = jobDocReferenceCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobDocReference> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobDocReference.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobDocReference Get(long id)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobDocReference object passed as parameter.
        /// </summary>
        /// <param name="jobDocReference">Refers to jobDocReference object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobDocReference Post(JobDocReference jobDocReference)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Post(jobDocReference);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobDocReference object passed.
        /// </summary>
        /// <param name="jobDocReference">Refers to jobDocReference object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobDocReference Put(JobDocReference jobDocReference)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Put(jobDocReference);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Delete(id);
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
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobDocReference object passed.
        /// </summary>
        /// <param name="jobDocReference">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobDocReference Patch(JobDocReference jobDocReference)
        {
            _jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.Patch(jobDocReference);
        }
        /// <summary>
        /// SettingPost method is used to add document type settings for Job documents for system logged in user.
        /// </summary>
        /// <param name="jobDocReference">
        /// This prameter require document details like JobId,ItemNumber,Title etc.
        /// </param>
        /// <returns>
        /// Returns response as JobDocReference object with new settings.
        /// </returns>
        [HttpPost]
		[Route("SettingPost")]
		public JobDocReference SettingPost(JobDocReference jobDocReference)
		{
			_jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.PostWithSettings(UpdateActiveUserSettings(), jobDocReference);
		}

        /// <summary>
        /// SettingPut method is used to update document type settings for Job documents for system logged in user.
        /// </summary>
        /// <param name="jobDocReference">
        /// This prameter require Document details like JobId,ItemNumber,Title etc.
        /// </param>
        /// <returns>
        /// Returns response as JobDocReference object with updated settings.
        /// </returns>
        [HttpPut]
		[Route("SettingPut")]
		public JobDocReference SettingPut(JobDocReference jobDocReference)
		{
			_jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.PutWithSettings(UpdateActiveUserSettings(), jobDocReference);
		}

		/// <summary>
		/// This API is used to save the documents with respect to a Job. As per business logic there should be a document code present in the request,
		/// if document code is contains POD then application will contains the document type as POD, if code is contains DAM then API consider the document
		/// type as Damaged, if code contains signature then document type will be signature otherwise by default document type will be considered as Image.
		/// </summary>
		/// <param name="jobDocumentAttachment">Request parameter where consumer needs to pass the details related to document like attachment byte array code,
		/// name title etc.
		/// </param>
		/// <param name="jobId">Request parameter refer to the M4PL JobId.</param>
		/// <param name="documentType">documentType</param>
		/// <returns>API response json contains the status and other related information, if status is Success and AdditionalDetail property is
		/// blank it means request processed successfully without any issue else status will be error and failure details will be provided under property
		/// AdditionalDetail.</returns>
		[HttpPost]
		[Route("InsertJobDocument"), ResponseType(typeof(StatusModel))]
		public StatusModel InsertJobDocumentData(JobDocumentAttachment jobDocumentAttachment, long jobId, string documentType)
		{
			_jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.InsertJobDocumentData(jobDocumentAttachment, jobId, documentType);
		}
        /// <summary>
		/// GetNextSequence method is used to get next sequence for documents that can be added with respect to Order/Job. 
		/// </summary>
		/// <returns>Returns next sequence(numeric)
        /// </returns>
		[HttpGet]
		[Route("GetNextSequence")]
		public long GetNextSequence()
		{
			_jobDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobDocReferenceCommands.GetNextSequence();
		}
        /// <summary>
        /// Updates Current Active User Setting
        /// </summary>
        /// <returns></returns>
        protected SysSetting UpdateActiveUserSettings()
        {
            _commonCommands.ActiveUser = Models.ApiContext.ActiveUser;
            SysSetting userSysSetting = _commonCommands.GetUserSysSettings();
            IList<RefSetting> refSettings = JsonConvert.DeserializeObject<IList<RefSetting>>(_commonCommands.GetSystemSettings().SysJsonSetting);
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