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
//Program Name:                                 Jobs
//Purpose:                                      End point to interact with Jobs module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/Jobs")]
    public class JobsController : ApiController
    {
        private readonly IJobCommands _jobCommands;

        /// <summary>
        /// Function to get Job details
        /// </summary>
        /// <param name="jobCommands"></param>
        public JobsController(IJobCommands jobCommands)

        {
            _jobCommands = jobCommands;
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
        public virtual IQueryable<Job> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the job.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Job Get(long id)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new job object passed as parameter.
        /// </summary>
        /// <param name="job">Refers to job object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Job Post(Job job)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Post(job);
        }

        /// <summary>
        /// Put method is used to update record values completely based on job object passed.
        /// </summary>
        /// <param name="job">Refers to job object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Job Put(Job job)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Put(job);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Delete(id);
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
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on job object passed.
        /// </summary>
        /// <param name="job">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Job Patch(Job job)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Patch(job);
        }
        /// <summary>
        /// Get the job details by Id, If Id is 0 basic details such as Arrival and Delivery, Customer Name from program will be returned
        /// </summary>
        /// <param name="id">Identifier of Job</param>
        /// <param name="parentId">Identifier of Program</param>
        /// <returns>Job details</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("JobByProgram"), ResponseType(typeof(Job))]
        public Job GetJobByProgram(long id, long parentId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJobByProgram(id, parentId);
        }

        /// <summary>
        /// Get the Destination detials by Job Id, if Job id is zero Pickup and delivery information from program
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <param name="parentId">Program Id</param>
        /// <returns>Job Destination details</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("Destination"), ResponseType(typeof(JobDestination))]
        public JobDestination GetJobDestination(long id, long parentId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJobDestination(id, parentId);
        }

        /// <summary>
        /// Get the Origin , Delivery Site POC2 details , Origin and Delivery Address by Job Id and if job id is zero Pickup and Delivery Time Information from Parent will be returned
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <param name="parentId">Program Id</param>
        /// <returns>Site POC 2 and Origin and Delivery Address</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("Poc")]
        public Job2ndPoc GetJob2ndPoc(long id, long parentId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJob2ndPoc(id, parentId);
        }

        /// <summary>
        /// Get the Job Seller and Ship From information by job id and if the job Id is zero, Pickup and Delivery Time Information from Parent will be returned
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <param name="parentId">Program Id</param>
        /// <returns>Returns Job Seller and ShipFrom details</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("Seller"), ResponseType(typeof(JobSeller))]
        public JobSeller GetJobSeller(long id, long parentId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJobSeller(id, parentId);
        }

        /// <summary>
        /// Gets the origin and Delivery address details for supplied Job Id
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <returns>Origin and Destination details</returns>
        ///
        [CustomAuthorize]
        [HttpGet]
        [Route("MapRoute"), ResponseType(typeof(JobMapRoute))]
        public JobMapRoute GetJobMapRoute(long id)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJobMapRoute(id);
        }

        /// <summary>
        /// Get the POD data by Job Id
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <returns>POD data</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("Pod")]
        public JobPod GetJobPod(long id)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetJobPod(id);
        }

        /// <summary>
        /// Update the destination details of a Job by Job Id
        /// </summary>
        /// <param name="jobDestination"></param>
        /// <returns></returns>
		[CustomAuthorize]
        [HttpPut]
        [Route("JobDestination")]
        public JobDestination PutJobDestination(JobDestination jobDestination)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.PutJobDestination(jobDestination);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("Job2ndPoc")]
        public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.PutJob2ndPoc(job2ndPoc);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("JobSeller")]
        public JobSeller PutJobSeller(JobSeller jobSeller)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.PutJobSeller(jobSeller);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("JobMapRoute")]
        public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.PutJobMapRoute(jobMapRoute);
        }

        /// <summary>
        /// Returns the list of Job Site Codes for available for a program. If NULL filter is true the details will be fetched by using job Id else parentId which is program Id
        /// </summary>
        /// <param name="id">Job Id</param>
        /// <param name="parentId">Program Id</param>
        /// <param name="isNullFIlter">if true then job Id is used  else parentId is uesd to filter.</param>
        /// <returns>Site codes list</returns>
		[HttpGet]
        [Route("JobsSiteCodeByProgram"), ResponseType(typeof(JobsSiteCode))]
        public IQueryable<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {
            try
            {
                _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
                return _jobCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
            catch (Exception ex)
            {
                return _jobCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
        }

        /// <summary>
        /// For the supplied job id Gateway, cost and price information will be copied to from program and Job attributes will be filled from program.
        /// </summary>
        /// <param name="jobId">Job Id</param>
        /// <returns>Returns true if its copied else false.</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("UpdateJobAttribute"), ResponseType(typeof(bool))]
        public bool UpdateJobAttributes(long jobId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.UpdateJobAttributes(jobId);
        }

        /// <summary>
        /// A job comment(Job Tracking tab => comment) will be created for the supplied job Id with the title mentioned and once its saved successfully rich text editor also saved for the comment with mentioned gateway comment.
        /// </summary>
        /// <param name="comment">Gateway comment input, Gateway Title is used as comment title and Gateway comment is used in Rich text editor</param>
        /// <returns>Returns true if its saved successfully else false.</returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("Gateway/Comment"), ResponseType(typeof(bool))]
        public bool InsertJobComment(JobComment comment)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.InsertJobComment(comment);
        }

        /// <summary>
        /// A gateway will be created for a job and it will be copied from program by GatewayStatusCode. Job Status code and Job Cargo details will be updated.
        /// </summary>
        /// <param name="jobId">Job Id for which gateway will be added</param>
        /// <param name="gatewayStatusCode">Gateway Status code used to identify gateway from Job</param>
        /// <returns>Returns true if it is inserted scussessfully else false</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("Gateway/InsertJobGateway"), ResponseType(typeof(bool))]
        public bool InsertJobGateway(long jobId, string gatewayStatusCode)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.InsertJobGateway(jobId, gatewayStatusCode);
        }

        /// <summary>
        /// Creates a new Job.
        /// </summary>
        /// <param name="job">The new job will contains these values.</param>
        /// <returns>new job id</returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("CreateJob"), ResponseType(typeof(long))]
        public long CreateJob(Job job)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            Job jobData = _jobCommands.Post(job);
            return jobData != null && jobData.Id > 0 ? jobData.Id : 0;
        }

        /// <summary>
        /// Updates the job with the supplied values.
        /// </summary>
        /// <param name="job">The job will be updated with the values supplied.</param>
        /// <returns>Returns true if it is udated successfully.</returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("UpdateJob"), ResponseType(typeof(bool))]
        public bool UpdateJob(Job job)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            Job jobData = _jobCommands.Put(job);
            return jobData != null && jobData.Id > 0 ? true : false;
        }

        /// <summary>
        /// Get the job details by the job Id
        /// </summary>
        /// <param name="jobId">Job Id</param>
        /// <returns>Returns Job data</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("GetJob"), ResponseType(typeof(Job))]
        public Job GetJob(long jobId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.Get(jobId);
        }

        /// <summary>
        /// If the EDI recods found with the supplied eshHeaderId then new job will be created withe EDI details.
        /// </summary>
        /// <param name="eshHeaderID">Identifier to get the EDI record</param>
        /// <returns>Returns created Job Id if job is created created else 0.</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("CreateJobFromEDI204"), ResponseType(typeof(long))]
        public long CreateJobFromEDI204(long eshHeaderID)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.CreateJobFromEDI204(eshHeaderID);
        }

        /// <summary>
        /// Returns true if user is user is having permission to JobData View else false will be returned
        /// </summary>
        /// <param name="recordId">Job Id</param>
        /// <returns>Returns true if user is user is having permission to JobData View else false will be returned</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("GetIsJobDataViewPermission"), ResponseType(typeof(bool))]
        public bool GetIsJobDataViewPermission(long recordId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetIsJobDataViewPermission(recordId);
        }

        /// <summary>
        /// Multiple order will be created in the system with CSV data. While created each order a check will be performed with Customer Sales order is unique and if the job is created comment also creatd with Notes column in the csv.
        /// </summary>
        /// <param name="jobCSVData">CSV data used to creted multiple orders</param>
        /// <returns>Returns true if the task completed successfully else false.</returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("CreateJobFromCSVImport")]
        public bool CreateJobFromCSVImport(JobCSVData jobCSVData)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            jobCSVData.FileContent = Convert.FromBase64String(jobCSVData.FileContentBase64);
            return _jobCommands.CreateJobFromCSVImport(jobCSVData);
        }

        /// <summary>
        /// Get the list of change history for the job by job id to know what is modified , when and by whom.
        /// </summary>
        /// <param name="jobId">Job Id for which History is fetched.</param>
        /// <returns>List of changes for the Job</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("ChangeHistory")]
        public List<ChangeHistoryData> GetChangeHistory(long jobId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.GetChangeHistory(jobId);
        }

        /// <summary>
        /// Complete the Job, If job exists it will complete particular job. If customer and ProgramId exists all the Jobs under program will be completed.
        /// If Customer Id only exists all the programs under the customer will be completed. Even if customer id is also 0 then all the Jobs in the system will be marked as complete.
        /// Delivery date of the jobs less than the delivery date param will be considered.
        /// </summary>
        /// <param name="custId">Customer Id</param>
        /// <param name="programId">Program id</param>
        /// <param name="jobId">job Id</param>
        /// <param name="deliveryDate">Delivery Date of the job less than this date</param>
        /// <param name="includeNullableDeliveryDate">If true the consider the jobs with NULL delivery date</param>
        /// <returns>Returns the count of the jobs marked as completed.</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("CompleteJob")]
        public int UpdateJobCompleted(long custId, long programId, long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.UpdateJobCompleted(custId, programId, jobId, deliveryDate, includeNullableDeliveryDate, _jobCommands.ActiveUser);
        }

        /// <summary>
        /// Returns the list of the non completed Jobs by program Id
        /// </summary>
        /// <param name="programId">program id</param>
        /// <returns>List of non completed jobs</returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("ActiveJobsByProramId")]
        public List<Entities.Job.Job> GetActiveJobByProgramId(long programId)
        {
            return _jobCommands.GetActiveJobByProgramId(programId);
        }

        /// <summary>
        /// Update the Invoice Details(Sales/Purchase Order Invoice number for the job)
        /// </summary>
        /// <param name="jobInvoiceDetail">jobInvoiceDetail(This contains the JobSalesInvoiceNumber and JobPurchaseInvoiceNumber)</param>
        /// <param name="jobId">jobId</param>
        /// <returns>true if job updated successfully else false.</returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("UpdateJobInvoiceDetail")]
        public bool UpdateJobInvoiceDetail(JobInvoiceDetail jobInvoiceDetail, long jobId)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.UpdateJobInvoiceDetail(jobId, jobInvoiceDetail);
		}

		/// <summary>
		/// Cancel a Existing Order From Meridian System
		/// </summary>
		/// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
		/// <returns>API returns a Status Model object which contains the details about success or failure, in case of failure AdditionalDetail property contains the reson of failure.</returns>
		[HttpPost]
		[Route("CancelOrder"), ResponseType(typeof(StatusModel))]
		public StatusModel CancelOrder(string orderNumber)
		{
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.CancelJobByOrderNumber(orderNumber);
		}

        /// <summary>
        /// Uncancel an existing Order from Meridian System
        /// </summary>
        /// <param name="orderNumber"></param>
        /// <returns>API returns a Status Model object which contains the details about success or failure, in case of failure AdditionalDetail property contains the reson of failure.</returns>
        [HttpPost]
        [Route("UnCancelOrder"), ResponseType(typeof(StatusModel))]
        public StatusModel UnCancelOrder(string orderNumber)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.UnCancelJobByOrderNumber(orderNumber);
        }

        /// <summary>
        /// Reschedule a Existing Order From Meridian System
        /// </summary>
        /// <param name="jobRescheduleDetail">jobRescheduleDetail</param>
        /// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
        /// <returns>API returns a Status Model object which contains the details about success or failure, in case of failure AdditionalDetail property contains the reson of failure.</returns>
        [HttpPost]
		[Route("RescheduleOrder"), ResponseType(typeof(StatusModel))]
		public StatusModel RescheduleJobByOrderNumber(JobRescheduleDetail jobRescheduleDetail, string orderNumber)
		{
			_jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
			SysSetting sysSetting = UpdateActiveUserSettings();
			return _jobCommands.RescheduleJobByOrderNumber(jobRescheduleDetail, orderNumber, sysSetting);
		}

        /// <summary>
		/// Reschedule a Existing Order From Meridian System
		/// </summary>
		/// <param name="driverContact">driverContact</param>
		/// <returns>API returns a Status Model object which contains the details about success or failure, in case of failure AdditionalDetail property contains the reson of failure.</returns>
		[HttpPost]
        [Route("AddDriver"), ResponseType(typeof(StatusModel))]
        public StatusModel AddDriver(DriverContact driverContact)
        {
            _jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCommands.AddDriver(driverContact);
        }

        /// <summary>
        /// Return the location cordinates for a Order from Meridian System
        /// </summary>
        /// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
        /// <returns>API returns a Model object which contains the details about success or failure with Latitude and Longitude, in case of failure AdditionalDetail property contains the reson of failure.</returns>
        [HttpGet]
		[Route("LocationCoordinate"), ResponseType(typeof(OrderLocationCoordinate))]
		public OrderLocationCoordinate LocationCoordinate(string orderNumber)
		{
			_jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _jobCommands.GetOrderLocationCoordinate(orderNumber);
		}

		/// <summary>
		/// Return the current status of a Order from Meridian System
		/// </summary>
		/// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
		/// <returns>API returns a Model object which contains the details about success or failure with Order Status, in case of failure AdditionalDetail property contains the reson of failure.</returns>
		[HttpGet]
		[Route("OrderStatus"), ResponseType(typeof(OrderStatusModel))]
		public OrderStatusModel GetOrderStatus(string orderNumber)
		{
			_jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _jobCommands.GetOrderStatus(orderNumber);
		}

		/// <summary>
		/// Update the special instructions for a Order in Meridian System
		/// </summary>
		/// <param name="jobSpecialInstruction">jobSpecialInstruction contains a string where instructions needs to pass.</param>
		/// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
		/// <returns>API returns a Model object which contains the details about success or failure with Order Status, in case of failure AdditionalDetail property contains the reson of failure.</returns>
		[HttpPost]
		[Route("specialInstruction"), ResponseType(typeof(StatusModel))]
		public StatusModel InsertOrderSpecialInstruction(JobSpecialInstruction jobSpecialInstruction, string orderNumber)
		{
			_jobCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _jobCommands.InsertOrderSpecialInstruction(jobSpecialInstruction, orderNumber);
		}

		protected SysSetting UpdateActiveUserSettings()
		{
			M4PL.Business.Common.CommonCommands.ActiveUser = Models.ApiContext.ActiveUser;
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