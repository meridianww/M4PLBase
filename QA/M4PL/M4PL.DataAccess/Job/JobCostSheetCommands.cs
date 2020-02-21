/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              25/07/2019
Program Name:                                 JobCostSheetCommands
Purpose:                                      Contains commands to perform CRUD on JobCostSheet
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System;

namespace M4PL.DataAccess.Job
{
    public class JobCostSheetCommands : BaseCommands<JobCostSheet>
    {
        /// <summary>
        /// Gets list of JobRefCostSheet records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobCostSheet> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobCostSheetView, EntitiesAlias.JobCostSheet);
        }

        /// <summary>
        /// Gets the specific JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobCostSheet Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobCostSheet);
        }

        /// <summary>
        /// Creates a new JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public static JobCostSheet Post(ActiveUser activeUser, JobCostSheet jobRefCostSheet)
        {
            var parameters = GetParameters(jobRefCostSheet);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobRefCostSheet));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobCostSheet);
        }

        /// <summary>
        /// Updates the existing JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public static JobCostSheet Put(ActiveUser activeUser, JobCostSheet jobRefCostSheet)
        {
            var parameters = GetParameters(jobRefCostSheet);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobRefCostSheet.Id, jobRefCostSheet));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobCostSheet);
        }

		public static IList<JobCostCodeAction> GetJobCostCodeAction(ActiveUser activeUser, long jobId)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", jobId)
			};

			var result = SqlSerializer.Default.DeserializeMultiRecords<JobCostCodeAction>(StoredProceduresConstant.GetJobCostCodeAction, parameters.ToArray(), storedProcedure: true);

			return result;
		}

		public static JobCostSheet JobCostCodeByProgram(ActiveUser activeUser, long id, long jobId)
		{
			var parameters = new[]
		  {
				new Parameter("@id", id),
				new Parameter("@jobId", jobId)
			};

			return SqlSerializer.Default.DeserializeSingleRecord<JobCostSheet>(StoredProceduresConstant.GetJobCostCodeByProgram, parameters,
				storedProcedure: true);
		}

		/// <summary>
		/// Deletes a specific JobRefCostSheet record
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
        /// Deletes list of JobRefCostSheet records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobCostSheet, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the JobRefCostSheet Module
        /// </summary>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobCostSheet jobRefCostSheet)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobRefCostSheet.JobID),
               new Parameter("@cstLineItem", jobRefCostSheet.CstLineItem),
               new Parameter("@cstChargeId", jobRefCostSheet.CstChargeID),
               new Parameter("@cstChargeCode", jobRefCostSheet.CstChargeCode),
               new Parameter("@cstTitle", jobRefCostSheet.CstTitle),
               new Parameter("@cstSurchargeOrder", jobRefCostSheet.CstSurchargeOrder),
               new Parameter("@cstSurchargePercent", jobRefCostSheet.CstSurchargePercent),
               new Parameter("@chargeTypeId", jobRefCostSheet.ChargeTypeId),
               new Parameter("@cstNumberUsed", jobRefCostSheet.CstNumberUsed),
               new Parameter("@cstDuration", jobRefCostSheet.CstDuration),
               new Parameter("@cstQuantity", jobRefCostSheet.CstQuantity),
               new Parameter("@costUnitId", jobRefCostSheet.CstUnitId),
               new Parameter("@cstCostRate", jobRefCostSheet.CstRate),
               new Parameter("@cstCost", jobRefCostSheet.CstAmount),
               new Parameter("@cstMarkupPercent", jobRefCostSheet.CstMarkupPercent),
               new Parameter("@statusId", jobRefCostSheet.StatusId),
			   new Parameter("@cstElectronicBilling", jobRefCostSheet.CstElectronicBilling),
			};
            return parameters;
        }
    }
}