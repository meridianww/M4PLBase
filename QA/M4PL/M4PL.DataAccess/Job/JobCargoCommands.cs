/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCargoCommands
Purpose:                                      Contains commands to perform CRUD on JobCargo
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobCargoCommands : BaseCommands<JobCargo>
    {
        /// <summary>
        /// Gets list of JobCargo records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobCargo> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobCargoView, EntitiesAlias.JobCargo);
        }

        /// <summary>
        /// Gets the specific JobCargo record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobCargo Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobCargo);
        }

        /// <summary>
        /// Gets the specific JobCargo record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static List<JobCargo> GetCargoListForJob(ActiveUser activeUser, long jobId)
        {
            List<JobCargo> cargoList = null;
            try
            {
                cargoList = SqlSerializer.Default.DeserializeMultiRecords<JobCargo>(StoredProceduresConstant.GetCargoListForJob, new Parameter("@jobId", jobId), false, true);
            }
            catch (Exception exp)
            {
                Logger.ErrorLogger.Log(exp, "Error is occuring while GetCargoListForJob", "GetCargoListForJob", Utilities.Logger.LogType.Error);
            }

            return cargoList;
        }

        /// <summary>
        /// Creates a new JobCargo record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public static JobCargo Post(ActiveUser activeUser, JobCargo jobCargo)
        {
            var parameters = GetParameters(jobCargo);
            parameters.AddRange(activeUser.PostDefaultParams(jobCargo));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobCargo);
        }

        /// <summary>
        /// Updates the existing JobCargo record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public static JobCargo Put(ActiveUser activeUser, JobCargo jobCargo)
        {
            var parameters = GetParameters(jobCargo);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobCargo.Id, jobCargo));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobCargo);
        }

        /// <summary>
        /// Deletes a specific JobCargo record
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
        /// Deletes list of JobCargo records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobCargo, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the JobCargo Module
        /// </summary>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobCargo jobCargo)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobCargo.JobID),
               new Parameter("@cgoLineItem", jobCargo.CgoLineItem),
               new Parameter("@cgoPartNumCode", jobCargo.CgoPartNumCode),
               new Parameter("@cgoTitle", jobCargo.CgoTitle),
               new Parameter("@cgoSerialNumber", jobCargo.CgoSerialNumber),
               new Parameter("@cgoPackagingType", jobCargo.CgoPackagingTypeId),
               new Parameter("@cgoMasterCartonLabel", jobCargo.CgoMasterCartonLabel),
               new Parameter("@cgoWeight", jobCargo.CgoWeight),
               new Parameter("@cgoWeightUnits", jobCargo.CgoWeightUnitsId),
               new Parameter("@cgoLength", jobCargo.CgoLength),
               new Parameter("@cgoWidth", jobCargo.CgoWidth ),
               new Parameter("@cgoHeight", jobCargo.CgoHeight),
               new Parameter("@cgoVolumeUnits", jobCargo.CgoVolumeUnitsId),
               new Parameter("@cgoCubes", jobCargo.CgoCubes),
               new Parameter("@cgoQtyExpected", jobCargo.CgoQtyExpected),
               new Parameter("@cgoQtyOnHand", jobCargo.CgoQtyOnHand),
               new Parameter("@cgoQtyDamaged", jobCargo.CgoQtyDamaged),
               new Parameter("@cgoQtyOnHold", jobCargo.CgoQtyOnHold),
               new Parameter("@cgoQtyShortOver", jobCargo.CgoQtyShortOver),
               new Parameter("@cgoQtyUnits", jobCargo.CgoQtyUnitsId),
               new Parameter("@cgoReasonCodeOSD", jobCargo.CgoReasonCodeOSD),
               new Parameter("@cgoReasonCodeHold", jobCargo.CgoReasonCodeHold),
               new Parameter("@cgoSeverityCode", jobCargo.CgoSeverityCode),
               new Parameter("@cgoLatitude", jobCargo.CgoLatitude),
               new Parameter("@cgoLongitude", jobCargo.CgoLongitude),
               new Parameter("@cgoProcessingFlags", jobCargo.CgoProcessingFlags),
               new Parameter("@statusId", jobCargo.StatusId),
               new Parameter("@CgoComment",jobCargo.CgoComment)
            };
            return parameters;
        }
    }
}