/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Jobs
//Purpose:                                      End point to interact with Jobs module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Jobs")]
    public class JobsController : BaseApiController<Job>
    {
        private readonly IJobCommands _jobCommands;

        /// <summary>
        /// Function to get Job details
        /// </summary>
        /// <param name="jobCommands"></param>
        public JobsController(IJobCommands jobCommands)
            : base(jobCommands)
        {
            _jobCommands = jobCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("JobByProgram")]
        public Job GetJobByProgram(long id, long parentId)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJobByProgram(id, parentId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("Destination")]
        public JobDestination GetJobDestination(long id, long parentId)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJobDestination(id, parentId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("Poc")]
        public Job2ndPoc GetJob2ndPoc(long id, long parentId)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJob2ndPoc(id, parentId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("Seller")]
        public JobSeller GetJobSeller(long id, long parentId)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJobSeller(id, parentId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("MapRoute")]
        public JobMapRoute GetJobMapRoute(long id)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJobMapRoute(id);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("Pod")]
        public JobPod GetJobPod(long id)
        {
            _jobCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetJobPod(id);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("JobDestination")]
        public JobDestination PutJobDestination(JobDestination jobDestination)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.PutJobDestination(jobDestination);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("Job2ndPoc")]
        public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.PutJob2ndPoc(job2ndPoc);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("JobSeller")]
        public JobSeller PutJobSeller(JobSeller jobSeller)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.PutJobSeller(jobSeller);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("JobMapRoute")]
        public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.PutJobMapRoute(jobMapRoute);
        }

        [HttpGet]
        [Route("JobsSiteCodeByProgram")]
        public IQueryable<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {
            try
            {
                BaseCommands.ActiveUser = ActiveUser;
                return _jobCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
            catch (Exception ex)
            {
                return _jobCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("UpdateJobAttribute")]
        public bool UpdateJobAttributes(long jobId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.UpdateJobAttributes(jobId);
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("Gateway/Comment")]
        public bool InsertJobComment(JobComment comment)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.InsertJobComment(comment);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("Gateway/InsertJobGateway")]
        public bool InsertJobGateway(long jobId, string gatewayStatusCode)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.InsertJobGateway(jobId, gatewayStatusCode);
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("CreateJob")]
        public long CreateJob(Job job)
        {
            BaseCommands.ActiveUser = ActiveUser;
            Job jobData = _jobCommands.Post(job);
            return jobData != null && jobData.Id > 0 ? jobData.Id : 0;
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("UpdateJob")]
        public bool UpdateJob(Job job)
        {
            BaseCommands.ActiveUser = ActiveUser;
            Job jobData = _jobCommands.Put(job);
            return jobData != null && jobData.Id > 0 ? true : false;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetJob")]
        public Job GetJob(long jobId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.Get(jobId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("CreateJobFromEDI204")]
        public long CreateJobFromEDI204(long eshHeaderID)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.CreateJobFromEDI204(eshHeaderID);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetIsJobDataViewPermission")]
        public bool GetIsJobDataViewPermission(long recordId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetIsJobDataViewPermission(recordId);
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("CreateJobFromCSVImport")]
        public bool CreateJobFromCSVImport(JobCSVData jobCSVData)
        {
            BaseCommands.ActiveUser = ActiveUser;
            jobCSVData.FileContent = Convert.FromBase64String(jobCSVData.FileContentBase64);
            return _jobCommands.CreateJobFromCSVImport(jobCSVData);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("ChangeHistory")]
        public List<ChangeHistoryData> GetChangeHistory(long jobId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.GetChangeHistory(jobId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("CompleteJob")]
        public int UpdateJobCompleted(long custId, long programId, long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobCommands.UpdateJobCompleted(custId,programId, jobId, deliveryDate, includeNullableDeliveryDate, BaseCommands.ActiveUser);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("ActiveJobsByProramId")]
        public List<Entities.Job.Job> GetActiveJobByProgramId(long programId)
        {
            return _jobCommands.GetActiveJobByProgramId(programId);
        }
    }
}