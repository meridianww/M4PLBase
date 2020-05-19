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
using System.Data;
using System.Globalization;
using _programCostCommand = M4PL.DataAccess.Program.PrgCostRateCommands;
using M4PL.Entities.Program;
using System.Linq;

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

		public static void InsertJobCostSheetData(List<JobCostSheet> costCodeData, long jobId)
		{
			try
			{
				var parameters = new[]
				 {
					  new Parameter("@uttJobCostCode", GetJobCostRateDT(costCodeData)),
					  new Parameter("@jobId", jobId)
				 };

				SqlSerializer.Default.Execute(StoredProceduresConstant.InsertJobCostSheetData, parameters, true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error occuring while insertion data for Cost Code", "InsertJobCostSheetData", Utilities.Logger.LogType.Error);
			}
		}

		public static void UpdateCostCodeDetailsForOrder(long jobId, List<JobCargo> cargoDetails, string locationCode, int serviceId, long programId, ActiveUser activeUser)
		{
			List<JobCostSheet> jobCostSheetList = new List<JobCostSheet>(); ;
			PrgCostRate currentPrgCostRate = null;
			var priceCodeData = _programCostCommand.GetProgramCostRate(activeUser, programId, locationCode);
			if (priceCodeData?.Count > 0)
			{
				currentPrgCostRate = priceCodeData?.Where(x => x.IsDefault)?.FirstOrDefault();
				if (currentPrgCostRate != null)
				{
					jobCostSheetList.Add(new JobCostSheet()
					{
						ItemNumber = currentPrgCostRate.ItemNumber,
						JobID = jobId,
						CstLineItem = currentPrgCostRate.ItemNumber.ToString(),
						CstChargeID = currentPrgCostRate.Id,
						CstChargeCode = currentPrgCostRate.PcrCode,
						CstTitle = currentPrgCostRate.PcrTitle,
						CstUnitId = currentPrgCostRate.RateUnitTypeId,
						CstRate = currentPrgCostRate.PcrCostRate,
						ChargeTypeId = currentPrgCostRate.RateTypeId,
						StatusId = currentPrgCostRate.StatusId,
						CstQuantity = 1,
						CstElectronicBilling = currentPrgCostRate.PcrElectronicBilling,
						DateEntered = DateTime.UtcNow,
						EnteredBy = activeUser.UserName
					});
				}
			}

			if (cargoDetails?.Count > 0)
			{
				foreach (var cargoLineItem in cargoDetails)
				{
					currentPrgCostRate = cargoLineItem.CgoPackagingTypeId == serviceId ? priceCodeData.Where(x => x.PcrVendorCode == cargoLineItem.CgoPartNumCode)?.FirstOrDefault() : null;
					if (currentPrgCostRate != null)
					{
						jobCostSheetList.Add(new JobCostSheet()
						{
							ItemNumber = currentPrgCostRate.ItemNumber,
							JobID = jobId,
							CstLineItem = currentPrgCostRate.ItemNumber.ToString(),
							CstChargeID = currentPrgCostRate.Id,
							CstChargeCode = currentPrgCostRate.PcrCode,
							CstTitle = currentPrgCostRate.PcrTitle,
							CstUnitId = currentPrgCostRate.RateUnitTypeId,
							CstRate = currentPrgCostRate.PcrCostRate,
							ChargeTypeId = currentPrgCostRate.RateTypeId,
							StatusId = currentPrgCostRate.StatusId,
							CstElectronicBilling = currentPrgCostRate.PcrElectronicBilling,
							CstQuantity = 1,
							DateEntered = DateTime.UtcNow,
							EnteredBy = activeUser.UserName
						});
					}
				}
			}

			InsertJobCostSheetData(jobCostSheetList, jobId);
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

		public static DataTable GetJobCostRateDT(List<JobCostSheet> jobCostSheetList)
		{
			using (var jobCostCodeUTT = new DataTable("uttJobCostCode"))
			{
				jobCostCodeUTT.Locale = CultureInfo.InvariantCulture;
				jobCostCodeUTT.Columns.Add("LineNumber");
				jobCostCodeUTT.Columns.Add("JobID");
				jobCostCodeUTT.Columns.Add("CstLineItem");
				jobCostCodeUTT.Columns.Add("CstChargeID");
				jobCostCodeUTT.Columns.Add("CstChargeCode");
				jobCostCodeUTT.Columns.Add("CstTitle");
				jobCostCodeUTT.Columns.Add("CstUnitId");
				jobCostCodeUTT.Columns.Add("CstRate");
				jobCostCodeUTT.Columns.Add("ChargeTypeId");
				jobCostCodeUTT.Columns.Add("StatusId");
				jobCostCodeUTT.Columns.Add("EnteredBy");
				jobCostCodeUTT.Columns.Add("DateEntered");
				if (jobCostSheetList?.Count > 0)
				{
					int count = 1;
					int linenumber = 10000;
					foreach (var jobBillableRate in jobCostSheetList)
					{
						var row = jobCostCodeUTT.NewRow();
						row["LineNumber"] = linenumber;
						row["JobID"] = jobBillableRate.JobID;
						row["CstLineItem"] = count;
						row["CstChargeID"] = jobBillableRate.CstChargeID;
						row["CstChargeCode"] = jobBillableRate.CstChargeCode;
						row["CstTitle"] = jobBillableRate.CstTitle;
						row["CstUnitId"] = jobBillableRate.CstUnitId;
						row["CstRate"] = jobBillableRate.CstRate;
						row["ChargeTypeId"] = jobBillableRate.ChargeTypeId;
						row["StatusId"] = jobBillableRate.StatusId;
						row["EnteredBy"] = jobBillableRate.EnteredBy;
						row["DateEntered"] = jobBillableRate.DateEntered;
						jobCostCodeUTT.Rows.Add(row);
						jobCostCodeUTT.AcceptChanges();
						count = count + 1;
						linenumber = linenumber + 1;
					}
				}

				return jobCostCodeUTT;
			}
		}
	}
}