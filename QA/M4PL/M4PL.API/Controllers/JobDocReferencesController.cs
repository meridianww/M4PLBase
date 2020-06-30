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

using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobDocReferences")]
    public class JobDocReferencesController : BaseApiController<JobDocReference>
    {
        private readonly IJobDocReferenceCommands _jobDocReferenceCommands;

        /// <summary>
        /// Function to get Job's Document Reference details
        /// </summary>
        /// <param name="jobDocReferenceCommands"></param>
        public JobDocReferencesController(IJobDocReferenceCommands jobDocReferenceCommands)
            : base(jobDocReferenceCommands)
        {
            _jobDocReferenceCommands = jobDocReferenceCommands;
        }

        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("SettingPost")]
        public JobDocReference SettingPost(JobDocReference jobDocReference)
        {
            _jobDocReferenceCommands.ActiveUser = ActiveUser;
            return _jobDocReferenceCommands.PostWithSettings(UpdateActiveUserSettings(), jobDocReference);
        }

        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>
        [HttpPut]
        [Route("SettingPut")]
        public JobDocReference SettingPut(JobDocReference jobDocReference)
        {
            _jobDocReferenceCommands.ActiveUser = ActiveUser;
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
            _jobDocReferenceCommands.ActiveUser = ActiveUser;
            return _jobDocReferenceCommands.InsertJobDocumentData(jobDocumentAttachment, jobId, documentType);
        }

        [HttpGet]
        [Route("GetNextSequence")]
        public long GetNextSequence()
        {
            _jobDocReferenceCommands.ActiveUser = ActiveUser;
            return _jobDocReferenceCommands.GetNextSequence();
        }


    }
}