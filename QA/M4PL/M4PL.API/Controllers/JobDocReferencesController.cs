/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobDocReference
//Purpose:                                      End point to interact with JobDocReference module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Web.Http;


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

        [HttpPost]
        [Route("InsertJobDocument")]
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