﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobCommands
// Purpose:                                      Contains commands to perform CRUD on Job
//=============================================================================================================

using DevExpress.XtraRichEdit;
using M4PL.DataAccess.Common;
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.DataAccess.XCBL;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using Spire.Doc;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Job
{
    public class JobCommands : BaseCommands<Entities.Job.Job>
    {
        public static IList<IdRefLangName> SysOptionList
        {
            get
            {
                return CacheCommands.GetIdRefLangNames("EN", 39);
            }
        }

        public static DateTime DayLightSavingStartDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingStartDate"]);
            }
        }

        public static DateTime DayLightSavingEndDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingEndDate"]);
            }
        }

        public static bool IsDayLightSavingEnable
        {
            get
            {
                return (DateTime.Now.Date >= DayLightSavingStartDate && DateTime.Now.Date <= DayLightSavingEndDate) ? true : false;
            }
        }

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
            bool jobIsHavingPermission = false;
            Entities.Job.Job result = null;
            Entities.Job.JobAdditionalInfo jobAdditionalInfo = null;
            List<Task> tasks = new List<Task>();
            tasks.Add(Task.Factory.StartNew(() =>
            {
                var parameters = new List<Parameter>
                {
                       new Parameter("@userId", activeUser.UserId),
                       new Parameter("@orgId", activeUser.OrganizationId),
                       new Parameter("@jobId", id)
                 };

                jobIsHavingPermission = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.IsJobPermissionPresentForUser, parameters.ToArray(), false, true);
            }));

            tasks.Add(Task.Factory.StartNew(() =>
            {
                if (id > 0)
                {
                    jobAdditionalInfo = SqlSerializer.Default.DeserializeSingleRecord<JobAdditionalInfo>(StoredProceduresConstant.GetJobAdditionalInfo, new Parameter("@id", id), storedProcedure: true);
                }
            }));

            tasks.Add(Task.Factory.StartNew(() =>
            {
                var parameters = activeUser.GetRecordDefaultParams(id, false);
                result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            }));

            if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
            if (jobAdditionalInfo != null && result != null)
            {
                result.CustomerERPId = jobAdditionalInfo.CustomerERPId;
                result.VendorERPId = jobAdditionalInfo.VendorERPId;
                result.JobSONumber = jobAdditionalInfo.JobSONumber;
                result.JobPONumber = jobAdditionalInfo.JobPONumber;
                result.JobElectronicInvoiceSONumber = jobAdditionalInfo.JobElectronicInvoiceSONumber;
                result.JobElectronicInvoicePONumber = jobAdditionalInfo.JobElectronicInvoicePONumber;
                result.JobDeliveryAnalystContactIDName = jobAdditionalInfo.JobDeliveryAnalystContactIDName;
                result.JobDeliveryResponsibleContactIDName = jobAdditionalInfo.JobDeliveryResponsibleContactIDName;
                result.JobQtyUnitTypeIdName = jobAdditionalInfo.JobQtyUnitTypeIdName;
                result.JobCubesUnitTypeIdName = jobAdditionalInfo.JobCubesUnitTypeIdName;
                result.JobWeightUnitTypeIdName = jobAdditionalInfo.JobWeightUnitTypeIdName;
                result.JobOriginResponsibleContactIDName = jobAdditionalInfo.JobOriginResponsibleContactIDName;
                result.JobDriverIdName = jobAdditionalInfo.JobDriverIdName;
                result.IsParentOrder = jobAdditionalInfo.IsParentOrder;
            }
            if (result != null) { result.JobIsHavingPermission = jobIsHavingPermission; }

            return result ?? new Entities.Job.Job();
        }

        public static Entities.Job.Job GetJobByProgram(ActiveUser activeUser, long id, long parentId)
        {
            bool jobIsHavingPermission = false;
            Entities.Job.Job result = null;
            Entities.Job.JobAdditionalInfo jobAdditionalInfo = null;
            IList<JobsSiteCode> jobsSiteCodeListResult = null;
            List<Task> tasks = new List<Task>();
            tasks.Add(Task.Factory.StartNew(() =>
            {
                var parameters = new List<Parameter>
                {
                       new Parameter("@userId", activeUser.UserId),
                       new Parameter("@orgId", activeUser.OrganizationId),
                       new Parameter("@jobId", id)
                 };

                jobIsHavingPermission = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.IsJobPermissionPresentForUser, parameters.ToArray(), false, true);
            }));

            tasks.Add(Task.Factory.StartNew(() =>
            {
                if (id > 0)
                {
                    jobAdditionalInfo = SqlSerializer.Default.DeserializeSingleRecord<JobAdditionalInfo>(StoredProceduresConstant.GetJobAdditionalInfo, new Parameter("@id", id), storedProcedure: true);
                }
            }));

            tasks.Add(Task.Factory.StartNew(() =>
            {
                var parameters = activeUser.GetRecordDefaultParams(id);
                parameters.Add(new Parameter("@parentId", parentId));
                result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            }));

            tasks.Add(Task.Factory.StartNew(() =>
            {
                jobsSiteCodeListResult = GetJobsSiteCodeByProgram(activeUser, id, parentId, true);
            }));

            if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
            if (jobAdditionalInfo != null && result != null)
            {
                result.JobsSiteCodeList = jobsSiteCodeListResult;
                result.CustomerERPId = jobAdditionalInfo.CustomerERPId;
                result.VendorERPId = jobAdditionalInfo.VendorERPId;
                result.JobSONumber = jobAdditionalInfo.JobSONumber;
                result.JobPONumber = jobAdditionalInfo.JobPONumber;
                result.JobElectronicInvoiceSONumber = jobAdditionalInfo.JobElectronicInvoiceSONumber;
                result.JobElectronicInvoicePONumber = jobAdditionalInfo.JobElectronicInvoicePONumber;
                result.JobDeliveryAnalystContactIDName = jobAdditionalInfo.JobDeliveryAnalystContactIDName;
                result.JobDeliveryResponsibleContactIDName = jobAdditionalInfo.JobDeliveryResponsibleContactIDName;
                result.JobQtyUnitTypeIdName = jobAdditionalInfo.JobQtyUnitTypeIdName;
                result.JobCubesUnitTypeIdName = jobAdditionalInfo.JobCubesUnitTypeIdName;
                result.JobWeightUnitTypeIdName = jobAdditionalInfo.JobWeightUnitTypeIdName;
                result.JobOriginResponsibleContactIDName = jobAdditionalInfo.JobOriginResponsibleContactIDName;
                result.JobDriverIdName = jobAdditionalInfo.JobDriverIdName;
                result.IsParentOrder = jobAdditionalInfo.IsParentOrder;
            }
            if (result != null) { result.JobIsHavingPermission = jobIsHavingPermission; }

            return result ?? new Entities.Job.Job();
        }

        public static JobContact GetJobContact(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = new List<Parameter>()
            {
                 new Parameter("@parentId", parentId),
                 new Parameter("@id", id)
            };

            var result = SqlSerializer.Default.DeserializeSingleRecord<JobContact>(StoredProceduresConstant.GetJobContact, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobContact();
        }

        public static Entities.Job.Job GetJobByCustomerSalesOrder(ActiveUser activeUser, string jobSalesOrderNumber, long customerId)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@JobCustomerSalesOrder", jobSalesOrderNumber),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@customerId", customerId)
            };

            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJobByCustomerSalesOrder, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

        public static Entities.Job.Job GetJobByServiceMode(ActiveUser activeUser, string jobServiceModeNumber, long customerId)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@JobServiceModeNumber", jobServiceModeNumber),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@customerId", customerId)
            };

            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJobByServiceMode, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

        public static Entities.Job.Job GetJobByBOLMaster(ActiveUser activeUser, string jobServiceModeNumber, long customerId)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@JobBOLMasterNumber", jobServiceModeNumber),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@customerId", customerId)
            };

            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJobByBOLMaster, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

        public static DriverContact AddDriver(ActiveUser activeUser, DriverContact driverContact)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@bizMoblContactID", driverContact.BizMoblContactID),
                new Parameter("@locationCode", driverContact.LocationCode),
                new Parameter("@firstName", driverContact.FirstName),
                new Parameter("@lastName", driverContact.LastName),
                new Parameter("@jobId", driverContact.JobId),
                new Parameter("@routeId", driverContact.JobRouteId),
                new Parameter("@JobStop", driverContact.JobStop),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@dateEntered", TimeUtility.GetPacificDateTime())
            };

            var result = SqlSerializer.Default.DeserializeSingleRecord<DriverContact>(StoredProceduresConstant.InsDriverContact, parameters.ToArray(), storedProcedure: true);
            return result ?? new DriverContact();
        }

        public static JobGateway CopyJobGatewayFromProgramForXcBL(ActiveUser activeUser, long jobId, long programId, string gatewayCode, string shippingInstruction = "")
        {
            bool saveDocument = true;
            if (string.Equals(gatewayCode, "Comment", StringComparison.InvariantCultureIgnoreCase))
            {
                var parametersComments = new List<Parameter>
            {
                new Parameter("@JobID", jobId)
            };
                var comments = SqlSerializer.Default.DeserializeMultiRecords<JobGateway>(StoredProceduresConstant.GetJobComments, parametersComments.ToArray(), storedProcedure: true);

                List<string> commentsList = new List<string>();
                if (comments != null && comments.Any())
                {
                    foreach (var gateway in comments)
                    {
                        if (gateway.GwyComment != null)
                        {
                            Stream stream = new MemoryStream(gateway.GwyComment);
                            RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                            richEditDocumentServer.LoadDocument(stream, DevExpress.XtraRichEdit.DocumentFormat.OpenXml);
                            commentsList.Add(richEditDocumentServer.Text);
                        }
                    }

                    if (commentsList.Any(obj => obj.Equals(shippingInstruction)))
                    {
                        saveDocument = false;
                        return null;
                    }
                }
            }

            var parameters = new List<Parameter>
            {
                new Parameter("@JobID", jobId),
                new Parameter("@ProgramID", programId),
                new Parameter("@GwyGatewayCode", gatewayCode),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@dateEntered", Utilities.TimeUtility.GetPacificDateTime()),
                new Parameter("@userId", activeUser.UserId)
            };

            var jobGateway = SqlSerializer.Default.DeserializeSingleRecord<JobGateway>(StoredProceduresConstant.CopyJobGatewayFromProgramForXcBL, parameters.ToArray(), storedProcedure: true);
            if (jobGateway != null && jobGateway.Id > 0 && saveDocument
                && string.Equals(gatewayCode, "Comment", StringComparison.InvariantCultureIgnoreCase)
                && !string.IsNullOrEmpty(shippingInstruction))
            {
                RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                richEditDocumentServer.Document.AppendHtmlText(shippingInstruction);
                ByteArray byteArray = new ByteArray()
                {
                    Id = jobGateway.Id,
                    Entity = EntitiesAlias.JobGateway,
                    FieldName = "GwyComment",
                    IsPopup = false,
                    FileName = null,
                    Type = SQLDataTypes.varbinary,
                    DocumentText = shippingInstruction,
                    Bytes = richEditDocumentServer.OpenXmlBytes
                };

                CommonCommands.SaveBytes(byteArray, activeUser);
            }
            return jobGateway;
        }

        public static bool CopyJobGatewayFromProgramForXcBLForElectrolux(ActiveUser activeUser, long jobId, long programId, string gatewayCode, long customerId, out bool isFarEyePushRequired)
        {
            isFarEyePushRequired = false;
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@JobID", jobId),
                new Parameter("@ProgramID", programId),
                new Parameter("@GwyGatewayCode", gatewayCode),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@dateEntered", Utilities.TimeUtility.GetPacificDateTime()),
                new Parameter("@userId", activeUser.UserId)
            };

                var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CopyJobGatewayFromProgramForXcBLForElectrolux, parameters.ToArray(), storedProcedure: true);
                if (result && string.Equals(gatewayCode, "In Transit", StringComparison.InvariantCultureIgnoreCase))
                {
                    isFarEyePushRequired = XCBLCommands.InsertDeliveryUpdateProcessingLog(jobId, customerId);
                }

                return result;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static void UpdatePriceCostDeliveryChargeQuantity(long jobId)
        {
            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdatePriceCostDeliveryChargeQuantity, new Parameter("@jobId", jobId), true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Exception is occuring while Update Price Cost Delivery Charge Quantity.", "UpdatePriceCostDeliveryChargeQuantity", Utilities.Logger.LogType.Error);
            }
        }

        public static void UpdateOnJobPostedInvoice(long jobId, long costChargeId, long priceChargeId)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@JobId", jobId),
                new Parameter("@CostChargeId", costChargeId),
                new Parameter("@PriceChargeId", priceChargeId)
            };

            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateOnJobPostedInvoice, parameters.ToArray(), true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Exception is occuring while Update On Job Posted Invoice.", "UpdateOnJobPostedInvoice", Utilities.Logger.LogType.Error);
            }
        }

        public static long CancelJobByCustomerSalesOrderNumber(ActiveUser activeUser, Entities.Job.Job job, long customerId, string cancelComment, string cancelReason)
        {
            long insertedGatewayId = 0;
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@JobID", job.Id),
                new Parameter("@ProgramID", job.ProgramID),
                new Parameter("@dateEntered", Utilities.TimeUtility.GetPacificDateTime()),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@IsGatewayExceptionUpdate", job.CustomerId == customerId ? true : false)
            };

                insertedGatewayId = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.CancelExistingJobAsRequestByCustomer, parameters.ToArray(), false, true);
                if (insertedGatewayId > 0)
                {
                    if (!string.IsNullOrEmpty(cancelReason))
                    {
                        var result = JobGatewayCommands.GetGatewayWithParent(activeUser, 0, job.Id, "Action", false, "Comment");
                        if (result != null && result.JobID > 0)
                        {
                            result.GatewayTypeId = 86;
                            result.GwyGatewayCode = "Comment";
                            result.GwyGatewayACD = DateTime.UtcNow.AddHours(result.DeliveryUTCValue);
                            result.GwyGatewayTitle = cancelReason;
                            result.GwyTitle = cancelReason;
                            result.GwyCompleted = true;
                            var gatewayResult = JobGatewayCommands.PostWithSettings(activeUser, null, result, customerId, result.JobID);
                            if (gatewayResult != null && gatewayResult.Id > 0 && !string.IsNullOrEmpty(cancelComment))
                            {
                                RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                                richEditDocumentServer.Document.AppendHtmlText(cancelComment);
                                ByteArray byteArray = new ByteArray()
                                {
                                    Id = gatewayResult.Id,
                                    Entity = EntitiesAlias.JobGateway,
                                    FieldName = "GwyGatewayDescription",
                                    IsPopup = false,
                                    FileName = null,
                                    Type = SQLDataTypes.varbinary,
                                    DocumentText = cancelComment,
                                    Bytes = richEditDocumentServer.OpenXmlBytes
                                };

                                CommonCommands.SaveBytes(byteArray, activeUser);
                            }
                        }
                    }
                    else
                    {
                        InsertJobComment(activeUser, new JobComment() { JobId = job.Id, JobGatewayComment = string.Format("This job has been Canceled as per requested by the customer."), JobGatewayTitle = "Cancel Job" });
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Exception is occuring while cancelling a job requested by customer.", "Job Cancellation", Utilities.Logger.LogType.Error);
            }

            return insertedGatewayId;
        }

        public static UnCancelJobResponse UnCancelJobByCustomerSalesOrderNumber(ActiveUser activeUser, string salesOrderNumber, string unCancelReason, string unCancelComment, long customerId)
        {
            long insertedGatewayId = 0;
            long jobId = 0;
            string errorMessage = string.Empty;
            bool isSuccess = false;
            UnCancelJobResponse result = new UnCancelJobResponse();
            try
            {
                var parameters = new List<Parameter>
            {
                new Parameter("@JobCustomerSalesOrder", salesOrderNumber),
                new Parameter("@dateEntered", TimeUtility.GetPacificDateTime()),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@userId", activeUser.UserId)
            };

                result = SqlSerializer.Default.DeserializeSingleRecord<UnCancelJobResponse>(StoredProceduresConstant.UnCancelExistingJobAsRequestByCustomer, parameters.ToArray(), false, true);
                insertedGatewayId = result.CurrentGatewayId;
                jobId = result.JobId;
                errorMessage = result.ErrorMessage;
                isSuccess = result.IsSuccess;
                if (insertedGatewayId > 0 && jobId > 0 && !string.IsNullOrEmpty(unCancelReason))
                {
                    var gatewayResult = JobGatewayCommands.GetGatewayWithParent(activeUser, 0, jobId, "Action", false, "Comment");
                    if (gatewayResult != null && gatewayResult.JobID > 0)
                    {
                        gatewayResult.GatewayTypeId = 86;
                        gatewayResult.GwyGatewayCode = "Comment";
                        gatewayResult.GwyGatewayACD = DateTime.UtcNow.AddHours(gatewayResult.DeliveryUTCValue);
                        gatewayResult.GwyGatewayTitle = unCancelReason;
                        gatewayResult.GwyTitle = unCancelReason;
                        gatewayResult.GwyCompleted = true;
                        var gatewayInsertResult = JobGatewayCommands.PostWithSettings(activeUser, null, gatewayResult, customerId, gatewayResult.JobID);
                        if (gatewayInsertResult != null && gatewayInsertResult.Id > 0 && !string.IsNullOrEmpty(unCancelComment))
                        {
                            RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                            richEditDocumentServer.Document.AppendHtmlText(unCancelComment);
                            ByteArray byteArray = new ByteArray()
                            {
                                Id = gatewayInsertResult.Id,
                                Entity = EntitiesAlias.JobGateway,
                                FieldName = "GwyGatewayDescription",
                                IsPopup = false,
                                FileName = null,
                                Type = SQLDataTypes.varbinary,
                                DocumentText = unCancelComment,
                                Bytes = richEditDocumentServer.OpenXmlBytes
                            };

                            CommonCommands.SaveBytes(byteArray, activeUser);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Exception is occuring while cancelling a job requested by customer.", "Job Cancellation", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static List<JobUpdateDecisionMaker> GetJobUpdateDecisionMaker()
        {
            var parameters = new List<Parameter>
            {
            };
            return SqlSerializer.Default.DeserializeMultiRecords<JobUpdateDecisionMaker>(StoredProceduresConstant.GetJobUpdateDecisionMaker, parameters.ToArray(), storedProcedure: true);
        }

        public static void ArchiveJobGatewayForXcBL(ActiveUser activeUser, long jobId, long programId, string gatewayCode)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@JobID", jobId),
                new Parameter("@ProgramID", programId),
                new Parameter("@GwyGatewayCode", gatewayCode),
                new Parameter("@ChangedBy", activeUser.UserName),
                new Parameter("@DateChanged", Utilities.TimeUtility.GetPacificDateTime())
            };

            SqlSerializer.Default.Execute(StoredProceduresConstant.ArchiveJobGatewayForXcBL, parameters.ToArray(), storedProcedure: true);
        }

        /// <summary>
        /// Creates a new Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="job"></param>
        /// <returns></returns>

        public static Entities.Job.Job Post(ActiveUser activeUser, Entities.Job.Job job, bool isRelatedAttributeUpdate = true, bool isServiceCall = false, bool isManualUpdate = false)
        {
            int CancelId = SysOptionList.FirstOrDefault(x => x.SysRefName.Equals("Canceled", StringComparison.OrdinalIgnoreCase)).SysRefId;
            job.IsCancelled = job.StatusId == CancelId ? true : false;
            Entities.Job.Job createdJobData = null;
            if (IsJobNotDuplicate(job.JobCustomerSalesOrder, (long)job.ProgramID))
            {
                CalculateJobMileage(ref job);
                SetLatitudeAndLongitudeFromAddress(ref job);
                var parameters = GetParameters(job);
                parameters.Add(new Parameter("@IsRelatedAttributeUpdate", isRelatedAttributeUpdate));
                parameters.Add(new Parameter("@isDayLightSavingEnable", IsDayLightSavingEnable));
                parameters.Add(new Parameter("@isManualUpdate", isManualUpdate));
                parameters.Add(new Parameter("@JobDeliveryCommentText", job.JobDeliveryCommentText));
                parameters.AddRange(activeUser.PostDefaultParams(job));
                createdJobData = Post(activeUser, parameters, StoredProceduresConstant.InsertJob);

                if (!isServiceCall && createdJobData?.Id > 0)
                {
                    Task.Run(() =>
                    {
                        List<SystemReference> systemOptionList = !isRelatedAttributeUpdate ? Administration.SystemReferenceCommands.GetSystemRefrenceList() : null;
                        int serviceId = !isRelatedAttributeUpdate ? (int)systemOptionList?.
                            Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
                            Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
                            FirstOrDefault().Id : 0;

                        InsertCostPriceCodesForOrder((long)createdJobData.Id, (long)createdJobData.ProgramID, createdJobData?.JobSiteCode, serviceId, activeUser, !isRelatedAttributeUpdate ? true : false, createdJobData.JobQtyActual);
                    });
                }
            }

            return createdJobData;
        }

        /// <summary>
        /// Updates the existing Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="job"></param>
        /// <returns></returns>

        public static Entities.Job.Job Put(ActiveUser activeUser, Entities.Job.Job job,
            bool isLatLongUpdatedFromXCBL = false, bool isRelatedAttributeUpdate = true, bool isServiceCall = false, long customerId = 0, bool isManualUpdate = false)
        {
            int CancelId = SysOptionList.FirstOrDefault(x => x.SysRefName.Equals("Canceled", StringComparison.OrdinalIgnoreCase)).SysRefId;
            job.IsCancelled = job.StatusId == CancelId ? true : false;
            Entities.Job.Job updatedJobDetails = null;
            Entities.Job.Job existingJobDetail = GetJobByProgram(activeUser, job.Id, (long)job.ProgramID);
            bool isExistsRecord = true;

            //In case of UI update don't consider the customerId check
            if ((job.JobCustomerSalesOrder != existingJobDetail.JobCustomerSalesOrder) || (!isManualUpdate ? (job.CustomerId != existingJobDetail.CustomerId) : false))
            {
                isExistsRecord = IsJobNotDuplicate(job.JobCustomerSalesOrder, (long)job.ProgramID);
            }

            if (isExistsRecord)
            {
                UpdateJobHeaderInformation(job, existingJobDetail, activeUser, isRelatedAttributeUpdate, isManualUpdate);
                if (job.JobIsDirtyDestination)
                {
                    var mapRoute = GetJobMapRoute(activeUser, job.Id);
                    CalculateJobMileage(ref job, mapRoute);
                    if (!isLatLongUpdatedFromXCBL)
                    {
                        if ((!string.IsNullOrEmpty(job.JobLatitude) && !string.IsNullOrEmpty(job.JobLongitude)
                            && (job.JobLatitude != mapRoute.JobLatitude || job.JobLongitude != mapRoute.JobLongitude))
                                || mapRoute.isAddressUpdated)
                            SetLatitudeAndLongitudeFromAddress(ref job);
                    }

                    UpdateJobLocationInformation(job, activeUser, isRelatedAttributeUpdate, isManualUpdate);
                }

                if (job.JobIsDirtyContact)
                {
                    UpdateJobContactInformation(job);
                }

                updatedJobDetails = GetJobByProgram(activeUser, job.Id, (long)job.ProgramID);
                if (!isServiceCall && updatedJobDetails != null && ((existingJobDetail.JobSiteCode != updatedJobDetails.JobSiteCode) || (existingJobDetail.ProgramID != updatedJobDetails.ProgramID)))
                {
                    Task.Run(() =>
                    {
                        List<SystemReference> systemOptionList = !isRelatedAttributeUpdate ? Administration.SystemReferenceCommands.GetSystemRefrenceList() : null;
                        int serviceId = !isRelatedAttributeUpdate ? (int)systemOptionList?.
                            Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
                            Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
                            FirstOrDefault().Id : 0;

                        InsertCostPriceCodesForOrder((long)updatedJobDetails.Id, (long)updatedJobDetails.ProgramID, updatedJobDetails?.JobSiteCode, serviceId, activeUser, customerId == updatedJobDetails.CustomerId ? true : false, updatedJobDetails?.JobQtyActual);
                    });
                }
            }

            return updatedJobDetails;
        }

        private static void UpdateJobContactInformation(Entities.Job.Job job)
        {
            var parameters = new List<Parameter>()
            {
                new Parameter("@jobDeliveryAnalystContactID", job.JobDeliveryAnalystContactID),
                new Parameter("@jobDeliveryResponsibleContactId", job.JobDeliveryResponsibleContactID),
                new Parameter("@jobRouteId", job.JobRouteId),
                new Parameter("@jobStop", job.JobStop),
                new Parameter("@jobDriverId", job.JobDriverId),
                new Parameter("@id", job.Id),
                new Parameter("@isFormView", job.IsFormView)
            };

            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobContactInformation, parameters.ToArray(), true);
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
            parameters.Add(new Parameter("@PacificTime", TimeUtility.GetPacificDateTime()));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobDestination>(StoredProceduresConstant.GetJobDestination, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobDestination();
        }

        public static bool UpdateJobAttributes(ActiveUser activeUser, long jobId, long customerId)
        {
            bool result = true;
            Entities.Job.Job job = GetJobByProgram(activeUser, jobId, 0);
            var mapRoute = GetJobMapRoute(activeUser, job.Id);
            CalculateJobMileage(ref job, mapRoute);
            List<SystemReference> systemOptionList = Administration.SystemReferenceCommands.GetSystemRefrenceList();
            int serviceId = systemOptionList != null ? (int)systemOptionList.
               Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
               Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
               FirstOrDefault().Id : 0;
            InsertCostPriceCodesForOrder(job.Id, (long)job.ProgramID, job.JobSiteCode, serviceId, activeUser, customerId == job.CustomerId ? true : false, job.JobQtyActual);
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@id", jobId),
               new Parameter("@JobMileage", job.JobMileage),
               new Parameter("@programId", job.ProgramID),
               new Parameter("@enteredBy", activeUser.UserName),
               new Parameter("@dateEntered", TimeUtility.GetPacificDateTime())
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

        public static bool InsertJobComment(ActiveUser activeUser, JobComment comment, bool gwyCompleted = true)
        {
            bool result = true;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", comment.JobId),
               new Parameter("@GatewayTitle", comment.JobGatewayTitle),
               new Parameter("@dateEntered", Utilities.TimeUtility.GetPacificDateTime()),
               new Parameter("@enteredBy", activeUser.UserName),
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@isDayLightSavingEnable", IsDayLightSavingEnable),
               new Parameter("@GwyCompleted", gwyCompleted),
               new Parameter("@gatewayACD", comment.GatewayACD)
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

        public static bool UpdatedDeliveryCommentText(ActiveUser activeUser, long jobId, string jobDeliveryCommentText)
        {
            bool result = true;
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobId),
               new Parameter("@deliveryCommentText", jobDeliveryCommentText),
               new Parameter("@dateChanged", Utilities.TimeUtility.GetPacificDateTime()),
               new Parameter("@changedBy", activeUser.UserName)
            };
            try
            {
                SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.UpdateJobDeliveryCommentText, parameters.ToArray(), false, true);

            }
            catch (Exception ex)
            {
                Logger.ErrorLogger.Log(ex, string.Format("Error occured while updating the driveralert for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while updating job comment from Processor.", Utilities.Logger.LogType.Error);
                result = false;
            }
            return result;
        }

        public static bool UpdatedDriverAlert(ActiveUser activeUser, long jobId, string jobDriverAlert)
        {
            bool result = true;
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobId),
               new Parameter("@driverAlert", jobDriverAlert),
               new Parameter("@dateChanged", Utilities.TimeUtility.GetPacificDateTime()),
               new Parameter("@changedBy", activeUser.UserName)
            };
            try
            {
                SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.UpdateJobDriverAlert, parameters.ToArray(), false, true);

            }
            catch (Exception ex)
            {
                Logger.ErrorLogger.Log(ex, string.Format("Error occured while updating the driveralert for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while updating job comment from Processor.", Utilities.Logger.LogType.Error);
                result = false;
            }
            return result;
        }
        public static string GetDriverAlert(long jobId)
        {
            string driverAlert = string.Empty;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
            };
            try
            {
                driverAlert = SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.GetJobDriverAlert, parameters.ToArray(), false, true);

            }
            catch (Exception ex)
            {
                Logger.ErrorLogger.Log(ex, string.Format("Error occured while retreiving the Driver Alert notes for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while retreiving the Driver Alert notes for job.", Utilities.Logger.LogType.Error);
                
            }
            return driverAlert;
        }
        
        public static string GetDeliveryCommentText(long jobId)
        {
            string driverAlert = string.Empty;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
            };
            try
            {
                driverAlert = SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.GetDeliveryComment, parameters.ToArray(), false, true);

            }
            catch (Exception ex)
            {
                Logger.ErrorLogger.Log(ex, string.Format("Error occured while retreiving the Job Delivery Comment for job, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while retreiving the Job Delivery Comment for job.", Utilities.Logger.LogType.Error);

            }
            return driverAlert;
        }
        public static string GetJobNotes(long jobId)
        {
            var parameters = new[]
            {
                new Parameter("@recordId", jobId),
                new Parameter("@entity", "Job"),
                new Parameter("@fields", "JobDeliveryComment"),
            };
            try
            {
                var jobNotes = SqlSerializer.Default.ExecuteScalar<byte[]>(StoredProceduresConstant.GetByteArrayByIdAndEntity, parameters,
                    storedProcedure: true);
                string tempPath = Path.Combine(Path.GetTempPath(), string.Concat(jobId.ToString(), ".docx"));
                File.WriteAllBytes(tempPath, jobNotes);
                Document doc = new Document(tempPath);

                string notes = doc.GetText();
                Task.Run(() =>
                {
                    File.Delete(tempPath);
                });
                return notes;
            }
            catch (Exception ex)
            {
                Logger.ErrorLogger.Log(ex, string.Format("Error occured while fetching the JobNotes, Parameters was: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(parameters)), "Error occured while updating job comment from Processor.", Utilities.Logger.LogType.Error);

            }
            return string.Empty;
        }

        public static void CreateJobInDatabase(List<BatchJobDetail> batchJobDetail, long jobProgramId, ActiveUser activeUser)
        {
            foreach (var currentJob in batchJobDetail)
            {
                if (IsJobNotDuplicate(currentJob.CustomerSalesOrder, jobProgramId))
                {
                    Entities.Job.Job jobInfo = new Entities.Job.Job()
                    {
                        ShipmentType = !string.IsNullOrEmpty(currentJob.ShipmentType) ? currentJob.ShipmentType : "Cross-Dock Shipment",
                        JobType = !string.IsNullOrEmpty(currentJob.OrderType) ? currentJob.OrderType : "Original",
                        JobCustomerSalesOrder = currentJob.CustomerSalesOrder,
                        JobCustomerPurchaseOrder = currentJob.CustomerPurchaseOrder,
                        JobCarrierContract = currentJob.Brand,
                        JobProductType = currentJob.ProductType,
                        JobBOL = currentJob.BOL,
                        JobBOLMaster = currentJob.BOLParent,
                        JobBOLChild = currentJob.BOLChild,
                        PlantIDCode = currentJob.PlantCode,
                        JobManifestNo = currentJob.ManifestNo,
                        JobServiceMode = currentJob.ServiceMode,
                        JobChannel = currentJob.Channel,
                        JobOriginDateTimePlanned = currentJob.ArrivalDate?.ToDateTime(),
                        JobOriginDateTimeBaseline = currentJob.ArrivalDate?.ToDateTime(),
                        JobDeliveryDateTimePlanned = currentJob.EstimateDeliveryDate?.ToDateTime(),
                        JobDeliveryDateTimeBaseline = currentJob.EstimateDeliveryDate?.ToDateTime(),
                        JobSiteCode = currentJob.LocationCode,
                        JobOriginSiteName = currentJob.OriginSiteName,
                        JobSellerSiteName = currentJob.SellerSiteName,
                        JobSellerCode = currentJob.SellerSiteNumber,
                        JobDeliverySiteName = currentJob.DeliverySiteName,
                        JobDeliveryStreetAddress = currentJob.DeliveryAddress1,
                        JobDeliveryStreetAddress2 = currentJob.DeliveryAddress2,
                        JobDeliveryCity = currentJob.DeliveryCity,
                        JobDeliveryPostalCode = currentJob.DeliveryPostalCode,
                        JobDeliveryState = currentJob.DeliveryState,
                        JobDeliverySitePOC = currentJob.DeliverySitePOC,
                        JobDeliverySitePOCPhone = currentJob.DeliverySitePOCPhone,
                        JobOriginSitePOCPhone2 = currentJob.DeliverySitePOCPhone2,
                        JobDeliverySitePOCEmail = currentJob.DeliverySitePOCEmail,
                        JobQtyOrdered =currentJob.QuantityOrdered?.ToInt(),
                        JobPartsOrdered = currentJob.PartsOrdered?.ToInt(),
                        JobTotalCubes = currentJob.TotalCubes?.ToInt(),
                        JobDeliveryCommentText = currentJob.DeliveryComment,
                        StatusId = 1,
                        ProgramID = jobProgramId
                    };

                    Entities.Job.Job jobCreationResult = Post(activeUser, jobInfo, isManualUpdate: true);
                    if (jobCreationResult == null || (jobCreationResult != null && jobCreationResult.Id <= 0))
                    {
                        _logger.Log(new Exception(), string.Format("Job creation is failed for JobCustomerSalesOrder : {0}, Requested json was: {1}", jobInfo.JobCustomerSalesOrder, JsonConvert.SerializeObject(jobInfo)), "There is some error occurred while creating the job.", Utilities.Logger.LogType.Error);
                    }
                }
            }
        }

        public static JobGateway InsertJobGateway(ActiveUser activeUser, BizMoblGatewayRequest bizMoblGatewayRequest, DateTime? gatewayACD)
        {
            JobGateway jobGatewayResult = null;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", bizMoblGatewayRequest.JobId),
               new Parameter("@gatewayStatusCode", bizMoblGatewayRequest.GatewayStatusCode),
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@dateEntered", TimeUtility.GetPacificDateTime()),
               new Parameter("@enteredBy", activeUser.UserName),
               new Parameter("@isDayLightSavingEnable", IsDayLightSavingEnable),
               new Parameter("@gatewayACD", gatewayACD),
               new Parameter("@deliveredDate", bizMoblGatewayRequest.DeliveredDate)
        };

            try
            {
                jobGatewayResult = SqlSerializer.Default.DeserializeSingleRecord<JobGateway>(StoredProceduresConstant.InsertNextAvaliableJobGateway, parameters.ToArray(), false, true);
            }
            catch (Exception exp)
            {
                Logger.ErrorLogger.Log(exp, string.Format("Error occured while inserting the next avaliable gateway, JobId was: {0}", bizMoblGatewayRequest.JobId), "Error occured while inserting the next avaliable gateway.", Utilities.Logger.LogType.Error);
            }

            return jobGatewayResult;
        }

        public static void UpdateJobPartialDataByShippingSchedule(string finalSQLUpdateQuery)
        {
            try
            {
                SqlSerializer.Default.Execute(finalSQLUpdateQuery, null);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "UpdateJobPartialDataByShippingSchedule", string.Format("Error occuring while processing shipping schedule. Query was: {0}", finalSQLUpdateQuery), Utilities.Logger.LogType.Error);
            }
        }

        public static bool IsJobNotDuplicate(string customerSalesOrderNo, long programId)
        {
            bool isJobDuplicate = false;
            var parameters = new List<Parameter>
            {
               new Parameter("@CustomerSalesOrderNo", customerSalesOrderNo),
               new Parameter("@programId", programId)
            };

            try
            {
                isJobDuplicate = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CheckJobDuplication, parameters.ToArray(), false, true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method IsJobAlreadyExists", "IsJobAlreadyExists", Utilities.Logger.LogType.Error);
            }

            return isJobDuplicate;
        }

        public static bool GetJobDeliveryChargeRemovalRequired(long jobId, long customerId)
        {
            bool isDeliveryChargeRemovalRequired = false;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
               new Parameter("@customerId", customerId)
            };

            try
            {
                isDeliveryChargeRemovalRequired = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.GetJobDeliveryChargeRemovalRequired, parameters.ToArray(), false, true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method GetJobDeliveryChargeRemovalRequired", "GetJobDeliveryChargeRemovalRequired", Utilities.Logger.LogType.Error);
            }

            return isDeliveryChargeRemovalRequired;
        }

        public static bool UpdateJobPriceOrCostCodeStatus(long jobId, int statusId, long customerId)
        {
            bool isDefaultChargeUpdate = false;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
               new Parameter("@StatusId", statusId),
               new Parameter("@CustomerId", customerId)
            };

            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobPriceOrCostCodeStatus, parameters.ToArray(), true);
                isDefaultChargeUpdate = true;
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method UpdateJobPriceOrCostCodeStatus", "UpdateJobPriceOrCostCodeStatus", Utilities.Logger.LogType.Error);
            }

            return isDefaultChargeUpdate;
        }

        public static bool ReactivateJob(long jobId)
        {
            bool result = false;
            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.ReactivateJob, new Parameter("@jobId", jobId), true);
                result = true;
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method ReactivateJob", "ReactivateJob", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static bool UpdateJobPriceCodeStatus(long jobId, int statusId, long customerId)
        {
            bool isDefaultChargeUpdate = false;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
               new Parameter("@StatusId", statusId),
               new Parameter("@CustomerId", customerId)
            };

            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobPriceCodeStatus, parameters.ToArray(), true);
                isDefaultChargeUpdate = true;
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method UpdateJobPriceCodeStatus", "UpdateJobPriceCodeStatus", Utilities.Logger.LogType.Error);
            }

            return isDefaultChargeUpdate;
        }

        public static bool UpdateJobCostCodeStatus(long jobId, int statusId, long customerId)
        {
            bool isDefaultChargeUpdate = false;
            var parameters = new List<Parameter>
            {
               new Parameter("@JobId", jobId),
               new Parameter("@StatusId", statusId),
               new Parameter("@CustomerId", customerId)
            };

            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobCostCodeStatus, parameters.ToArray(), true);
                isDefaultChargeUpdate = true;
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method UpdateJobCostCodeStatus", "UpdateJobCostCodeStatus", Utilities.Logger.LogType.Error);
            }

            return isDefaultChargeUpdate;
        }



        public static bool IsJobCancelled(long jobId)
        {
            bool isJobCanceled = false;
            try
            {
                isJobCanceled = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CheckJobCancellation, new Parameter("@JobId", jobId), false, true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error occuring in method IsJobCancelled", "IsJobCancelled", Utilities.Logger.LogType.Error);
            }

            return isJobCanceled;
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
            parameters.Add(new Parameter("@Pacifictime", TimeUtility.GetPacificDateTime()));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobSeller>(StoredProceduresConstant.GetJobSeller, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobSeller();
        }

        /// <summary>
        /// Gets the origin and Delivery address details for supplied Job Id
        /// </summary>
        /// <param name="activeUser">Current User</param>
        /// <param name="id">Job Id</param>
        /// <returns>Origin and Destination details</returns>
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

        public static List<Entities.Job.Job> GetJobChangeHistory(long jobId)
        {
            return SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.Job>(StoredProceduresConstant.GetJobChangeHistory, new Parameter("@JobId", jobId), storedProcedure: true);
        }

        public static List<ChangeHistoryData> GetJobChangeHistory(long jobId, ActiveUser activeUser)
        {
            List<ChangeHistoryData> changedDataList = null;
            List<Entities.Job.Job> changeHistoryData = GetJobChangeHistory(jobId);
            if (changeHistoryData != null && changeHistoryData.Count > 1)
            {
                changedDataList = new List<ChangeHistoryData>();
                Entities.Job.Job originalDataModel = null;
                Entities.Job.Job changedDataModel = null;
                for (int i = 0; i < changeHistoryData.Count - 1; i++)
                {
                    originalDataModel = changeHistoryData[i];
                    changedDataModel = changeHistoryData[i + 1];
                    List<ChangeHistoryData> changedData = CommonCommands.GetChangedValues(originalDataModel, changedDataModel, !string.IsNullOrEmpty(changedDataModel.ChangedBy) ? changedDataModel.ChangedBy : changedDataModel.EnteredBy, changedDataModel.DateChanged.HasValue ? (DateTime)changedDataModel.DateChanged : (DateTime)changedDataModel.DateEntered);
                    if (changedData != null && changedData.Count > 0)
                    {
                        changedData.ForEach(x => changedDataList.Add(x));
                    }
                }
            }

            return changedDataList;
        }

        public static bool InsertJobCargoData(List<JobCargo> jobCargos, ActiveUser activeUser)
        {
            bool result = true;
            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.InsertJobCargoData, new Parameter("@uttjobCargo", GetJobCargoDT(jobCargos, activeUser)), true);
            }
            catch (Exception exp)
            {
                result = false;
                _logger.Log(exp, "Error while inserting Cargo Data", "Cargo Insertion", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        public static void InsertCostPriceCodesForOrder(long jobId, long programId, string locationCode, int serviceId, ActiveUser activeUser, bool isElectroluxOrder, int? quantity)
        {
            List<JobBillableSheet> jobBillableSheetList = null;
            List<JobCostSheet> jobCostSheetList = null;
            List<JobCargo> jobCargoList = null;
            List<PrgBillableRate> programBillableRate = Program.PrgBillableRateCommands.GetProgramBillableRate(activeUser, programId, locationCode, jobId);
            List<PrgCostRate> programCostRate = Program.PrgCostRateCommands.GetProgramCostRate(activeUser, programId, locationCode, jobId);

            if (isElectroluxOrder)
            {
                jobCargoList = JobCargoCommands.GetCargoListForJob(activeUser, jobId);
                jobBillableSheetList = JobBillableSheetCommands.GetPriceCodeDetailsForElectroluxOrder(jobId, jobCargoList, locationCode, serviceId, programId, activeUser, programBillableRate, quantity);
                jobCostSheetList = JobCostSheetCommands.GetCostCodeDetailsForElectroluxOrder(jobId, jobCargoList, locationCode, serviceId, programId, activeUser, programCostRate, quantity);
            }
            else
            {
                jobBillableSheetList = JobBillableSheetCommands.GetPriceCodeDetailsForOrder(jobId, activeUser, programBillableRate, quantity, locationCode);
                jobCostSheetList = JobCostSheetCommands.GetCostCodeDetailsForOrder(jobId, activeUser, programCostRate, quantity, locationCode);
            }

            jobBillableSheetList = jobBillableSheetList == null ? new List<JobBillableSheet>() : jobBillableSheetList;
            jobCostSheetList = jobCostSheetList == null ? new List<JobCostSheet>() : jobCostSheetList;
            programBillableRate = programBillableRate == null ? new List<PrgBillableRate>() : programBillableRate;
            programCostRate = programCostRate == null ? new List<PrgCostRate>() : programCostRate;
            UpdateMissingCostCodeData(jobBillableSheetList, jobCostSheetList, programBillableRate, programCostRate);
            JobBillableSheetCommands.InsertJobBillableSheetData(jobBillableSheetList, jobId);
            JobCostSheetCommands.InsertJobCostSheetData(jobCostSheetList, jobId);
        }

        private static void UpdateMissingCostCodeData(List<JobBillableSheet> jobBillableSheetList, List<JobCostSheet> jobCostSheetList, List<PrgBillableRate> prgBillableRate, List<PrgCostRate> programCostRate)
        {
            #region Cost Rate Missing But Billable Rate Present

            if (jobBillableSheetList?.Count > 0 && jobCostSheetList?.Count == 0)
            {
                if (programCostRate?.Count == 0)
                {
                    jobCostSheetList.AddRange(jobBillableSheetList.Select(billableItem => new JobCostSheet()
                    {
                        ItemNumber = billableItem.ItemNumber,
                        JobID = billableItem.JobID,
                        CstLineItem = billableItem.ItemNumber.ToString(),
                        CstChargeID = 0,
                        CstChargeCode = billableItem.PrcChargeCode,
                        CstTitle = billableItem.PrcTitle,
                        CstUnitId = billableItem.PrcUnitId,
                        ChargeTypeId = billableItem.ChargeTypeId,
                        StatusId = billableItem.StatusId,
                        CstQuantity = billableItem.PrcQuantity > 1 ? billableItem.PrcQuantity : 1,
                        CstRate = decimal.Zero,
                        CstElectronicBilling = billableItem.PrcElectronicBilling,
                        DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                        EnteredBy = billableItem.EnteredBy
                    }));
                }
                else
                {
                    jobCostSheetList.AddRange(jobBillableSheetList.Select(billableItem => new JobCostSheet()
                    {
                        ItemNumber = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().ItemNumber : billableItem.ItemNumber,
                        JobID = billableItem.JobID,
                        CstLineItem = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().ItemNumber?.ToString() : billableItem.ItemNumber.ToString(),
                        CstChargeID = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().Id : 0,
                        CstChargeCode = billableItem.PrcChargeCode,
                        CstTitle = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrTitle : billableItem.PrcTitle,
                        CstUnitId = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().RateUnitTypeId : billableItem.PrcUnitId,
                        ChargeTypeId = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().RateTypeId : billableItem.ChargeTypeId,
                        StatusId = billableItem.StatusId,
                        CstQuantity = billableItem.PrcQuantity > 1 ? billableItem.PrcQuantity : 1,
                        CstRate = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrCostRate : decimal.Zero,
                        CstElectronicBilling = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrElectronicBilling : billableItem.PrcElectronicBilling,
                        DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                        EnteredBy = billableItem.EnteredBy
                    }));
                }
            }

            #endregion Cost Rate Missing But Billable Rate Present

            #region Billable Rate Missing But Cost Rate Present

            else if (jobBillableSheetList?.Count == 0 && jobCostSheetList?.Count > 0)
            {
                if (prgBillableRate?.Count == 0)
                {
                    jobBillableSheetList.AddRange(jobCostSheetList.Select(costItem => new JobBillableSheet()
                    {
                        ItemNumber = costItem.ItemNumber,
                        JobID = costItem.JobID,
                        PrcLineItem = costItem.ItemNumber.ToString(),
                        PrcChargeID = 0,
                        PrcChargeCode = costItem.CstChargeCode,
                        PrcTitle = costItem.CstTitle,
                        PrcUnitId = costItem.CstUnitId,
                        ChargeTypeId = costItem.ChargeTypeId,
                        StatusId = costItem.StatusId,
                        PrcRate = decimal.Zero,
                        PrcQuantity = costItem.CstQuantity > 1 ? costItem.CstQuantity : 1,
                        PrcElectronicBilling = costItem.CstElectronicBilling,
                        DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                        EnteredBy = costItem.EnteredBy
                    }));
                }
                else
                {
                    jobBillableSheetList.AddRange(jobCostSheetList.Select(costItem => new JobBillableSheet()
                    {
                        ItemNumber = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().ItemNumber : costItem.ItemNumber,
                        JobID = costItem.JobID,
                        PrcLineItem = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().ItemNumber.ToString() : costItem.ItemNumber.ToString(),
                        PrcChargeID = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().Id : 0,
                        PrcChargeCode = costItem.CstChargeCode,
                        PrcTitle = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrTitle : costItem.CstTitle,
                        PrcUnitId = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().RateUnitTypeId : costItem.CstUnitId,
                        ChargeTypeId = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().RateTypeId : costItem.ChargeTypeId,
                        PrcRate = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrBillablePrice : decimal.Zero,
                        StatusId = costItem.StatusId,
                        PrcQuantity = costItem.CstQuantity > 1 ? costItem.CstQuantity : 1,
                        PrcElectronicBilling = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrElectronicBilling : costItem.CstElectronicBilling,
                        DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                        EnteredBy = costItem.EnteredBy
                    }));
                }
            }

            #endregion Billable Rate Missing But Cost Rate Present

            #region Both Billable and Cost Charge Present

            else if (jobBillableSheetList?.Count > 0 && jobCostSheetList?.Count > 0)
            {
                var billableResult = jobBillableSheetList.Where(p => jobCostSheetList.All(p2 => p2.CstChargeCode != p.PrcChargeCode))?.ToList();
                var costResult = jobCostSheetList.Where(p => jobBillableSheetList.All(p2 => p2.PrcChargeCode != p.CstChargeCode))?.ToList();
                if (costResult?.Count > 0)
                {
                    if (prgBillableRate?.Count == 0)
                    {
                        jobBillableSheetList.AddRange(costResult.Select(costItem => new JobBillableSheet()
                        {
                            ItemNumber = costItem.ItemNumber,
                            JobID = costItem.JobID,
                            PrcLineItem = costItem.ItemNumber.ToString(),
                            PrcChargeID = 0,
                            PrcChargeCode = costItem.CstChargeCode,
                            PrcTitle = costItem.CstTitle,
                            PrcUnitId = costItem.CstUnitId,
                            ChargeTypeId = costItem.ChargeTypeId,
                            StatusId = costItem.StatusId,
                            PrcQuantity = costItem.CstQuantity > 1 ? costItem.CstQuantity : 1,
                            PrcRate = decimal.Zero,
                            PrcElectronicBilling = costItem.CstElectronicBilling,
                            DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                            EnteredBy = costItem.EnteredBy
                        }));
                    }
                    else
                    {
                        jobBillableSheetList.AddRange(costResult.Select(costItem => new JobBillableSheet()
                        {
                            ItemNumber = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().ItemNumber : costItem.ItemNumber,
                            JobID = costItem.JobID,
                            PrcLineItem = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().ItemNumber.ToString() : costItem.ItemNumber.ToString(),
                            PrcChargeID = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().Id : 0,
                            PrcChargeCode = costItem.CstChargeCode,
                            PrcTitle = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrTitle : costItem.CstTitle,
                            PrcUnitId = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().RateUnitTypeId : costItem.CstUnitId,
                            ChargeTypeId = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().RateTypeId : costItem.ChargeTypeId,
                            PrcRate = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrBillablePrice : decimal.Zero,
                            StatusId = costItem.StatusId,
                            PrcQuantity = costItem.CstQuantity > 1 ? costItem.CstQuantity : 1,
                            PrcElectronicBilling = prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).Any() ? prgBillableRate.Where(x => x.PbrCode == costItem.CstChargeCode).FirstOrDefault().PbrElectronicBilling : costItem.CstElectronicBilling,
                            DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                            EnteredBy = costItem.EnteredBy
                        }));
                    }
                }

                if (billableResult?.Count > 0)
                {
                    if (programCostRate?.Count == 0)
                    {
                        jobCostSheetList.AddRange(billableResult.Select(billableItem => new JobCostSheet()
                        {
                            ItemNumber = billableItem.ItemNumber,
                            JobID = billableItem.JobID,
                            CstLineItem = billableItem.ItemNumber.ToString(),
                            CstChargeID = 0,
                            CstChargeCode = billableItem.PrcChargeCode,
                            CstTitle = billableItem.PrcTitle,
                            CstUnitId = billableItem.PrcUnitId,
                            ChargeTypeId = billableItem.ChargeTypeId,
                            StatusId = billableItem.StatusId,
                            CstRate = decimal.Zero,
                            CstQuantity = billableItem.PrcQuantity > 1 ? billableItem.PrcQuantity : 1,
                            CstElectronicBilling = billableItem.PrcElectronicBilling,
                            DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                            EnteredBy = billableItem.EnteredBy
                        }));
                    }
                    else
                    {
                        jobCostSheetList.AddRange(billableResult.Select(billableItem => new JobCostSheet()
                        {
                            ItemNumber = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().ItemNumber : billableItem.ItemNumber,
                            JobID = billableItem.JobID,
                            CstLineItem = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().ItemNumber?.ToString() : billableItem.ItemNumber.ToString(),
                            CstChargeID = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().Id : 0,
                            CstChargeCode = billableItem.PrcChargeCode,
                            CstTitle = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrTitle : billableItem.PrcTitle,
                            CstUnitId = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().RateUnitTypeId : billableItem.PrcUnitId,
                            ChargeTypeId = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().RateTypeId : billableItem.ChargeTypeId,
                            CstRate = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrCostRate : decimal.Zero,
                            StatusId = billableItem.StatusId,
                            CstQuantity = billableItem.PrcQuantity > 1 ? billableItem.PrcQuantity : 1,
                            CstElectronicBilling = programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).Any() ? programCostRate.Where(x => x.PcrCode == billableItem.PrcChargeCode).FirstOrDefault().PcrElectronicBilling : billableItem.PrcElectronicBilling,
                            DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
                            EnteredBy = billableItem.EnteredBy
                        }));
                    }
                }
            }

            #endregion Both Billable and Cost Charge Present
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
               new Parameter("@JobServiceOrder", job.JobServiceOrder),
               new Parameter("@JobServiceActual", job.JobServiceActual),
               new Parameter("@IsJobVocSurvey", job.IsJobVocSurvey),
               new Parameter("@ProFlags12", job.ProFlags12),
               new Parameter("@JobDriverAlert", job.JobDriverAlert),
               new Parameter("@IsCancelled", job.IsCancelled)
        };

            return parameters;
        }

        private static List<Parameter> GetJobHeaderParameters(Entities.Job.Job job)
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
               new Parameter("@jobManifestNo", job.JobManifestNo),
               new Parameter("@jobGatewayStatus", job.JobGatewayStatus),
               new Parameter("@statusId", job.StatusId),
               new Parameter("@jobStatusedDate", job.JobStatusedDate),
               new Parameter("@jobCompleted", job.JobCompleted),
               new Parameter("@jobType", job.JobType),
               new Parameter("@shipmentType", job.ShipmentType),
               new Parameter("@jobDeliveryDateTimePlanned", job.JobDeliveryDateTimePlanned),
               new Parameter("@jobDeliveryDateTimeActual", job.JobDeliveryDateTimeActual),
               new Parameter("@jobDeliveryDateTimeBaseline", job.JobDeliveryDateTimeBaseline),
               new Parameter("@jobDeliveryRecipientPhone", job.JobDeliveryRecipientPhone),
               new Parameter("@jobDeliveryRecipientEmail", job.JobDeliveryRecipientEmail),
               new Parameter("@jobOriginResponsibleContactId", job.JobOriginResponsibleContactID),
               new Parameter("@jobOriginDateTimePlanned",job.JobOriginDateTimePlanned ),
               new Parameter("@jobOriginDateTimeActual",job.JobOriginDateTimeActual),
               new Parameter("@jobOriginDateTimeBaseline",job.JobOriginDateTimeBaseline),
               new Parameter("@jobProcessingFlags", job.JobProcessingFlags),
               new Parameter("@jobUser01", job.JobUser01),
               new Parameter("@jobUser02", job.JobUser02),
               new Parameter("@jobUser03", job.JobUser03),
               new Parameter("@jobUser04", job.JobUser04),
               new Parameter("@jobUser05", job.JobUser05),
               new Parameter("@jobStatusFlags", job.JobStatusFlags),
               new Parameter("@jobScannerFlags", job.JobScannerFlags),
               new Parameter("@plantIDCode", job.PlantIDCode),
               new Parameter("@carrierID", job.CarrierID),
               new Parameter("@windowDelStartTime", job.WindowDelStartTime.HasValue && (job.WindowDelStartTime.Value !=DateUtility.SystemEarliestDateTime)  ? job.WindowDelStartTime.Value.ToUniversalTime() :job.WindowDelStartTime ),
               new Parameter("@windowDelEndTime", job.WindowDelEndTime.HasValue  && (job.WindowDelEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowDelEndTime.Value.ToUniversalTime() :job.WindowDelEndTime),
               new Parameter("@windowPckStartTime", job.WindowPckStartTime.HasValue && (job.WindowPckStartTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckStartTime.Value.ToUniversalTime() :job.WindowPckStartTime),
               new Parameter("@windowPckEndTime", job.WindowPckEndTime.HasValue && (job.WindowPckEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckEndTime.Value.ToUniversalTime() :job.WindowPckEndTime),
               new Parameter("@jobSignText", job.JobSignText),
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
               new Parameter("@jobElectronicInvoice", job.JobElectronicInvoice),
               new Parameter("@JobCubesUnitTypeId", job.JobCubesUnitTypeId),
               new Parameter("@JobTotalWeight", job.JobTotalWeight),
               new Parameter("@JobWeightUnitTypeId", job.JobWeightUnitTypeId),
               new Parameter("@JobServiceOrder", job.JobServiceOrder),
               new Parameter("@JobServiceActual", job.JobServiceActual),
               new Parameter("@ProFlags12", job.ProFlags12),
               new Parameter("@JobDriverAlert", job.JobDriverAlert),
               new Parameter("@IsCancelled", job.IsCancelled),
               new Parameter("@jobDeliveryTimeZone", job.JobDeliveryTimeZone),
               new Parameter("@jobOriginTimeZone", job.JobOriginTimeZone),
               new Parameter("@JobIsDirtyDestination", job.JobIsDirtyDestination),
               new Parameter("@jobOriginPostalCode", job.JobOriginPostalCode)
        };

            return parameters;
        }

        private static List<Parameter> GetJobDestinationParameters(Entities.Job.Job job)
        {
            var parameters = new List<Parameter>
            {
                 new Parameter("@jobOriginSiteName", job.JobOriginSiteName),
                 new Parameter("@jobOriginSitePOC", job.JobOriginSitePOC),
                 new Parameter("@jobOriginSitePOCPhone", job.JobOriginSitePOCPhone),
                 new Parameter("@jobOriginSitePOCEmail", job.JobOriginSitePOCEmail),
                 new Parameter("@jobOriginStreetAddress", job.JobOriginStreetAddress),
                 new Parameter("@jobOriginStreetAddress2", job.JobOriginStreetAddress2),
                 new Parameter("@JobOriginStreetAddress3", job.JobOriginStreetAddress3),
                 new Parameter("@JobOriginStreetAddress4", job.JobOriginStreetAddress4),
                 new Parameter("@jobOriginCity", job.JobOriginCity),
                 new Parameter("@jobOriginState", job.JobOriginState),
                 new Parameter("@jobOriginCountry", job.JobOriginCountry),
                 new Parameter("@jobOriginPostalCode", job.JobOriginPostalCode),
                 new Parameter("@jobDeliverySiteName", job.JobDeliverySiteName),
                 new Parameter("@jobDeliverySitePOC", job.JobDeliverySitePOC),
                 new Parameter("@jobDeliverySitePOCPhone", job.JobDeliverySitePOCPhone),
                 new Parameter("@jobDeliverySitePOCEmail", job.JobDeliverySitePOCEmail),
                 new Parameter("@jobDeliveryStreetAddress", job.JobDeliveryStreetAddress),
                 new Parameter("@jobDeliveryStreetAddress2", job.JobDeliveryStreetAddress2),
                 new Parameter("@JobDeliveryStreetAddress3", job.JobDeliveryStreetAddress3),
                 new Parameter("@JobDeliveryStreetAddress4", job.JobDeliveryStreetAddress4),
                 new Parameter("@jobDeliveryCity", job.JobDeliveryCity),
                 new Parameter("@jobDeliveryState", job.JobDeliveryState),
                 new Parameter("@jobDeliveryCountry", job.JobDeliveryCountry),
                 new Parameter("@jobDeliveryPostalCode", job.JobDeliveryPostalCode),
                 new Parameter("@jobDeliverySitePOC2", job.JobDeliverySitePOC2),
                 new Parameter("@jobDeliverySitePOCPhone2", job.JobDeliverySitePOCPhone2),
                 new Parameter("@jobDeliverySitePOCEmail2", job.JobDeliverySitePOCEmail2),
                 new Parameter("@jobOriginSitePOC2", job.JobOriginSitePOC2),
                 new Parameter("@jobOriginSitePOCPhone2", job.JobOriginSitePOCPhone2),
                 new Parameter("@jobOriginSitePOCEmail2", job.JobOriginSitePOCEmail2),
                 new Parameter("@JobPreferredMethod", job.JobPreferredMethod),
                 new Parameter("@IsJobVocSurvey", job.IsJobVocSurvey),
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
                 new Parameter("@JobSellerStreetAddress3", job.JobSellerStreetAddress3),
                 new Parameter("@JobSellerStreetAddress4", job.JobSellerStreetAddress4),
                 new Parameter("@JobShipFromStreetAddress3", job.JobShipFromStreetAddress3),
                 new Parameter("@JobShipFromStreetAddress4", job.JobShipFromStreetAddress4),
                 new Parameter("@jobLatitude", job.JobLatitude),
                 new Parameter("@jobLongitude", job.JobLongitude),
                 new Parameter("@JobMileage", job.JobMileage),
                 new Parameter("@IsSellerTabEdited", job.IsSellerTabEdited),
                 new Parameter("@IsPODTabEdited", job.IsPODTabEdited),
                 new Parameter("@jobSignText", job.JobSignText),
                 new Parameter("@jobSignLatitude", job.JobSignLatitude),
                 new Parameter("@jobSignLongitude", job.JobSignLongitude)
            };

            return parameters;
        }

        private static void UpdateJobHeaderInformation(Entities.Job.Job updatedJob, Entities.Job.Job existingJob, ActiveUser activeUser, bool isRelatedAttributeUpdate, bool isManualUpdate)
        {
            var parameters = GetJobHeaderParameters(updatedJob);
            parameters.Add(new Parameter("@IsRelatedAttributeUpdate", isRelatedAttributeUpdate));
            parameters.Add(new Parameter("@isDayLightSavingEnable", IsDayLightSavingEnable));
            parameters.Add(new Parameter("@isManualUpdate", isManualUpdate));
            parameters.Add(new Parameter("@OldOrderType", existingJob.JobType));
            parameters.Add(new Parameter("@OldShipmentType", existingJob.ShipmentType));
            parameters.Add(new Parameter("@JobDeliveryCommentText", updatedJob.JobDeliveryCommentText));
            if (updatedJob.IsCancelled.HasValue && !updatedJob.IsCancelled.Value && updatedJob.StatusId == (int)StatusType.Active && existingJob.IsCancelled.HasValue && existingJob.IsCancelled.Value)
            {
                updatedJob.JobGatewayStatus = isRelatedAttributeUpdate ? "In Transit" : "In Production";
                parameters.Add(new Parameter("@IsJobReactivated", true));
            }
            else
            {
                parameters.Add(new Parameter("@IsJobReactivated", false));
            }

            parameters.AddRange(activeUser.PutDefaultParams(updatedJob.Id, updatedJob));
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobHeaderInformation, parameters.ToArray(), true);
        }

        private static void UpdateJobLocationInformation(Entities.Job.Job job, ActiveUser activeUser, bool isRelatedAttributeUpdate, bool isManualUpdate)
        {
            var parameters = GetJobDestinationParameters(job);
            parameters.Add(new Parameter("@IsRelatedAttributeUpdate", isRelatedAttributeUpdate));
            parameters.Add(new Parameter("@isDayLightSavingEnable", IsDayLightSavingEnable));
            parameters.Add(new Parameter("@isManualUpdate", isManualUpdate));
            parameters.AddRange(activeUser.PutDefaultParams(job.Id, job));
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobLocationInformation, parameters.ToArray(), true);
        }

        private static void CalculateJobMileage(ref Entities.Job.Job job, JobMapRoute mapRoute = null)
        {
            string googleAPIUrl = string.Empty;
            string originFullAddress = string.Empty;
            string deliveryfullAddress = string.Empty;
            job.JobOriginCountry = string.IsNullOrEmpty(job.JobOriginCountry) ? "USA" : job.JobOriginCountry;
            job.JobDeliveryCountry = string.IsNullOrEmpty(job.JobDeliveryCountry) ? "USA" : job.JobDeliveryCountry;
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
            catch (Exception)
            {
                throw;
            }
        }

        public class CustomEntity
        {
            public long EntityId { get; set; }
        }

        public static DataTable GetJobCargoDT(List<JobCargo> jobCargos, ActiveUser activeUser)
        {
            if (jobCargos == null)
            {
                throw new ArgumentNullException("jobCargos", "JobCommands.GetJobCargoDT() - Argument null Exception");
            }

            int lineNumber = 0;
            using (var jobCargoUTT = new DataTable("uttjobCargo"))
            {
                jobCargoUTT.Locale = CultureInfo.InvariantCulture;
                jobCargoUTT.Columns.Add("JobID");
                jobCargoUTT.Columns.Add("CgoLineItem");
                jobCargoUTT.Columns.Add("CgoPartNumCode");
                jobCargoUTT.Columns.Add("CgoTitle");
                jobCargoUTT.Columns.Add("CgoSerialNumber");
                jobCargoUTT.Columns.Add("CgoPackagingType");
                jobCargoUTT.Columns.Add("CgoWeight");
                jobCargoUTT.Columns.Add("CgoWeightUnits");
                jobCargoUTT.Columns.Add("CgoVolumeUnits");
                jobCargoUTT.Columns.Add("CgoCubes");
                jobCargoUTT.Columns.Add("CgoQtyUnits");
                jobCargoUTT.Columns.Add("CgoQTYOrdered");
                jobCargoUTT.Columns.Add("CgoPackagingTypeId");
                jobCargoUTT.Columns.Add("CgoQtyUnitsId");
                jobCargoUTT.Columns.Add("CgoWeightUnitsId");
                jobCargoUTT.Columns.Add("CgoVolumeUnitsId");
                jobCargoUTT.Columns.Add("CgoSerialBarcode");
                jobCargoUTT.Columns.Add("CgoLineNumber");
                jobCargoUTT.Columns.Add("StatusId");
                jobCargoUTT.Columns.Add("EnteredBy");
                jobCargoUTT.Columns.Add("DateEntered");

                foreach (var jobCargo in jobCargos)
                {
                    var row = jobCargoUTT.NewRow();
                    lineNumber = lineNumber + 1;
                    row["JobID"] = jobCargo.JobID;
                    row["CgoLineItem"] = lineNumber;
                    row["CgoPartNumCode"] = jobCargo.CgoPartNumCode;
                    row["CgoTitle"] = jobCargo.CgoTitle;
                    row["CgoSerialNumber"] = jobCargo.CgoSerialNumber;
                    row["CgoPackagingType"] = jobCargo.CgoPackagingTypeIdName;
                    row["CgoWeight"] = jobCargo.CgoWeight;
                    row["CgoWeightUnits"] = jobCargo.CgoWeightUnitsIdName;
                    row["CgoVolumeUnits"] = jobCargo.CgoVolumeUnitsIdName;
                    row["CgoCubes"] = jobCargo.CgoCubes;
                    row["CgoQtyUnits"] = jobCargo.CgoQtyUnitsIdName;
                    row["CgoQtyOrdered"] = jobCargo.CgoQtyOrdered;
                    row["CgoPackagingTypeId"] = jobCargo.CgoPackagingTypeId;
                    row["CgoQtyUnitsId"] = jobCargo.CgoQtyUnitsId;
                    row["CgoWeightUnitsId"] = jobCargo.CgoWeightUnitsId;
                    row["CgoVolumeUnitsId"] = jobCargo.CgoVolumeUnitsId;
                    row["CgoSerialBarcode"] = jobCargo.CgoSerialBarcode;
                    row["CgoLineNumber"] = jobCargo.CgoLineNumber;
                    row["StatusId"] = jobCargo.StatusId;
                    row["EnteredBy"] = activeUser.UserName;
                    row["DateEntered"] = Utilities.TimeUtility.GetPacificDateTime();
                    jobCargoUTT.Rows.Add(row);
                    jobCargoUTT.AcceptChanges();
                }

                return jobCargoUTT;
            }
        }

        public static int UpdateJobCompleted(long custId, long programId, long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate, ActiveUser activeUser)
        {
            int count = 0;
            List<Entities.Job.Job> updatedJobs = new List<Entities.Job.Job>();
            var parameters = new[]
            {
               new Parameter("@JobId",jobId),
               new Parameter("@ProgramId",programId),
               new Parameter("@CustId",custId),
               new Parameter("@user", activeUser.UserName),
               new Parameter("@DeliveryDate",deliveryDate),
               new Parameter("@IncludeNullableDeliveryDate",includeNullableDeliveryDate),
               new Parameter("@DateEntered", TimeUtility.GetPacificDateTime())
            };
            try
            {
                count = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.CompleteJobById, parameters, storedProcedure: true);
                return count;
            }
            catch (Exception)
            {
                return count;
            }
        }

        public static List<Entities.Job.Job> GetActiveJobByProgramId(long programId)
        {
            var parameters = new[]
            {
               new Parameter("@ProgramId",programId),
            };
            try
            {
                return SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.Job>(StoredProceduresConstant.GetActiveJobByProgram, parameters, storedProcedure: true);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static bool UpdateJobInvoiceDetail(long jobId, JobInvoiceDetail jobInvoiceDetail, ActiveUser activeUser)
        {
            bool result = true;
            var parameters = new[]
                {
                        new Parameter("@JobId",jobId),
                        new Parameter("@JobPurchaseInvoiceNumber",jobInvoiceDetail.JobPurchaseInvoiceNumber),
                        new Parameter("@JobSalesInvoiceNumber",jobInvoiceDetail.JobSalesInvoiceNumber),
                        new Parameter("@JobInvoicedDate",jobInvoiceDetail.JobInvoicedDate),
                        new Parameter("@UpdatedBy",activeUser.UserName),
                        new Parameter("@UpdatedDate", TimeUtility.GetPacificDateTime())
                 };
            try
            {
                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobInvoiceDetail, parameters, storedProcedure: true);
            }
            catch (Exception)
            {
                result = false;
            }

            return result;
        }

        public static long AddJobIsSchedule(long jobId, DateTime scheduleDate, string statusCode, ActiveUser activeUser)
        {
            long gatewayId = 0;
            var parameters = new[]
            {
               new Parameter("@JobId",jobId),
               new Parameter("@StatusCode",statusCode),
               new Parameter("@GwyDDPNew",scheduleDate),
               new Parameter("@IsDayLightSavingEnable", IsDayLightSavingEnable),
               new Parameter("@DateEntered", TimeUtility.GetPacificDateTime()),
               new Parameter("@EnteredBy", activeUser.UserName),
            };
            try
            {
                gatewayId = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsertJobIsSchedule, parameters, storedProcedure: true);
                return gatewayId;
            }
            catch (Exception ex)
            {
                return gatewayId;
            }
        }
    }
}