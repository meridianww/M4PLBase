
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using M4PL.Utilities;

namespace M4PL.DataAccess.Job
{
    public class JobCardCommands : BaseCommands<Entities.Job.JobCard>
    {
        /// <summary>
        /// Gets list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Job.JobCard> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = GetParameters(pagedDataInfo, activeUser, null);
            var results = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobCard>(StoredProceduresConstant.GetJobCardView, parameters.ToArray(), storedProcedure: true);
            if (!(parameters[parameters.ToArray().Length - 1].Value is DBNull))
                pagedDataInfo.TotalCount = Convert.ToInt32(parameters[parameters.ToArray().Length - 1].Value);
            else pagedDataInfo.TotalCount = 0;

            return results;
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

        /// <summary>
        /// Deletes a specific JobAdvanceReport record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return 0;
        }

        /// <summary>
        /// Deletes list of JobAdvanceReport records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobAdvanceReport, statusId, ReservedKeysEnum.StatusId);
        }

        public static Entities.Job.JobCard GetJobByProgram(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.JobCard>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.JobCard();
        }

        public static IList<JobsSiteCode> GetJobsSiteCodeByProgram(ActiveUser activeUser, long id, long parentId, bool isNullFIlter = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            parameters.Add(new Parameter("@isNullFIlter", isNullFIlter));
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobsSiteCode>(StoredProceduresConstant.GetJobsSiteCodeByProgram, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<JobsSiteCode>();
        }
        /// <summary>
        /// Updates the existing Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="job"></param>
        /// <returns></returns>

        public static Entities.Job.JobCard Put(ActiveUser activeUser, Entities.Job.JobCard job)
        {
            var parameters = GetJobParameters(job);
            parameters.AddRange(activeUser.PutDefaultParams(job.Id, job));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJob);
        }
        private static List<Parameter> GetParameters(PagedDataInfo pagedDataInfo, ActiveUser activeUser, Entities.Job.JobAdvanceReport jobAdvanceReport)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@entity", pagedDataInfo.Entity.ToString()),
               new Parameter("@pageNo", pagedDataInfo.PageNumber),
               new Parameter("@pageSize", pagedDataInfo.PageSize),
               new Parameter("@orderBy", pagedDataInfo.OrderBy),
               new Parameter("@where", pagedDataInfo.WhereCondition),
               new Parameter("@parentId", pagedDataInfo.ParentId),
               new Parameter("@isNext", pagedDataInfo.IsNext),
               new Parameter("@isEnd", pagedDataInfo.IsEnd),
               new Parameter("@recordId", pagedDataInfo.RecordId),
               new Parameter("@groupBy", pagedDataInfo.GroupBy),
               new Parameter("@IsExport", pagedDataInfo.IsJobParentEntity),
               new Parameter("@groupByWhere", pagedDataInfo.GroupByWhereCondition)
            };


            if (pagedDataInfo.Params != null)
            {
                var data = JsonConvert.DeserializeObject<JobCardRequest>(pagedDataInfo.Params);
                if (!string.IsNullOrEmpty(data.CardName) && !string.IsNullOrWhiteSpace(data.CardName) 
                    && !string.IsNullOrEmpty(data.CardType))
                {
                    string cardTile = string.Format(" '{0}' ", data.CardName);
                    parameters.Add(new Parameter("@cardTileName", cardTile));
                    parameters.Add(new Parameter("@cardType", data.CardType));
                }
                   
            }
            parameters.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));

            return parameters;
        }

        /// <summary>
        /// Gets list of Job card title
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public static IList<JobCardTileDetail> GetCardTileData(long companyId)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@CompanyId", companyId)
            };

            var result = SqlSerializer.Default.DeserializeMultiRecords<JobCardTileDetail>(StoredProceduresConstant.GetCardTileData, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<JobCardTileDetail>();            
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

        /// <summary>
        /// Gets list of parameters required for the Job Module
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        private static List<Parameter> GetJobParameters(Entities.Job.JobCard job)
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
               new Parameter("@jobDeliveryDateTimePlanned", job.JobDeliveryDateTimePlanned.HasValue ? job.JobDeliveryDateTimePlanned.Value.ToUniversalDateTime() : job.JobDeliveryDateTimePlanned),
               new Parameter("@jobDeliveryDateTimeActual", job.JobDeliveryDateTimeActual.HasValue ? job.JobDeliveryDateTimeActual.Value.ToUniversalDateTime() : job.JobDeliveryDateTimeActual),
               new Parameter("@jobDeliveryDateTimeBaseline", job.JobDeliveryDateTimeBaseline.HasValue ? job.JobDeliveryDateTimeBaseline.Value.ToUniversalDateTime() : job.JobDeliveryDateTimeBaseline),
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

                new Parameter("@jobOriginDateTimePlanned",job.JobOriginDateTimePlanned.HasValue  && (job.JobOriginDateTimePlanned.Value !=DateUtility.SystemEarliestDateTime) ? job.JobOriginDateTimePlanned.Value.ToUniversalDateTime() :job.JobOriginDateTimePlanned ),
                new Parameter("@jobOriginDateTimeActual",job.JobOriginDateTimeActual.HasValue  && (job.JobOriginDateTimeActual.Value !=DateUtility.SystemEarliestDateTime) ? job.JobOriginDateTimeActual.Value.ToUniversalDateTime() :job.JobOriginDateTimeActual),
                new Parameter("@jobOriginDateTimeBaseline",job.JobOriginDateTimeBaseline.HasValue  && (job.JobOriginDateTimeBaseline.Value !=DateUtility.SystemEarliestDateTime) ? job.JobOriginDateTimeBaseline.Value.ToUniversalDateTime() :job.JobOriginDateTimeBaseline),

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
               new Parameter("@windowDelStartTime", job.WindowDelStartTime.HasValue && (job.WindowDelStartTime.Value !=DateUtility.SystemEarliestDateTime)  ? job.WindowDelStartTime.Value.ToUniversalDateTime() :job.WindowDelStartTime ),
               new Parameter("@windowDelEndTime", job.WindowDelEndTime.HasValue  && (job.WindowDelEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowDelEndTime.Value.ToUniversalDateTime() :job.WindowDelEndTime),
               new Parameter("@windowPckStartTime", job.WindowPckStartTime.HasValue && (job.WindowPckStartTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckStartTime.Value.ToUniversalDateTime() :job.WindowPckStartTime),
               new Parameter("@windowPckEndTime", job.WindowPckEndTime.HasValue && (job.WindowPckEndTime.Value !=DateUtility.SystemEarliestDateTime)  ?job.WindowPckEndTime.Value.ToUniversalDateTime() :job.WindowPckEndTime),
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
            };

            return parameters;
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
                new Parameter("@jobDeliveryDateTimePlanned"   ,job2ndPoc.JobDeliveryDateTimePlanned.HasValue ? job2ndPoc.JobDeliveryDateTimePlanned.Value.ToUniversalDateTime() : job2ndPoc.JobDeliveryDateTimePlanned),
                new Parameter("@jobDeliveryDateTimeActual"    ,job2ndPoc.JobDeliveryDateTimeActual.HasValue ? job2ndPoc.JobDeliveryDateTimeActual.Value.ToUniversalDateTime() : job2ndPoc.JobDeliveryDateTimeActual),
                new Parameter("@jobDeliveryDateTimeBaseline"  ,job2ndPoc.JobDeliveryDateTimeBaseline.HasValue ? job2ndPoc.JobDeliveryDateTimeBaseline.Value.ToUniversalDateTime() : job2ndPoc.JobDeliveryDateTimeBaseline),
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
                new Parameter("@jobOriginDateTimePlanned"     ,job2ndPoc.JobOriginDateTimePlanned.HasValue ? job2ndPoc.JobOriginDateTimePlanned.Value.ToUniversalDateTime() : job2ndPoc.JobOriginDateTimePlanned),
                new Parameter("@jobOriginDateTimeActual"      ,job2ndPoc.JobOriginDateTimeActual.HasValue ? job2ndPoc.JobOriginDateTimeActual.Value.ToUniversalDateTime() : job2ndPoc.JobOriginDateTimeActual),
                new Parameter("@jobOriginDateTimeBaseline"    ,job2ndPoc.JobOriginDateTimeBaseline.HasValue ? job2ndPoc.JobOriginDateTimeBaseline.Value.ToUniversalDateTime() : job2ndPoc.JobOriginDateTimeBaseline),
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
    }
}