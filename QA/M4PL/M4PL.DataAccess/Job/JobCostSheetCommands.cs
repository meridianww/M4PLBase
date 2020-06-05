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
using System.Threading.Tasks;

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
			JobCostSheet result = null;
			var parameters = GetParameters(jobRefCostSheet);
            parameters.AddRange(activeUser.PostDefaultParams(jobRefCostSheet));
			result = Post(activeUser, parameters, StoredProceduresConstant.InsertJobCostSheet);
			if (result?.Id > 0 && jobRefCostSheet.IsProblem.Equals(result.IsProblem))
			{
				Task.Run(() =>
				{
					UpdateJobBillableSheet(activeUser, jobRefCostSheet);
				});
			}

			return result;
		}

		public static void UpdateJobBillableSheet(ActiveUser activeUser, JobCostSheet jobRefCostSheet)
		{
			try
			{
				var parameters = GetParameterForBillableSheet(jobRefCostSheet, activeUser);
				parameters.AddRange(activeUser.PostDefaultParams(jobRefCostSheet));
				SqlSerializer.Default.DeserializeSingleRecord<JobBillableSheet>(StoredProceduresConstant.InsertJobBillableSheet, parameters.ToArray(), storedProcedure: true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error while Update Billable Sheet From Cost Sheet.", "UpdateJobBillableSheet", Utilities.Logger.LogType.Error);
			}
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

		public static List<JobCostSheet> GetCostCodeDetailsForElectroluxOrder(long jobId, List<JobCargo> cargoDetails, string locationCode, int serviceId, long programId, ActiveUser activeUser, List<PrgCostRate> programCostRate, int? quantity)
		{
			List<JobCostSheet> jobCostSheetList = new List<JobCostSheet>(); ;
			PrgCostRate currentPrgCostRate = null;
			if (programCostRate?.Count > 0)
			{
				currentPrgCostRate = programCostRate?.Where(x => x.IsDefault)?.FirstOrDefault();
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
						DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
						EnteredBy = activeUser.UserName
					});
				}

				if (cargoDetails?.Count > 0)
				{
					foreach (var cargoLineItem in cargoDetails)
					{
						currentPrgCostRate = cargoLineItem.CgoPackagingTypeId == serviceId ? programCostRate.Where(x => x.PcrVendorCode == cargoLineItem.CgoPartNumCode)?.FirstOrDefault() : null;
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
								DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
								EnteredBy = activeUser.UserName
							});
						}
					}
				}
			}

			return jobCostSheetList;
		}

		public static List<JobCostSheet> GetCostCodeDetailsForOrder(long jobId, ActiveUser activeUser, List<PrgCostRate> programCostRate, int? quantity)
		{
			List<JobCostSheet> jobCostSheetList = null;
			if (programCostRate?.Count > 0)
			{
				jobCostSheetList = new List<JobCostSheet>();
				jobCostSheetList.AddRange(programCostRate.Select(jobCostSheetItem => new JobCostSheet() {
					ItemNumber = jobCostSheetItem.ItemNumber,
					JobID = jobId,
					CstLineItem = jobCostSheetItem.ItemNumber.ToString(),
					CstChargeID = jobCostSheetItem.Id,
					CstChargeCode = jobCostSheetItem.PcrCode,
					CstTitle = jobCostSheetItem.PcrTitle,
					CstUnitId = jobCostSheetItem.RateUnitTypeId,
					CstRate = jobCostSheetItem.PcrCostRate,
					ChargeTypeId = jobCostSheetItem.RateTypeId,
					StatusId = jobCostSheetItem.StatusId,
					CstQuantity = quantity.HasValue ? (decimal)quantity : 0,
					CstElectronicBilling = jobCostSheetItem.PcrElectronicBilling,
					DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
					EnteredBy = activeUser.UserName
				}));
			}

			return jobCostSheetList;
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
			   new Parameter("@isProblem", jobRefCostSheet.IsProblem)
			};
            return parameters;
        }

		private static List<Parameter> GetParameterForBillableSheet(JobCostSheet jobRefCostSheet, ActiveUser activeUser)
		{
			List<PrgBillableRate> prgCostRate = Program.PrgBillableRateCommands.GetProgramBillableRate(activeUser, 0, null, jobRefCostSheet.JobID);
			PrgBillableRate currentProgramRate = prgCostRate?.Where(x => x.PbrCode == jobRefCostSheet.CstChargeCode)?.FirstOrDefault();
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", jobRefCostSheet.JobID),
			   new Parameter("@prcLineItem", jobRefCostSheet.CstLineItem),
			   new Parameter("@prcChargeId", currentProgramRate != null ? currentProgramRate.Id : 0),
			   new Parameter("@prcChargeCode", jobRefCostSheet.CstChargeCode),
			   new Parameter("@prcTitle", jobRefCostSheet.CstTitle),
			   new Parameter("@prcSurchargeOrder", jobRefCostSheet.CstSurchargeOrder),
			   new Parameter("@prcSurchargePercent", jobRefCostSheet.CstSurchargePercent),
			   new Parameter("@chargeTypeId", jobRefCostSheet.ChargeTypeId),
			   new Parameter("@prcNumberUsed", jobRefCostSheet.CstNumberUsed),
			   new Parameter("@prcDuration", jobRefCostSheet.CstDuration),
			   new Parameter("@prcQuantity", jobRefCostSheet.CstQuantity),
			   new Parameter("@costUnitId", jobRefCostSheet.CstUnitId),
			   new Parameter("@prcCostRate", currentProgramRate != null ? currentProgramRate.PbrBillablePrice : decimal.Zero),
			   new Parameter("@prcCost", currentProgramRate != null ? currentProgramRate.PbrBillablePrice : decimal.Zero),
			   new Parameter("@prcMarkupPercent", jobRefCostSheet.CstMarkupPercent),
			   new Parameter("@statusId", jobRefCostSheet.StatusId),
			   new Parameter("@prcElectronicBilling", jobRefCostSheet.CstElectronicBilling),
			   new Parameter("@isProblem", jobRefCostSheet.IsProblem)
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
				jobCostCodeUTT.Columns.Add("CstQuantity");
				jobCostCodeUTT.Columns.Add("CstElectronicBilling");
				jobCostCodeUTT.Columns.Add("IsProblem");
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
						row["CstQuantity"] = jobBillableRate.CstQuantity;
						row["CstElectronicBilling"] = jobBillableRate.CstElectronicBilling;
						row["IsProblem"] = jobBillableRate.CstChargeID > 0 ? false : true;
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