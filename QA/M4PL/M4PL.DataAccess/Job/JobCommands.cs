/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Contains commands to perform CRUD on Job
=============================================================================================================*/

using DevExpress.XtraRichEdit;
using M4PL.DataAccess.Common;
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Job
{
    public class JobCommands : BaseCommands<Entities.Job.Job>
    {
        /// <summary>
        /// Gets list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Job.Job> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobView, EntitiesAlias.Job);
        }

        /// <summary>
        /// Gets the specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Job.Job Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJob);
        }

        public static Entities.Job.Job GetJobByProgram(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

		public static Entities.Job.Job GetJobByCustomerSalesOrder(ActiveUser activeUser, string jobSalesOrderNumber)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@userId", activeUser.UserId),
				new Parameter("@roleId", activeUser.RoleId),
				new Parameter("@JobCustomerSalesOrder", jobSalesOrderNumber),
				new Parameter("@orgId", activeUser.OrganizationId)
			};

			var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJobByCustomerSalesOrder, parameters.ToArray(), storedProcedure: true);
			return result ?? new Entities.Job.Job();
		}

		public static void CopyJobGatewayFromProgramForXcBL(ActiveUser activeUser, long jobId, long programId, string gatewayCode)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@JobID", jobId),
				new Parameter("@ProgramID", programId),
				new Parameter("@GwyGatewayCode", gatewayCode),
				new Parameter("@enteredBy", activeUser.UserName),
				new Parameter("@dateEntered", DateTime.UtcNow),
				new Parameter("@userId", activeUser.UserId)
			};

			SqlSerializer.Default.Execute(StoredProceduresConstant.CopyJobGatewayFromProgramForXcBL, parameters.ToArray(), storedProcedure: true);
		}

		public static void ArchiveJobGatewayForXcBL(ActiveUser activeUser, long jobId, long programId, string gatewayCode)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@JobID", jobId),
				new Parameter("@ProgramID", programId),
				new Parameter("@GwyGatewayCode", gatewayCode),
				new Parameter("@ChangedBy", activeUser.UserName),
				new Parameter("@DateChanged", DateTime.UtcNow)
			};

			SqlSerializer.Default.Execute(StoredProceduresConstant.ArchiveJobGatewayForXcBL, parameters.ToArray(), storedProcedure: true);
		}

		/// <summary>
		/// Creates a new Job record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="job"></param>
		/// <returns></returns>

		public static Entities.Job.Job Post(ActiveUser activeUser, Entities.Job.Job job)
        {
            CalculateJobMileage(ref job);
            SetLatitudeAndLongitudeFromAddress(ref job);
            var parameters = GetParameters(job);
            parameters.AddRange(activeUser.PostDefaultParams(job));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJob);
        }

		/// <summary>
		/// Updates the existing Job record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="job"></param>
		/// <returns></returns>

		public static Entities.Job.Job Put(ActiveUser activeUser, Entities.Job.Job job)
		{
			Entities.Job.Job updatedJObDetails = null;
			Entities.Job.Job existingJobDetail = GetJobByProgram(activeUser, job.Id, (long)job.ProgramID);
			var mapRoute = GetJobMapRoute(activeUser, job.Id);
			CalculateJobMileage(ref job, mapRoute);
			//Calculate Latitude and Longitude only if its is updated by the user.
			if ((!string.IsNullOrEmpty(job.JobLatitude) && !string.IsNullOrEmpty(job.JobLongitude)
				&& (job.JobLatitude != mapRoute.JobLatitude || job.JobLongitude != mapRoute.JobLongitude))
					|| mapRoute.isAddressUpdated)
				SetLatitudeAndLongitudeFromAddress(ref job);
			var parameters = GetParameters(job);
			parameters.AddRange(activeUser.PutDefaultParams(job.Id, job));
			updatedJObDetails = Put(activeUser, parameters, StoredProceduresConstant.UpdateJob);

			if (existingJobDetail != null && updatedJObDetails != null)
			{
				CommonCommands.SaveChangeHistory(updatedJObDetails, existingJobDetail, job.Id, (int)EntitiesAlias.Job, EntitiesAlias.Job.ToString(), activeUser);
			}

			return updatedJObDetails;
		}

        /// <summary>
        /// Deletes a specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Job, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the specific Job limited fields for Destination
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobDestination GetJobDestination(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobDestination>(StoredProceduresConstant.GetJobDestination, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobDestination();
        }

        public static bool UpdateJobAttributes(ActiveUser activeUser, long jobId)
        {
            bool result = true;
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@id", jobId),
               new Parameter("@enteredBy", activeUser.UserName),
               new Parameter("@dateEntered", DateTime.UtcNow)
            };

            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobAttributes, parameters.ToArray(), true);
            }
            catch (Exception exp)
            {
                result = false;
                Logger.ErrorLogger.Log(exp, string.Format("Error occured while updating the data for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while updating job attributes from Processor.", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static long CreateJobFromEDI204(ActiveUser activeUser, long eshHeaderID)
        {
            var ediJobInfo = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJobDataFromEDI204, new Parameter("@eshHeaderID", eshHeaderID), storedProcedure: true);
            var createdJobInfo = ediJobInfo != null && ediJobInfo.ProgramID > 0 ? Post(activeUser, ediJobInfo) : null;

            return createdJobInfo != null ? createdJobInfo.Id : 0;
        }

        public static bool InsertJobComment(ActiveUser activeUser, JobComment comment)
        {
            bool result = true;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", comment.JobId),
               new Parameter("@GatewayTitle", comment.JobGatewayTitle),
               new Parameter("@dateEntered", DateTime.UtcNow),
               new Parameter("@enteredBy", activeUser.UserName),
               new Parameter("@userId", activeUser.UserId),
            };

            try
            {
                int insertedGatewayId = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.InsertJobGatewayComment, parameters.ToArray(), false, true);
                if (insertedGatewayId > 0)
                {
                    RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                    richEditDocumentServer.Document.AppendHtmlText(comment.JobGatewayComment);
                    ByteArray byteArray = new ByteArray()
                    {
                        Id = insertedGatewayId,
                        Entity = EntitiesAlias.JobGateway,
                        FieldName = "GwyGatewayDescription",
                        IsPopup = false,
                        FileName = null,
                        Type = SQLDataTypes.varbinary,
                        DocumentText = comment.JobGatewayComment,
                        Bytes = richEditDocumentServer.OpenXmlBytes
                    };

                    CommonCommands.SaveBytes(byteArray, activeUser);
                }
            }
            catch (Exception exp)
            {
                result = false;
                Logger.ErrorLogger.Log(exp, string.Format("Error occured while updating the comment for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while updating job comment from Processor.", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static void CreateJobInDatabase(List<BatchJobDetail> batchJobDetail, long jobProgramId, ActiveUser activeUser)
        {
			foreach (var currentJob in batchJobDetail)
			{
				if (!IsJobAlreadyExists(currentJob.OrderNumber))
				{
					Entities.Job.Job jobInfo = new Entities.Job.Job()
					{
						JobSiteCode = currentJob.Warehouse,
						JobSellerSiteName = currentJob.IntermediateSeller,
						JobDeliverySiteName = currentJob.Customer,
						JobCustomerPurchaseOrder = currentJob.PONumber,
						ShipmentType = currentJob.ShipmentType,
						JobBOL = currentJob.ContractNumber,
						JobCustomerSalesOrder = currentJob.OrderNumber,
						JobDeliveryStreetAddress = currentJob.Address1,
						JobDeliveryStreetAddress2 = currentJob.Lot,
						JobDeliveryCity = currentJob.City,
						JobDeliveryState = currentJob.State,
						JobDeliveryPostalCode = currentJob.Zip,
						JobQtyOrdered = !string.IsNullOrEmpty(currentJob.Cabinets) ? Convert.ToDecimal(currentJob.Cabinets) : (decimal?)null,
						JobPartsOrdered = !string.IsNullOrEmpty(currentJob.Parts) ? Convert.ToInt32(currentJob.Parts) : (int?)null,
						JobTotalCubes = !string.IsNullOrEmpty(currentJob.TotCubes) ? Convert.ToInt32(currentJob.TotCubes) : (int?)null,
						JobServiceMode = currentJob.ServiceMode,
						JobChannel = currentJob.Channel,
						JobOriginSiteName = currentJob.Origin,
						JobDeliverySitePOC = currentJob.ContactName,
						JobDeliverySitePOCPhone = currentJob.ContactPhone,
						JobDeliverySitePOCPhone2 = currentJob.ContactPhone2,
						JobDeliverySitePOCEmail = currentJob.ContactEmail,
						JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(currentJob.ScheduledDeliveryDate) ? Convert.ToDateTime(currentJob.ScheduledDeliveryDate) : (DateTime?)null,
						JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(currentJob.ScheduledDeliveryDate) ? Convert.ToDateTime(currentJob.ScheduledDeliveryDate) : (DateTime?)null,
						ProgramID = jobProgramId,
						StatusId = 1
					};

					Entities.Job.Job jobCreationResult = Post(activeUser, jobInfo);
					if (jobCreationResult == null || (jobCreationResult != null && jobCreationResult.Id <= 0))
					{
						_logger.Log(new Exception(), string.Format("Job creation is failed for JobCustomerSalesOrder : {0}, Requested json was: {1}", jobInfo.JobCustomerSalesOrder, JsonConvert.SerializeObject(jobInfo)), "There is some error occurred while creating the job.", Utilities.Logger.LogType.Error);
					}
					else if(jobCreationResult != null && jobCreationResult.Id > 0)
					{
						JobComment commentText = new JobComment()
						{
							JobId = jobCreationResult.Id,
							JobGatewayComment = currentJob.Notes,
							JobGatewayTitle = "Job Creation Note"
						};

						InsertJobComment(activeUser, commentText);
					}
				}
			}
        }

        public static bool InsertJobGateway(ActiveUser activeUser, long jobId, string shippingAppointmentReasonCode, string shippingStatusReasonCode)
        {
            long insertedGatewayId = 0;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
               new Parameter("@GwyShipApptmtReasonCode", shippingAppointmentReasonCode),
               new Parameter("@GwyShipStatusReasonCode", shippingStatusReasonCode),
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@dateEntered", DateTime.UtcNow),
               new Parameter("@enteredBy", activeUser.UserName)
            };

            try
            {
                insertedGatewayId = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsertNextAvaliableJobGateway, parameters.ToArray(), false, true);
            }
            catch (Exception exp)
            {
                Logger.ErrorLogger.Log(exp, string.Format("Error occured while inserting the next avaliable gateway, JobId was: {0}", jobId), "Error occured while inserting the next avaliable gateway.", Utilities.Logger.LogType.Error);
            }

            return insertedGatewayId > 0 ? true : false;
        }

		public static bool IsJobAlreadyExists(string customerSalesOrderNo)
		{
			bool isJobAlreadyPresent = true;
			try
			{
				isJobAlreadyPresent = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CheckJobDuplication, new Parameter("@CustomerSalesOrderNo", customerSalesOrderNo), false, true);
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error occuring in method IsJobAlreadyExists", "IsJobAlreadyExists", Utilities.Logger.LogType.Error);
			}

			return isJobAlreadyPresent;
		}

        /// <summary>
        /// Gets the specific Job limited fields for 2ndPoc
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Job2ndPoc GetJob2ndPoc(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Job2ndPoc>(StoredProceduresConstant.GetJob2ndPoc, parameters.ToArray(), storedProcedure: true);
            return result ?? new Job2ndPoc();
        }

        /// <summary>
        /// Gets the specific Job limited fields for Seller
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static JobSeller GetJobSeller(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobSeller>(StoredProceduresConstant.GetJobSeller, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobSeller();
        }

        /// <summary>
        /// Gets the specific Job limited fields for MapRoute
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static JobMapRoute GetJobMapRoute(ActiveUser activeUser, long id)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobMapRoute>(StoredProceduresConstant.GetJobMapRoute, parameters.ToArray(), storedProcedure: true);

            if (result != null)
            {
                if (string.IsNullOrEmpty(result.JobLatitude) && string.IsNullOrEmpty(result.JobLongitude))
                {
                    string googleMapsAPI = string.Empty;
                    string deliveryfullAddress = string.Empty;
                    try
                    {
                        deliveryfullAddress = result.DeliveryFullAddress;
                        if (!result.IsOnlyCountryCodeExistsForDeliveryAddress)
                        {
                            Tuple<string, string> latlng = M4PL.Utilities.GoogleMapHelper.GetLatitudeAndLongitudeFromAddress(result.DeliveryFullAddress, ref googleMapsAPI);
                            if (latlng != null && !string.IsNullOrEmpty(latlng.Item1) && !string.IsNullOrEmpty(latlng.Item2))
                            {
                                result.JobLatitude = latlng.Item1;
                                result.JobLongitude = latlng.Item2;
                            }
                            else
                            {
                                _logger.Log(new Exception("something went wrong in method GetJobMapRoute while fetching latitude and longitude"), "Something went wrong while fetching the latitude and longitude for the address " + deliveryfullAddress + " and Google API url is: " + googleMapsAPI, "Google Map Geocode Service", Utilities.Logger.LogType.Error);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        _logger.Log(ex, "Exception occured in method GetJobMapRoute during fetching the latitude and longitude for the address " + deliveryfullAddress + " and Google API url is: " + googleMapsAPI, "Google Map Geocode Service", Utilities.Logger.LogType.Error);
                    }
                }
            }

            return result ?? new JobMapRoute();
        }

        /// <summary>
        /// Gets the specific Job limited fields for Pod
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static JobPod GetJobPod(ActiveUser activeUser, long id)
        {
            return new JobPod();
            //return Get(activeUser, id, StoredProceduresConstant.GetJobPod);
        }

        public static JobDestination PutJobDestination(ActiveUser activeUser, JobDestination jobDestination)
        {
            var parameters = GetJobDestinationParameters(jobDestination);
            parameters.AddRange(activeUser.PutDefaultParams(jobDestination.Id, jobDestination));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobDestination>(StoredProceduresConstant.UpdJobDestination, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static Job2ndPoc PutJob2ndPoc(ActiveUser activeUser, Job2ndPoc job2ndPoc)
        {
            var parameters = GetJob2ndPocParameters(job2ndPoc);
            parameters.AddRange(activeUser.PutDefaultParams(job2ndPoc.Id, job2ndPoc));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Job2ndPoc>(StoredProceduresConstant.UpdJob2ndPoc, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static JobSeller PutJobSeller(ActiveUser activeUser, JobSeller jobSeller)
        {
            var parameters = GetJobSellerParameters(jobSeller);
            parameters.AddRange(activeUser.PutDefaultParams(jobSeller.Id, jobSeller));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobSeller>(StoredProceduresConstant.UpdJobSeller, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static JobMapRoute PutJobMapRoute(ActiveUser activeUser, JobMapRoute jobMapRoute)
        {
            var parameters = GetJobMapRouteParameters(jobMapRoute);
            parameters.AddRange(activeUser.PutDefaultParams(jobMapRoute.Id, jobMapRoute));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobMapRoute>(StoredProceduresConstant.UpdJobMapRoute, parameters.ToArray(), storedProcedure: true);
            return result;
        }


        public static List<ChangeHistoryData> GetChangeHistory(long jobId, ActiveUser activeUser)
        {
            List<ChangeHistoryData> changedDataList = null;
            List<ChangeHistory> changeHistoryData = CommonCommands.GetChangeHistory(activeUser, jobId, EntitiesAlias.Job);
            if (changeHistoryData != null && changeHistoryData.Count > 0)
            {
                changedDataList = new List<ChangeHistoryData>();
                Entities.Job.Job originalDataModel = null;
                Entities.Job.Job changedDataModel = null;
                foreach (var historyData in changeHistoryData)
                {
                    originalDataModel = JsonConvert.DeserializeObject<Entities.Job.Job>(historyData.OrigionalData);
                    changedDataModel = JsonConvert.DeserializeObject<Entities.Job.Job>(historyData.ChangedData);
                    List<ChangeHistoryData> changedData = CommonCommands.GetChangedValues(originalDataModel, changedDataModel, historyData.ChangedBy, historyData.ChangedDate);
                    if (changedData != null && changedData.Count > 0)
                    {
                        changedData.ForEach(x => changedDataList.Add(x));
                    }
                }
            }

            return changedDataList;
        }

        /// <summary>
        /// Gets list of parameters required for the Job Module
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Job.Job job)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobMITJobId", job.JobMITJobID),
               new Parameter("@programId", job.ProgramID),
               new Parameter("@jobSiteCode", job.JobSiteCode),
               new Parameter("@jobConsigneeCode", job.JobConsigneeCode),
               new Parameter("@jobCustomerSalesOrder", job.JobCustomerSalesOrder),
               new Parameter("@jobBOL", job.JobBOL),
               new Parameter("@jobBOLMaster", job.JobBOLMaster),
               new Parameter("@jobBOLChild", job.JobBOLChild),
               new Parameter("@jobCustomerPurchaseOrder", job.JobCustomerPurchaseOrder),
               new Parameter("@jobCarrierContract", job.JobCarrierContract),
               new Parameter("@jobGatewayStatus", job.JobGatewayStatus),
               new Parameter("@statusId", job.StatusId),
               new Parameter("@jobStatusedDate", job.JobStatusedDate),
               new Parameter("@jobCompleted", job.JobCompleted),
               new Parameter("@jobType", job.JobType),
               new Parameter("@shipmentType", job.ShipmentType),
               new Parameter("@jobDeliveryAnalystContactID", job.JobDeliveryAnalystContactID),
               new Parameter("@jobDeliveryResponsibleContactId", job.JobDeliveryResponsibleContactID),
               new Parameter("@jobDeliverySitePOC", job.JobDeliverySitePOC),
               new Parameter("@jobDeliverySitePOCPhone", job.JobDeliverySitePOCPhone),
               new Parameter("@jobDeliverySitePOCEmail", job.JobDeliverySitePOCEmail),
               new Parameter("@jobDeliverySiteName", job.JobDeliverySiteName),
               new Parameter("@jobDeliveryStreetAddress", job.JobDeliveryStreetAddress),
               new Parameter("@jobDeliveryStreetAddress2", job.JobDeliveryStreetAddress2),
               new Parameter("@jobDeliveryCity", job.JobDeliveryCity),
               new Parameter("@jobDeliveryState", job.JobDeliveryState),
               new Parameter("@jobDeliveryPostalCode", job.JobDeliveryPostalCode),
               new Parameter("@jobDeliveryCountry", job.JobDeliveryCountry),
               new Parameter("@jobDeliveryTimeZone", job.JobDeliveryTimeZone),
               new Parameter("@jobDeliveryDateTimePlanned", job.JobDeliveryDateTimePlanned),
               new Parameter("@jobDeliveryDateTimeActual", job.JobDeliveryDateTimeActual),
               new Parameter("@jobDeliveryDateTimeBaseline", job.JobDeliveryDateTimeBaseline),
               new Parameter("@jobDeliveryRecipientPhone", job.JobDeliveryRecipientPhone),
               new Parameter("@jobDeliveryRecipientEmail", job.JobDeliveryRecipientEmail),
               new Parameter("@jobLatitude", job.JobLatitude),
               new Parameter("@jobLongitude", job.JobLongitude),
               new Parameter("@jobOriginResponsibleContactId", job.JobOriginResponsibleContactID),
               new Parameter("@jobOriginSitePOC", job.JobOriginSitePOC),
               new Parameter("@jobOriginSitePOCPhone", job.JobOriginSitePOCPhone),
               new Parameter("@jobOriginSitePOCEmail", job.JobOriginSitePOCEmail),
               new Parameter("@jobOriginSiteName", job.JobOriginSiteName),
               new Parameter("@jobOriginStreetAddress", job.JobOriginStreetAddress),
               new Parameter("@jobOriginStreetAddress2", job.JobOriginStreetAddress2),
               new Parameter("@jobOriginCity", job.JobOriginCity),
               new Parameter("@jobOriginState", job.JobOriginState),
               new Parameter("@jobOriginPostalCode", job.JobOriginPostalCode),
               new Parameter("@jobOriginCountry", job.JobOriginCountry),
               new Parameter("@jobOriginTimeZone", job.JobOriginTimeZone),

               new Parameter("@jobOriginDateTimePlanned",job.JobOriginDateTimePlanned ),
               new Parameter("@jobOriginDateTimeActual",job.JobOriginDateTimeActual),
               new Parameter("@jobOriginDateTimeBaseline",job.JobOriginDateTimeBaseline),

               new Parameter("@jobProcessingFlags", job.JobProcessingFlags),

               new Parameter("@jobDeliverySitePOC2", job.JobDeliverySitePOC2),
               new Parameter("@jobDeliverySitePOCPhone2", job.JobDeliverySitePOCPhone2),
               new Parameter("@jobDeliverySitePOCEmail2", job.JobDeliverySitePOCEmail2),
               new Parameter("@jobOriginSitePOC2", job.JobOriginSitePOC2),
               new Parameter("@jobOriginSitePOCPhone2", job.JobOriginSitePOCPhone2),
               new Parameter("@jobOriginSitePOCEmail2", job.JobOriginSitePOCEmail2),

               new Parameter("@jobSellerCode", job.JobSellerCode),
               new Parameter("@jobSellerSitePOC", job.JobSellerSitePOC),
               new Parameter("@jobSellerSitePOCPhone", job.JobSellerSitePOCPhone),
               new Parameter("@jobSellerSitePOCEmail", job.JobSellerSitePOCEmail),
               new Parameter("@jobSellerSitePOC2", job.JobSellerSitePOC2),
               new Parameter("@jobSellerSitePOCPhone2", job.JobSellerSitePOCPhone2),
               new Parameter("@jobSellerSitePOCEmail2", job.JobSellerSitePOCEmail2),
               new Parameter("@jobSellerSiteName", job.JobSellerSiteName),
               new Parameter("@jobSellerStreetAddress", job.JobSellerStreetAddress),
               new Parameter("@jobSellerStreetAddress2", job.JobSellerStreetAddress2),
               new Parameter("@jobSellerCity", job.JobSellerCity),
               new Parameter("@jobSellerState", job.JobSellerState),
               new Parameter("@jobSellerPostalCode", job.JobSellerPostalCode),
               new Parameter("@jobSellerCountry", job.JobSellerCountry),
               new Parameter("@jobUser01", job.JobUser01),
               new Parameter("@jobUser02", job.JobUser02),
               new Parameter("@jobUser03", job.JobUser03),
               new Parameter("@jobUser04", job.JobUser04),
               new Parameter("@jobUser05", job.JobUser05),
               new Parameter("@jobStatusFlags", job.JobStatusFlags),
               new Parameter("@jobScannerFlags", job.JobScannerFlags),
               new Parameter("@jobManifestNo", job.JobManifestNo),

               new Parameter("@plantIDCode", job.PlantIDCode),
               new Parameter("@carrierID", job.CarrierID),
               new Parameter("@jobDriverId", job.JobDriverId),
               new Parameter("@windowDelStartTime", job.WindowDelStartTime.HasValue && (job.WindowDelStartTime.Value !=DateUtility.SystemEarliestDateTime)  ? job.WindowDelStartTime.Value.ToUniversalTime() :job.WindowDelStartTime ),
               new Parameter("@windowDelEndTime", job.WindowDelEndTime.HasValue  && (job.WindowDelEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowDelEndTime.Value.ToUniversalTime() :job.WindowDelEndTime),
               new Parameter("@windowPckStartTime", job.WindowPckStartTime.HasValue && (job.WindowPckStartTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckStartTime.Value.ToUniversalTime() :job.WindowPckStartTime),
               new Parameter("@windowPckEndTime", job.WindowPckEndTime.HasValue && (job.WindowPckEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckEndTime.Value.ToUniversalTime() :job.WindowPckEndTime),
               new Parameter("@jobRouteId", job.JobRouteId),
               new Parameter("@jobStop", job.JobStop),
               new Parameter("@jobSignText", job.JobSignText),
               new Parameter("@jobSignLatitude", job.JobSignLatitude),
               new Parameter("@jobQtyOrdered", job.JobQtyOrdered),
               new Parameter("@jobQtyActual", job.JobQtyActual),
               new Parameter("@jobQtyUnitTypeId", job.JobQtyUnitTypeId),
               new Parameter("@jobPartsOrdered", job.JobPartsOrdered),
               new Parameter("@jobPartsActual", job.JobPartsActual),
               new Parameter("@JobTotalCubes", job.JobTotalCubes),
               new Parameter("@jobServiceMode", job.JobServiceMode),
               new Parameter("@jobChannel", job.JobChannel),
               new Parameter("@jobProductType", job.JobProductType),
               new Parameter("@JobOrderedDate", job.JobOrderedDate),
               new Parameter("@JobShipmentDate", job.JobShipmentDate),
               new Parameter("@JobInvoicedDate", job.JobInvoicedDate),

               new Parameter("@JobShipFromSiteName", job.JobShipFromSiteName),
               new Parameter("@JobShipFromStreetAddress", job.JobShipFromStreetAddress),
               new Parameter("@JobShipFromStreetAddress2", job.JobShipFromStreetAddress2),
               new Parameter("@JobShipFromCity", job.JobShipFromCity),
               new Parameter("@JobShipFromState", job.JobShipFromState),
               new Parameter("@JobShipFromPostalCode", job.JobShipFromPostalCode),
               new Parameter("@JobShipFromCountry", job.JobShipFromCountry),
               new Parameter("@JobShipFromSitePOC", job.JobShipFromSitePOC),
               new Parameter("@JobShipFromSitePOCPhone", job.JobShipFromSitePOCPhone),
               new Parameter("@JobShipFromSitePOCEmail", job.JobShipFromSitePOCEmail),
               new Parameter("@JobShipFromSitePOC2", job.JobShipFromSitePOC2),
               new Parameter("@JobShipFromSitePOCPhone2", job.JobShipFromSitePOCPhone2),
               new Parameter("@JobShipFromSitePOCEmail2", job.JobShipFromSitePOCEmail2),
               new Parameter("@jobElectronicInvoice", job.JobElectronicInvoice),
               new Parameter("@JobOriginStreetAddress3", job.JobOriginStreetAddress3),
               new Parameter("@JobOriginStreetAddress4", job.JobOriginStreetAddress4),
               new Parameter("@JobDeliveryStreetAddress3", job.JobDeliveryStreetAddress3),
               new Parameter("@JobDeliveryStreetAddress4", job.JobDeliveryStreetAddress4),
               new Parameter("@JobSellerStreetAddress3", job.JobSellerStreetAddress3),
               new Parameter("@JobSellerStreetAddress4", job.JobSellerStreetAddress4),
               new Parameter("@JobShipFromStreetAddress3", job.JobShipFromStreetAddress3),
               new Parameter("@JobShipFromStreetAddress4", job.JobShipFromStreetAddress4),
               new Parameter("@JobCubesUnitTypeId", job.JobCubesUnitTypeId),
               new Parameter("@JobTotalWeight", job.JobTotalWeight),
               new Parameter("@JobWeightUnitTypeId", job.JobWeightUnitTypeId),
               new Parameter("@JobPreferredMethod", job.JobPreferredMethod),
               new Parameter("@JobMileage", job.JobMileage),

            };

            return parameters;
        }

        private static void CalculateJobMileage(ref Entities.Job.Job job, JobMapRoute mapRoute = null)
        {
            string googleAPIUrl = string.Empty;
            string originFullAddress = string.Empty;
            string deliveryfullAddress = string.Empty;
            if (job != null &&
                    !string.IsNullOrEmpty(job.JobOriginStreetAddress) && !string.IsNullOrEmpty(job.JobOriginCity) &&
                    !string.IsNullOrEmpty(job.JobOriginState) && !string.IsNullOrEmpty(job.JobOriginCountry) && !string.IsNullOrEmpty(job.JobOriginPostalCode))

            {
                var origins = new[] {
                                        job.JobOriginStreetAddress,
                                        job.JobOriginStreetAddress2,
                                        job.JobOriginStreetAddress3,
                                        job.JobOriginStreetAddress4,
                                        job.JobOriginCity,
                                        job.JobOriginState,
                                        job.JobOriginPostalCode,
                                        job.JobOriginCountry
                };

                originFullAddress = string.Join(",", origins.Where(s => !string.IsNullOrEmpty(s)));
            }

            if (!string.IsNullOrEmpty(job.JobLatitude) &&
                !string.IsNullOrEmpty(job.JobLongitude) &&
                   (mapRoute != null &&
                    (mapRoute.JobLatitude != job.JobLatitude) ||
                    (mapRoute.JobLongitude != job.JobLongitude))
                )
            {
                var destinations = new[] {
                                            job.JobLatitude,
                                            job.JobLongitude
                };

                deliveryfullAddress = string.Join(",", destinations.Where(s => !string.IsNullOrEmpty(s)));
            }
            else if (!string.IsNullOrEmpty(job.JobDeliveryStreetAddress) &&
                !string.IsNullOrEmpty(job.JobDeliveryCity) &&
                !string.IsNullOrEmpty(job.JobDeliveryState) &&
                !string.IsNullOrEmpty(job.JobDeliveryCountry) &&
                !string.IsNullOrEmpty(job.JobDeliveryPostalCode))
            {
                var destinations = new[] {
                                            job.JobDeliveryStreetAddress,
                                            job.JobDeliveryStreetAddress2,
                                            job.JobDeliveryStreetAddress3,
                                            job.JobDeliveryStreetAddress4,
                                            job.JobDeliveryCity,
                                            job.JobDeliveryState,
                                            job.JobDeliveryPostalCode,
                                            job.JobDeliveryCountry
                };

                deliveryfullAddress = string.Join(",", destinations.Where(s => !string.IsNullOrEmpty(s)));
            }

            try
            {
                if (!string.IsNullOrEmpty(originFullAddress) && !string.IsNullOrEmpty(deliveryfullAddress))
                {
                    // calculate Mileage if existing map route is null
                    // else calculate Mileage only if origin or destination is changed.
                    if (mapRoute == null)
                        job.JobMileage = GoogleMapHelper.GetDistanceFromGoogleMaps(originFullAddress, deliveryfullAddress, ref googleAPIUrl);
                    else if (mapRoute.OriginFullAddress != originFullAddress || mapRoute.DeliveryFullAddress != deliveryfullAddress)
                    {
                        job.JobMileage = GoogleMapHelper.GetDistanceFromGoogleMaps(originFullAddress, deliveryfullAddress, ref googleAPIUrl);
                        mapRoute.isAddressUpdated = true;
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method CalculateJobMileage during fetching the distance between the " + originFullAddress + " and " + deliveryfullAddress + " and Google API url is: " + googleAPIUrl, "Google Map Distance Service", Utilities.Logger.LogType.Error);
            }
        }

        private static void SetLatitudeAndLongitudeFromAddress(ref Entities.Job.Job job)
        {
            string googleAPIUrl = string.Empty;
            string deliveryfullAddress = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(job.JobDeliveryStreetAddress) && !string.IsNullOrEmpty(job.JobDeliveryCity) &&
               !string.IsNullOrEmpty(job.JobDeliveryState) && !string.IsNullOrEmpty(job.JobDeliveryCountry) && !string.IsNullOrEmpty(job.JobDeliveryPostalCode))
                {
                    var destinations = new[] {
                                            job.JobDeliveryStreetAddress,
                                            job.JobDeliveryStreetAddress2,
                                            job.JobDeliveryStreetAddress3,
                                            job.JobDeliveryStreetAddress4,
                                            job.JobDeliveryCity,
                                            job.JobDeliveryState,
                                            job.JobDeliveryPostalCode,
                                            job.JobDeliveryCountry
                };

                    deliveryfullAddress = string.Join(",", destinations.Where(s => !string.IsNullOrEmpty(s)));
                }

                if (!string.IsNullOrEmpty(deliveryfullAddress))
                {
                    Tuple<string, string> latlng = GoogleMapHelper.GetLatitudeAndLongitudeFromAddress(deliveryfullAddress, ref googleAPIUrl);
                    if (latlng != null && !string.IsNullOrEmpty(latlng.Item1) && !string.IsNullOrEmpty(latlng.Item2))
                    {
                        job.JobLatitude = latlng.Item1;
                        job.JobLongitude = latlng.Item2;
                    }
                    else
                    {
                        _logger.Log(new Exception("something went wrong in method SetLatitudeAndLongitudeFromAddress while fetching latitude and longitude"), "Something went wrong while fetching the latitude and longitude for the address " + deliveryfullAddress + " and Google API url is: " + googleAPIUrl, "Google Map Geocode Service", Utilities.Logger.LogType.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method SetLatitudeAndLongitudeFromAddress during fetching the latitude and longitude for the address " + deliveryfullAddress + " and Google API url is: " + googleAPIUrl, "Google Map Geocode Service", Utilities.Logger.LogType.Error);
            }
        }

        private static List<Parameter> GetJobDestinationParameters(JobDestination jobDestination)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@statusId"                 , jobDestination.StatusId),
                new Parameter("@jobDeliverySitePOC"       ,jobDestination.JobDeliverySitePOC),
                new Parameter("@jobDeliverySitePOCPhone"  ,jobDestination.JobDeliverySitePOCPhone),
                new Parameter("@jobDeliverySitePOCEmail"  ,jobDestination.JobDeliverySitePOCEmail),
                new Parameter("@jobDeliverySiteName"      ,jobDestination.JobDeliverySiteName),
                new Parameter("@jobDeliveryStreetAddress" ,jobDestination.JobDeliveryStreetAddress),
                new Parameter("@jobDeliveryStreetAddress2",jobDestination.JobDeliveryStreetAddress2),
                new Parameter("@jobDeliveryStreetAddress3",jobDestination.JobDeliveryStreetAddress3),
                new Parameter("@jobDeliveryStreetAddress4",jobDestination.JobDeliveryStreetAddress4),
                new Parameter("@jobDeliveryCity"          ,jobDestination.JobDeliveryCity),
                new Parameter("@jobDeliveryState"       ,jobDestination.JobDeliveryState),
                new Parameter("@jobDeliveryPostalCode"    ,jobDestination.JobDeliveryPostalCode),
                new Parameter("@jobDeliveryCountry"     ,jobDestination.JobDeliveryCountry),
                new Parameter("@jobOriginSitePOC"         ,jobDestination.JobOriginSitePOC),
                new Parameter("@jobOriginSitePOCPhone"    ,jobDestination.JobOriginSitePOCPhone),
                new Parameter("@jobOriginSitePOCEmail"    ,jobDestination.JobOriginSitePOCEmail),
                new Parameter("@jobOriginSiteName"        ,jobDestination.JobOriginSiteName),
                new Parameter("@jobOriginStreetAddress"   ,jobDestination.JobOriginStreetAddress),
                new Parameter("@jobOriginStreetAddress2"  ,jobDestination.JobOriginStreetAddress2),
                new Parameter("@jobOriginStreetAddress3"  ,jobDestination.JobOriginStreetAddress3),
                new Parameter("@jobOriginStreetAddress4"  ,jobDestination.JobOriginStreetAddress4),
                new Parameter("@jobOriginCity"            ,jobDestination.JobOriginCity),
                new Parameter("@jobOriginState"         ,jobDestination.JobOriginState),
                new Parameter("@jobOriginPostalCode"      ,jobDestination.JobOriginPostalCode),
                new Parameter("@jobOriginCountry"       ,jobDestination.JobOriginCountry),
            };
            return parameters;
        }

        private static List<Parameter> GetJob2ndPocParameters(Job2ndPoc job2ndPoc)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@statusId", job2ndPoc.StatusId),
                new Parameter("@jobDeliverySitePOC2", job2ndPoc.JobDeliverySitePOC2),
                new Parameter("@jobDeliverySitePOCPhone2", job2ndPoc.JobDeliverySitePOCPhone2),
                new Parameter("@jobDeliverySitePOCEmail2", job2ndPoc.JobDeliverySitePOCEmail2),
                new Parameter("@jobDeliverySiteName"      ,job2ndPoc.JobDeliverySiteName),
                new Parameter("@jobDeliveryStreetAddress" ,job2ndPoc.JobDeliveryStreetAddress),
                new Parameter("@jobDeliveryStreetAddress2",job2ndPoc.JobDeliveryStreetAddress2),
                new Parameter("@jobDeliveryStreetAddress3",job2ndPoc.JobDeliveryStreetAddress3),
                new Parameter("@jobDeliveryStreetAddress4",job2ndPoc.JobDeliveryStreetAddress4),
                new Parameter("@jobDeliveryCity"          ,job2ndPoc.JobDeliveryCity),
                new Parameter("@jobDeliveryState"       ,job2ndPoc.JobDeliveryState),
                new Parameter("@jobDeliveryPostalCode"    ,job2ndPoc.JobDeliveryPostalCode),
                new Parameter("@jobDeliveryCountry"     ,job2ndPoc.JobDeliveryCountry),
                new Parameter("@jobDeliveryTimeZone"      ,job2ndPoc.JobDeliveryTimeZone),
                new Parameter("@jobDeliveryDateTimePlanned"   ,job2ndPoc.JobDeliveryDateTimePlanned),

                new Parameter("@jobDeliveryDateTimeActual"    ,job2ndPoc.JobDeliveryDateTimeActual),

                new Parameter("@jobDeliveryDateTimeBaseline"  ,job2ndPoc.JobDeliveryDateTimeBaseline),

                new Parameter("@jobOriginSitePOC2"         ,job2ndPoc.JobOriginSitePOC2),
                new Parameter("@jobOriginSitePOCPhone2"    ,job2ndPoc.JobOriginSitePOCPhone2),
                new Parameter("@jobOriginSitePOCEmail2"    ,job2ndPoc.JobOriginSitePOCEmail2),
                new Parameter("@jobOriginSiteName"        ,job2ndPoc.JobOriginSiteName),
                new Parameter("@jobOriginStreetAddress"   ,job2ndPoc.JobOriginStreetAddress),
                new Parameter("@jobOriginStreetAddress2"  ,job2ndPoc.JobOriginStreetAddress2),
                new Parameter("@jobOriginStreetAddress3"  ,job2ndPoc.JobOriginStreetAddress3),
                new Parameter("@jobOriginStreetAddress4"  ,job2ndPoc.JobOriginStreetAddress4),
                new Parameter("@jobOriginCity"            ,job2ndPoc.JobOriginCity),
                new Parameter("@jobOriginState"         ,job2ndPoc.JobOriginState),
                new Parameter("@jobOriginPostalCode"      ,job2ndPoc.JobOriginPostalCode),
                new Parameter("@jobOriginCountry"       ,job2ndPoc.JobOriginCountry),
                new Parameter("@jobOriginTimeZone"        ,job2ndPoc.JobOriginTimeZone),
                new Parameter("@jobOriginDateTimePlanned"     ,job2ndPoc.JobOriginDateTimePlanned),

                new Parameter("@jobOriginDateTimeActual"      ,job2ndPoc.JobOriginDateTimeActual),

                new Parameter("@jobOriginDateTimeBaseline"    ,job2ndPoc.JobOriginDateTimeBaseline),
            };
            return parameters;
        }

        private static List<Parameter> GetJobSellerParameters(JobSeller jobSeller)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@statusId", jobSeller.StatusId),
               new Parameter("@jobSellerCode", jobSeller.JobSellerCode),
               new Parameter("@jobSellerSitePOC", jobSeller.JobSellerSitePOC),
               new Parameter("@jobSellerSitePOCPhone", jobSeller.JobSellerSitePOCPhone),
               new Parameter("@jobSellerSitePOCEmail", jobSeller.JobSellerSitePOCEmail),
               new Parameter("@jobSellerSitePOC2", jobSeller.JobSellerSitePOC2),
               new Parameter("@jobSellerSitePOCPhone2", jobSeller.JobSellerSitePOCPhone2),
               new Parameter("@jobSellerSitePOCEmail2", jobSeller.JobSellerSitePOCEmail2),
               new Parameter("@jobSellerSiteName", jobSeller.JobSellerSiteName),
               new Parameter("@jobSellerStreetAddress", jobSeller.JobSellerStreetAddress),
               new Parameter("@jobSellerStreetAddress2", jobSeller.JobSellerStreetAddress2),
               new Parameter("@jobSellerStreetAddress3", jobSeller.JobSellerStreetAddress3),
               new Parameter("@jobSellerStreetAddress4", jobSeller.JobSellerStreetAddress4),
               new Parameter("@jobSellerCity", jobSeller.JobSellerCity),
               new Parameter("@jobSellerState", jobSeller.JobSellerState),
               new Parameter("@jobSellerPostalCode", jobSeller.JobSellerPostalCode),
               new Parameter("@jobSellerCountry", jobSeller.JobSellerCountry),
               new Parameter("@JobShipFromSiteName", jobSeller.JobShipFromSiteName),
               new Parameter("@JobShipFromStreetAddress", jobSeller.JobShipFromStreetAddress),
               new Parameter("@JobShipFromStreetAddress2", jobSeller.JobShipFromStreetAddress2),
               new Parameter("@JobShipFromStreetAddress3", jobSeller.JobShipFromStreetAddress3),
               new Parameter("@JobShipFromStreetAddress4", jobSeller.JobShipFromStreetAddress4),
               new Parameter("@JobShipFromCity", jobSeller.JobShipFromCity),
               new Parameter("@JobShipFromState", jobSeller.JobShipFromState),
               new Parameter("@JobShipFromPostalCode", jobSeller.JobShipFromPostalCode),
               new Parameter("@JobShipFromCountry", jobSeller.JobShipFromCountry),
               new Parameter("@JobShipFromSitePOC", jobSeller.JobShipFromSitePOC),
               new Parameter("@JobShipFromSitePOCPhone", jobSeller.JobShipFromSitePOCPhone),
               new Parameter("@JobShipFromSitePOCEmail", jobSeller.JobShipFromSitePOCEmail),
               new Parameter("@JobShipFromSitePOC2", jobSeller.JobShipFromSitePOC2),
               new Parameter("@JobShipFromSitePOCPhone2", jobSeller.JobShipFromSitePOCPhone2),
               new Parameter("@JobShipFromSitePOCEmail2", jobSeller.JobShipFromSitePOCEmail2),
            };
            return parameters;
        }

        private static List<Parameter> GetJobMapRouteParameters(JobMapRoute jobMapRoute)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@statusId", jobMapRoute.StatusId),
                new Parameter("@jobLatitude", jobMapRoute.JobLatitude),
                new Parameter("@jobLongitude", jobMapRoute.JobLongitude),
            };
            return parameters;
        }

        /// <summary>
        /// Gets list of Job tree data
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>
        public static IList<TreeListModel> GetJobTree(long id, long? parentId)
        {
            var parameters = new[]
            {
                new Parameter("@orgId", id)
                , new Parameter("@parentId", parentId)
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeListModel>(StoredProceduresConstant.GetCustPPPTree, parameters, storedProcedure: true);
            return result;
        }

        public static IList<JobsSiteCode> GetJobsSiteCodeByProgram(ActiveUser activeUser, long id, long parentId, bool isNullFIlter = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            parameters.Add(new Parameter("@isNullFIlter", isNullFIlter));
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobsSiteCode>(StoredProceduresConstant.GetJobsSiteCodeByProgram, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<JobsSiteCode>();
        }

        public static List<CustomEntity> GetCustomEntityIdByEntityName(ActiveUser activeUser, EntitiesAlias entity, bool isProgramEntity = false)
        {
            var parameters = new[]
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@entity", entity.ToString()),
               new Parameter("@isProgramEntity", isProgramEntity)
            };
            try
            {
                var result = SqlSerializer.Default.DeserializeMultiRecords<CustomEntity>(StoredProceduresConstant.GetCustomEntityIdByEntityName, parameters, false, storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public class CustomEntity
        {
            public long EntityId { get; set; }
        }
    }
}