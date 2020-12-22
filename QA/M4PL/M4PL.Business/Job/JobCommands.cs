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
// Program Name:                                 JobCommands
// Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Job.JobCommands
//====================================================================================================================

using M4PL.Business.Event;
using M4PL.Business.XCBL.HelperClasses;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.FarEye;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Job.JobCommands;

namespace M4PL.Business.Job
{
	public class JobCommands : BaseCommands<Entities.Job.Job>, IJobCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		/// <summary>
		/// Get list of job data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Job.Job> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific job record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>
		public Entities.Job.Job Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new job record
		/// </summary>
		/// <param name="job"></param>
		/// <returns></returns>
		public Entities.Job.Job Post(Entities.Job.Job job)
		{
			long customerId = M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong();
			bool isUpdateRequired = customerId == job.CustomerId ? false : true;
			return _commands.Post(ActiveUser, job, isUpdateRequired, isManualUpdate: true);
		}

		/// <summary>
		/// Updates an existing job record
		/// </summary>
		/// <param name="job"></param>
		/// <returns></returns>
		public Entities.Job.Job Put(Entities.Job.Job job)
		{
			ActiveUser activeUser = ActiveUser;
			long customerId = M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong();
			bool isUpdateRequired = customerId == job.CustomerId ? false : true;
			Entities.Job.Job jobResult = _commands.Put(activeUser, job, isRelatedAttributeUpdate: isUpdateRequired, isServiceCall: false, customerId: customerId, isManualUpdate: true);
			if (jobResult != null && jobResult.JobCompleted && job.JobDeliveryDateTimeActual.HasValue && job.JobOriginDateTimeActual.HasValue)
			{
				Task.Run(() =>
				{
					bool isDeliveryChargeRemovalRequired = false;
					if (!string.IsNullOrEmpty(jobResult.JobSONumber) || !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
					{
						isDeliveryChargeRemovalRequired = false;
					}
					else
					{
						isDeliveryChargeRemovalRequired = _commands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					}

					if (isDeliveryChargeRemovalRequired)
					{
						_commands.UpdateJobPriceOrCostCodeStatus(job.Id, (int)StatusType.Delete, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					}

					try
					{
						CustomerNavConfiguration currentCustomerNavConfiguration = null;
						string navAPIPassword;
						string navAPIUserName;
						string navAPIUrl;
						if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
						{
							currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
							navAPIUrl = currentCustomerNavConfiguration.ServiceUrl;
							navAPIUserName = currentCustomerNavConfiguration.ServiceUserName;
							navAPIPassword = currentCustomerNavConfiguration.ServicePassword;
						}
						else
						{
							navAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
							navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
							navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
						}

						JobRollupHelper.StartJobRollUpProcess(jobResult, activeUser, navAPIUrl, navAPIUserName, navAPIPassword);
					}
					catch (Exception exp)
					{
						DataAccess.Logger.ErrorLogger.Log(exp, "Error while creating Order in NAV after job Completion.", "StartJobRollUpProcess", Utilities.Logger.LogType.Error);
					}

					if (isDeliveryChargeRemovalRequired)
					{
						_commands.UpdateJobPriceOrCostCodeStatus(job.Id, (int)StatusType.Active, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					}
				});
			}

			return jobResult;
		}

		/// <summary>
		/// Deletes a specific job record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>
		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of job record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>
		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public JobDestination GetJobDestination(long id, long parentId)
		{
			return _commands.GetJobDestination(ActiveUser, id, parentId);
		}

		public JobContact GetJobContact(long id, long parentId)
		{
			return _commands.GetJobContact(ActiveUser, id, parentId);
		}

		public Job2ndPoc GetJob2ndPoc(long id, long parentId)
		{
			return _commands.GetJob2ndPoc(ActiveUser, id, parentId);
		}

		public JobSeller GetJobSeller(long id, long parentId)
		{
			return _commands.GetJobSeller(ActiveUser, id, parentId);
		}

		public JobSeller UpdateJobAttributes(long id, long parentId)
		{
			return _commands.GetJobSeller(ActiveUser, id, parentId);
		}

		public JobMapRoute GetJobMapRoute(long id)
		{
			return _commands.GetJobMapRoute(ActiveUser, id);
		}

		public JobPod GetJobPod(long id)
		{
			return _commands.GetJobPod(ActiveUser, id);
		}

		public JobDestination PutJobDestination(JobDestination jobDestination)
		{
			return _commands.PutJobDestination(ActiveUser, jobDestination);
		}

		public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
		{
			return _commands.PutJob2ndPoc(ActiveUser, job2ndPoc);
		}

		public JobSeller PutJobSeller(JobSeller jobSeller)
		{
			return _commands.PutJobSeller(ActiveUser, jobSeller);
		}

		public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
		{
			return _commands.PutJobMapRoute(ActiveUser, jobMapRoute);
		}

		public Entities.Job.Job GetJobByProgram(long id, long parentId)
		{
			return _commands.GetJobByProgram(ActiveUser, id, parentId);
		}

		public Entities.Job.Job Patch(Entities.Job.Job entity)
		{
			throw new NotImplementedException();
		}

		public IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
		{
			return _commands.GetJobsSiteCodeByProgram(ActiveUser, id, parentId, isNullFIlter);
		}

		public bool GetIsJobDataViewPermission(long recordId)
		{
			var permittedProgramEntity = _commands.GetCustomEntityIdByEntityName(ActiveUser, EntitiesAlias.Program, true);
			if (permittedProgramEntity == null) return false;
			return permittedProgramEntity.Any(t => t.EntityId == -1 || t.EntityId == recordId);
		}

		public bool UpdateJobAttributes(long jobId)
		{
			return _commands.UpdateJobAttributes(ActiveUser, jobId);
		}

		public bool InsertJobComment(JobComment comment)
		{
			return _commands.InsertJobComment(ActiveUser, comment);
		}

		public bool InsertJobGateway(long jobId, string gatewayStatusCode)
		{
			bool result = _commands.InsertJobGateway(ActiveUser, jobId, gatewayStatusCode);
			if (result)
			{
				bool isFarEyePushRequired = DataAccess.XCBL.XCBLCommands.InsertDeliveryUpdateProcessingLog(jobId, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				if (isFarEyePushRequired)
				{
					FarEyeHelper.PushStatusUpdateToFarEye(jobId, ActiveUser);
				}
			}

			return result;
		}

		public long CreateJobFromEDI204(long eshHeaderID)
		{
			return _commands.CreateJobFromEDI204(ActiveUser, eshHeaderID);
		}

		public bool CreateJobFromCSVImport(JobCSVData jobCSVData)
		{
			bool result = true;
			if (jobCSVData != null && jobCSVData.ProgramId > 0 && jobCSVData.FileContent != null)
			{
				using (DataTable tblCSVInfo = CSVParser.GetDataTableForCSVByteArray(jobCSVData.FileContent))
				{
					if (tblCSVInfo != null && tblCSVInfo.Rows.Count > 0)
					{
						List<BatchJobDetail> batchJobDetailsList = new List<BatchJobDetail>();
						batchJobDetailsList = Extension.ConvertDataTableToModel<BatchJobDetail>(tblCSVInfo);
						if (batchJobDetailsList != null && batchJobDetailsList.Count > 0)
						{
							result = GenerateOrderFromCSV(batchJobDetailsList, jobCSVData.ProgramId);
						}
					}
				}
			}

			return result;
		}

		public List<ChangeHistoryData> GetChangeHistory(long jobId)
		{
			return _commands.GetJobChangeHistory(jobId, ActiveUser);
		}

		public bool UpdateJobInvoiceDetail(JobInvoiceData jobInvoiceData)
		{
			bool result = false;
			if (jobInvoiceData?.JobId > 0)
			{
				var existingJobDetails = _commands.GetJobByProgram(ActiveUser, jobInvoiceData.JobId, 0);
				if (existingJobDetails?.Id > 0)
				{
					existingJobDetails.JobInvoicedDate = jobInvoiceData.InvoicedDate;
					existingJobDetails.JobIsDirtyDestination = false;
					existingJobDetails.JobIsDirtyContact = false;
					var updatedJobDetails = _commands.Put(ActiveUser, existingJobDetails, false, true, true, isManualUpdate: true);
					result = updatedJobDetails?.Id > 0 ? true : false;
				}

				if (result && jobInvoiceData.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() && jobInvoiceData.IsCustomerUpdateRequired)
				{
					var deliveryUpdateModel = DataAccess.XCBL.XCBLCommands.GetDeliveryUpdateModel(jobInvoiceData.JobId, ActiveUser);
					if (deliveryUpdateModel != null)
					{
						ElectroluxHelper.SendDeliveryUpdateRequestToElectrolux(ActiveUser, deliveryUpdateModel, jobInvoiceData.JobId);
					}
				}
			}

			return result;
		}

		private bool GenerateOrderFromCSV(List<BatchJobDetail> batchJobDetails, long jobProgramId)
		{
			int noOfThreads = 10;
			List<BatchJobDetail> processData = new List<BatchJobDetail>();
			if (batchJobDetails != null && batchJobDetails.Count > 0)
			{
				int totalCount = batchJobDetails.Count;
				if (totalCount < noOfThreads)
				{
					noOfThreads = totalCount;
				}

				int noOfOrdersPerThread = totalCount / noOfThreads;
				for (int i = 0; i < noOfThreads; i++)
				{
					processData = i == noOfThreads - 1 ? batchJobDetails.Skip(i * noOfOrdersPerThread).ToList() :
						batchJobDetails.Skip(i * noOfOrdersPerThread).Take(noOfOrdersPerThread).ToList();
					if (processData.Count > 0)
					{
						var data = processData;
						var newThread = new Thread(() => _commands.CreateJobInDatabase(data, jobProgramId, ActiveUser));
						newThread.Start();
						Thread.Sleep(1000);
					}
				}
			}

			return true;
		}

		public int UpdateJobCompleted(long custId, long programId, long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate, ActiveUser activeUser)
		{
			return _commands.UpdateJobCompleted(custId, programId, jobId, deliveryDate, includeNullableDeliveryDate, ActiveUser);
		}

		public List<Entities.Job.Job> GetActiveJobByProgramId(long programId)
		{
			return _commands.GetActiveJobByProgramId(programId);
		}

		public bool UpdateJobInvoiceDetail(long jobId, JobInvoiceDetail jobInvoiceDetail)
		{
			return _commands.UpdateJobInvoiceDetail(jobId, jobInvoiceDetail, ActiveUser);
		}

		public StatusModel CancelJobByOrderNumber(string orderNumber, string cancelComment, string cancelReason)
		{
			if (string.IsNullOrEmpty(orderNumber))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number can not be empty while calling the cancellation service, please pass a order number."
				};
			}

			try
			{
				Entities.Job.Job jobDetail = _commands.GetJobByCustomerSalesOrder(ActiveUser, orderNumber, 0);

				if (jobDetail == null || jobDetail?.Id <= 0)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is not exist in Meridian System, please pass a valid order number."
					};
				}
				else if (jobDetail?.Id > 0 && jobDetail.JobCompleted)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is already completed in Meridian System, please contact to Meridian support team for any further action."
					};
				}
				else if (jobDetail?.Id > 0 && jobDetail.IsCancelled.HasValue && jobDetail.IsCancelled.Value)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is already cancelled in Meridian System, please contact to Meridian support team for any further action."
					};
				}

				long gatewayId = _commands.CancelJobByCustomerSalesOrderNumber(ActiveUser, jobDetail, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), cancelComment, cancelReason);
				if (gatewayId > 0)
				{
					if (jobDetail.JobDeliveryDateTimePlanned.HasValue)
					{
						string timeZone = string.IsNullOrEmpty(jobDetail.JobDeliveryTimeZone) ? "Pacific Standard Time" : jobDetail.JobDeliveryTimeZone.Equals("Unknown", StringComparison.OrdinalIgnoreCase) ?
							"Pacific Standard Time" : jobDetail.JobDeliveryTimeZone.Any(char.IsDigit) ?
							jobDetail.JobDeliveryTimeZone : string.Format("{0} Standard Time", jobDetail.JobDeliveryTimeZone);
						TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
						DateTime destinationTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timeZoneInfo);
						int jobStatusUpdateValidationHours = M4PLBusinessConfiguration.JobStatusUpdateValidationHours.ToInt();
						double timeDiffrence = ((DateTime)jobDetail.JobDeliveryDateTimePlanned - destinationTime).TotalHours;
						if (timeDiffrence < jobStatusUpdateValidationHours)
						{
							string emailBody = EventBodyHelper.GetJobCancellationMailBody(jobDetail.Id, timeDiffrence.ToInt().ToString(), jobDetail.JobCustomerSalesOrder, ActiveUser.UserName);
							EventBodyHelper.CreateEventMailNotification((int)EventNotification.JobCancellation, (long)jobDetail.ProgramID, orderNumber, emailBody);
						}
					}

					////bool isFarEyePushRequired = DataAccess.XCBL.XCBLCommands.InsertDeliveryUpdateProcessingLog(jobDetail.Id, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					////if (isFarEyePushRequired)
					////{
					////	FarEyeHelper.PushStatusUpdateToFarEye(jobDetail.Id, ActiveUser);
					////}

					return new StatusModel()
					{
						Status = "Success",
						StatusCode = (int)HttpStatusCode.OK,
						AdditionalDetail = "Order number passed in the service has been cancelled in the Meridian System."
					};
				}
				else
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.InternalServerError,
						AdditionalDetail = "There is some error occuring while cancelling the order, please try after sometime."
					};
				}
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while cancelling a order from API.", "Cancel  Order", Utilities.Logger.LogType.Error);
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.InternalServerError,
					AdditionalDetail = "There is some error occuring while cancelling the order, please try after sometime."
				};
			}
		}

		public StatusModel UnCancelJobByOrderNumber(string orderNumber, string unCancelReason, string unCancelComment)
		{
			if (string.IsNullOrEmpty(orderNumber))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number can not be empty while calling the unCancel job service, please pass a order number."
				};
			}
			try
			{
				var result = _commands.UnCancelJobByCustomerSalesOrderNumber(ActiveUser, orderNumber, unCancelReason, unCancelComment, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
				long jobId = result.JobId;
				long gatewayId = result.CurrentGatewayId;
				string errorMessage = result.ErrorMessage;
				if (gatewayId > 0 && result.IsSuccess)
				{
					bool isFarEyePushRequired = DataAccess.XCBL.XCBLCommands.InsertDeliveryUpdateProcessingLog(jobId, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					if (isFarEyePushRequired)
					{
						FarEyeHelper.PushStatusUpdateToFarEye(jobId, ActiveUser);
					}

					var DateEntered = TimeUtility.GetPacificDateTime();
					string emailBody = EventBodyHelper.GetJobReactivationMailBody(jobId, DateEntered.ToString("MM/dd/yyyy"), DateEntered.ToString("hh:mm tt"), orderNumber, result.JobOriginDateTimePlanned == null ? "NA" : result.JobOriginDateTimePlanned.Value.ToString("MM/dd/yyyy hh:mm tt"), result.JobDeliveryDateTimePlanned == null ? "NA" : result.JobDeliveryDateTimePlanned.Value.ToString("MM/dd/yyyy hh:mm tt"));
					EventBodyHelper.CreateEventMailNotification((int)EventNotification.JobReActivated, result.ProgramId, orderNumber, emailBody);
					return new StatusModel()
					{
						Status = "Success",
						StatusCode = (int)HttpStatusCode.OK,
						AdditionalDetail = "Order number passed in the service has been uncanceled in the Meridian System."
					};
				}
				else
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.InternalServerError,
						AdditionalDetail = errorMessage
					};
				}
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while revoking cancelation of order from API.", "UnCancel  Order", Utilities.Logger.LogType.Error);
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.InternalServerError,
					AdditionalDetail = "There is some error occuring while revoking cancelation of order, please try after sometime."
				};
			}
		}

		public OrderLocationCoordinate GetOrderLocationCoordinate(string orderNumber)
		{
			if (string.IsNullOrEmpty(orderNumber))
			{
				return new OrderLocationCoordinate()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number can not be empty while calling the cancellation service, please pass a order number.",
					Latitude = decimal.Zero,
					Longitude = decimal.Zero
				};
			}

			Entities.Job.Job jobDetail = _commands.GetJobByCustomerSalesOrder(ActiveUser, orderNumber, 0);

			if (jobDetail == null || jobDetail?.Id <= 0)
			{
				return new OrderLocationCoordinate()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number passed in the service is not exist in Meridian System, please pass a valid order number.",
					Latitude = decimal.Zero,
					Longitude = decimal.Zero
				};
			}
			else
			{
				return new OrderLocationCoordinate()
				{
					Status = "Success",
					StatusCode = (int)HttpStatusCode.OK,
					AdditionalDetail = string.IsNullOrEmpty(jobDetail.JobLatitude) && string.IsNullOrEmpty(jobDetail.JobLongitude) ?
					"Latitude and Longitude are not present for order."
					: !string.IsNullOrEmpty(jobDetail.JobLatitude) && string.IsNullOrEmpty(jobDetail.JobLongitude) ?
					"Longitude is not present for order." :
					string.IsNullOrEmpty(jobDetail.JobLatitude) && !string.IsNullOrEmpty(jobDetail.JobLongitude) ?
					"Latitude is not present for order." : string.Empty,
					Latitude = jobDetail.JobLatitude.ToDecimal(),
					Longitude = jobDetail.JobLongitude.ToDecimal()
				};
			}
		}

		public StatusModel RescheduleJobByOrderNumber(JobRescheduleDetail jobRescheduleDetail, string orderNumber, SysSetting sysSetting)
		{
			if (string.IsNullOrEmpty(orderNumber))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number can not be empty while calling the cancellation service, please pass a order number."
				};
			}

			try
			{
				Entities.Job.Job jobDetail = _commands.GetJobByCustomerSalesOrder(ActiveUser, orderNumber, 0);

				if (jobDetail == null || jobDetail?.Id <= 0)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is not exist in Meridian System, please pass a valid order number."
					};
				}
				else if (jobDetail?.Id > 0 && jobDetail.JobCompleted)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is already completed in Meridian System, please contact to Meridian support team for any further action."
					};
				}
				else if (jobDetail?.Id > 0 && jobDetail.IsCancelled.HasValue && jobDetail.IsCancelled.Value)
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.PreconditionFailed,
						AdditionalDetail = "Order number passed in the service is already cancelled in Meridian System, please contact to Meridian support team for any further action."
					};
				}

				JobExceptionInfo selectedJobExceptionInfo = null;
				JobInstallStatus selectedJobInstallStatus = null;
				bool isElectroluxOrder = jobDetail.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() ? true : false;
				StatusModel statusModel = JobRescheduleValidation(jobDetail.Id, jobDetail.CustomerId, jobRescheduleDetail, jobDetail.JobDeliveryDateTimePlanned, isElectroluxOrder, out selectedJobExceptionInfo, out selectedJobInstallStatus);
				if (statusModel != null) { return statusModel; }

				var gatewayResult = RescheduleOrderGateway(jobDetail, selectedJobExceptionInfo, jobRescheduleDetail.RescheduleDate, selectedJobInstallStatus, sysSetting);
				if (gatewayResult?.Id > 0)
				{
					bool isFarEyePushRequired = DataAccess.XCBL.XCBLCommands.InsertDeliveryUpdateProcessingLog(jobDetail.Id, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
					if (isFarEyePushRequired)
					{
						FarEyeHelper.PushStatusUpdateToFarEye(jobDetail.Id, ActiveUser);
					}

					return new StatusModel()
					{
						Status = "Success",
						StatusCode = (int)HttpStatusCode.OK,
						AdditionalDetail = "Rescheduled date is updated successfully for the order."
					};
				}
				else
				{
					return new StatusModel()
					{
						Status = "Failure",
						StatusCode = (int)HttpStatusCode.InternalServerError,
						AdditionalDetail = "There is some error occuring while rescheduling the order, please try after sometime."
					};
				}
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while cancelling a order from API.", "Cancel  Order", Utilities.Logger.LogType.Error);
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.InternalServerError,
					AdditionalDetail = "There is some error occuring while cancelling the order, please try after sometime."
				};
			}
		}

		public StatusModel AddDriver(DriverContact driverContact)
		{
			if (!(driverContact != null
				&& !string.IsNullOrEmpty(driverContact.FirstName)
				&& !string.IsNullOrEmpty(driverContact.LastName)
				&& !string.IsNullOrEmpty(driverContact.LocationCode)
				&& driverContact.JobId > 0
				&& !string.IsNullOrEmpty(driverContact.BizMoblContactID)))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Please Provide Valid Input."
				};
			}

			try
			{
				DriverContact addedDriverContact = _commands.AddDriver(ActiveUser, driverContact);
				if (addedDriverContact != null && addedDriverContact.Id.HasValue && addedDriverContact.Id.Value > 0)
				{
					return new StatusModel()
					{
						Status = "Success",
						StatusCode = (int)HttpStatusCode.OK,
						AdditionalDetail = "Driver Information is Updated Successfully ."
					};
				}
				else
				{
					return new StatusModel()
					{
						Status = "Success",
						StatusCode = (int)HttpStatusCode.OK,
						AdditionalDetail = "JobId or location with respect to Job not found."
					};
				}
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while cancelling a order from API.", "Cancel  Order", Utilities.Logger.LogType.Error);
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.InternalServerError,
					AdditionalDetail = "There is some error occuring while cancelling the order, please try after sometime."
				};
			}
		}

		public StatusModel InsertOrderSpecialInstruction(JobSpecialInstruction jobSpecialInstruction, string orderNumber)
		{
			if (string.IsNullOrEmpty(orderNumber))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number can not be empty while calling the cancellation service, please pass a order number."
				};
			}
			else if (jobSpecialInstruction == null || (jobSpecialInstruction != null && string.IsNullOrEmpty(jobSpecialInstruction.SpecialInstruction)))
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Special instructions are not defined, please pass the valid Instructions."
				};
			}

			Entities.Job.Job jobDetail = _commands.GetJobByCustomerSalesOrder(ActiveUser, orderNumber, 0);

			if (jobDetail == null || jobDetail?.Id <= 0)
			{
				return new StatusModel()
				{
					Status = "Failure",
					StatusCode = (int)HttpStatusCode.PreconditionFailed,
					AdditionalDetail = "Order number passed in the service is not exist in Meridian System, please pass a valid order number."
				};
			}

			JobComment comment = new JobComment() { JobGatewayComment = jobSpecialInstruction.SpecialInstruction, JobGatewayTitle = "Special Instruction", JobId = jobDetail.Id };
			bool result = _commands.InsertJobComment(ActiveUser, comment, false);
			if (result) { return new StatusModel() { AdditionalDetail = "", Status = "Success", StatusCode = 200 }; }
			else { return new StatusModel() { AdditionalDetail = "There is some issue while updating special instructions, please try after sometime.", Status = "Failure", StatusCode = 500 }; }
		}

		private JobGateway RescheduleOrderGateway(Entities.Job.Job jobDetail, JobExceptionInfo jobExceptionInfo, DateTime rescheduleData, JobInstallStatus installStatus, SysSetting sysSetting)
		{
			JobGateway result = null;
			try
			{
				string[] codeArray = jobExceptionInfo.ExceptionReferenceCode.Split('-');
				var jobGateway = DataAccess.Job.JobGatewayCommands.GetGatewayWithParent(ActiveUser, 0, jobDetail.Id, "Action", false, jobExceptionInfo.ExceptionReferenceCode);
				jobGateway.GwyDDPNew = rescheduleData;
				jobGateway.GwyGatewayCode = codeArray[0];
				jobGateway.GatewayTypeId = 86;
				jobGateway.GwyCompleted = true;
				jobGateway.isScheduleReschedule = true;
				jobGateway.GwyUprDate = rescheduleData.AddHours(jobGateway.GwyUprWindow.HasValue ? (double)jobGateway.GwyUprWindow : 0);
				jobGateway.GwyLwrDate = rescheduleData.AddHours(jobGateway.GwyLwrWindow.HasValue ? (double)jobGateway.GwyLwrWindow : 0);
				jobGateway.StatusCode = codeArray.Length > 1 ? codeArray[1] : jobGateway.StatusCode;
				if (jobDetail.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong())
				{
					jobGateway.GwyTitle = jobExceptionInfo.ExceptionReasonCode;
					jobGateway.GwyGatewayTitle = jobExceptionInfo.ExceptionReasonCode;
					jobGateway.GwyExceptionStatusId = installStatus.InstallStatusId;
					jobGateway.GwyExceptionTitleId = jobExceptionInfo.ExceptionReasonId;
				}
				else
				{
					jobGateway.GwyTitle = jobExceptionInfo.ExceptionTitle;
					jobGateway.GwyGatewayTitle = jobExceptionInfo.ExceptionTitle;
				}

				result = DataAccess.Job.JobGatewayCommands.PostWithSettings(ActiveUser, sysSetting, jobGateway, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), jobDetail.Id);
			}
			catch (Exception exp)
			{
				DataAccess.Logger.ErrorLogger.Log(exp, "Error is occurring while Rescheduling a order from API.", "Cancel  Order", Utilities.Logger.LogType.Error);
			}

			return result;
		}

		private StatusModel JobRescheduleValidation(long jobId, long customerId, JobRescheduleDetail jobRescheduleDetail, DateTime? scheduledDate, bool isElectroluxOrder, out JobExceptionInfo selectedJobExceptionInfo, out JobInstallStatus selectedJobInstallStatus)
		{
			StatusModel statusModel = null;
			selectedJobExceptionInfo = null;
			selectedJobInstallStatus = null;
			if (jobRescheduleDetail == null)
			{
				return new StatusModel() { AdditionalDetail = "Request model can not be empty.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (!scheduledDate.HasValue)
			{
				return new StatusModel() { AdditionalDetail = "Order can not be reschedule as status is not updated to scheduled yet.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (jobRescheduleDetail.RescheduleDate < new DateTime(1999, 1, 1))
			{
				return new StatusModel() { AdditionalDetail = "Passed reschedule date is not valid.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobRescheduleDetail.InstallStatus))
			{
				return new StatusModel() { AdditionalDetail = "InstallStatus can not be empty, please sent a InstallStatus for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobRescheduleDetail.RescheduleCode))
			{
				return new StatusModel() { AdditionalDetail = "RescheduleCode can not be empty, please sent a RescheduleCode for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobRescheduleDetail.RescheduleReason))
			{
				return new StatusModel() { AdditionalDetail = "RescheduleReason can not be empty, please sent a RescheduleReason for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			var jobExceptionDetail = M4PL.DataAccess.Common.CommonCommands.GetJobRescheduledDetail(jobId, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() == customerId ? true : false);
			if (jobExceptionDetail != null)
			{
				if (jobExceptionDetail.JobExceptionInfo != null && jobExceptionDetail.JobExceptionInfo.Count > 0)
				{
					var exceptionList = jobExceptionDetail.JobExceptionInfo.Where(x => x.ExceptionReasonCode.Equals(jobRescheduleDetail.RescheduleCode, StringComparison.OrdinalIgnoreCase));
					if (exceptionList.Any())
					{
						selectedJobExceptionInfo = exceptionList.Where(x => x.ExceptionTitle.Equals(jobRescheduleDetail.RescheduleReason, StringComparison.OrdinalIgnoreCase)).Any() ? exceptionList.Where(x => x.ExceptionTitle.Equals(jobRescheduleDetail.RescheduleReason, StringComparison.OrdinalIgnoreCase)).FirstOrDefault() : null;
						if (selectedJobExceptionInfo == null)
						{
							selectedJobExceptionInfo = exceptionList.FirstOrDefault();
						}
					}
				}

				if (jobExceptionDetail.JobInstallStatus != null && jobExceptionDetail.JobInstallStatus.Count > 0)
				{
					var installStatusList = jobExceptionDetail.JobInstallStatus.Where(x => x.InstallStatusDescription.Equals(jobRescheduleDetail.InstallStatus, StringComparison.OrdinalIgnoreCase));
					if (installStatusList.Any())
					{
						selectedJobInstallStatus = installStatusList.FirstOrDefault();
					}
				}
			}
			else
			{
				return new StatusModel() { AdditionalDetail = "There is some issue while M4PL API trying to fetch the avaliable reschedule reason list, please try again.", StatusCode = (int)HttpStatusCode.InternalServerError, Status = "Failure" };
			}

			if (selectedJobInstallStatus == null)
			{
				return new StatusModel() { AdditionalDetail = "InstallStatus recieved in the request is not avalible in M4PL.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (selectedJobExceptionInfo == null)
			{
				return new StatusModel() { AdditionalDetail = "RescheduleCode recieved in the request is not avalible in M4PL.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			return statusModel;
		}
	}
}