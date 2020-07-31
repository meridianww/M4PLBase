#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Nikhil
// Date Programmed:                              29/07/2019
// Program Name:                                 JobBillableSheetCommands
// Purpose:                                      Contains commands to perform CRUD on JobBillableSheet
//=============================================================================================================
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Job
{
	public class JobBillableSheetCommands : BaseCommands<JobBillableSheet>
	{
		/// <summary>
		/// Gets list of JobBillableSheet records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<JobBillableSheet> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobBillableSheetView, EntitiesAlias.JobBillableSheet);
		}

		/// <summary>
		/// Gets the specific JobBillableSheet record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static JobBillableSheet Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetJobBillableSheet);
		}

		/// <summary>
		/// Creates a new JobBillableSheet record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="jobBillableSheet"></param>
		/// <returns></returns>

		public static JobBillableSheet Post(ActiveUser activeUser, JobBillableSheet jobBillableSheet)
		{
			JobBillableSheet result = null;
			var parameters = GetParameters(jobBillableSheet);
			parameters.AddRange(activeUser.PostDefaultParams(jobBillableSheet));
			result = Post(activeUser, parameters, StoredProceduresConstant.InsertJobBillableSheet);
			if (result?.Id > 0 && jobBillableSheet.IsProblem.Equals(result.IsProblem))
			{
				Task.Run(() =>
				{
					UpdateJobCostSheet(activeUser, jobBillableSheet);
				});
			}

			return result;
		}

		public static void UpdateJobCostSheet(ActiveUser activeUser, JobBillableSheet jobBillableSheet)
		{
			try
			{
				var parameters = GetParameterForCostSheet(jobBillableSheet, activeUser);
				parameters.AddRange(activeUser.PostDefaultParams(jobBillableSheet));
				SqlSerializer.Default.DeserializeSingleRecord<JobBillableSheet>(StoredProceduresConstant.InsertJobCostSheet, parameters.ToArray(), storedProcedure: true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error while Update Cost Sheet From Billable Sheet.", "UpdateJobCostSheet", Utilities.Logger.LogType.Error);
			}
		}

		/// <summary>
		/// Updates the existing JobBillableSheet record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="jobBillableSheet"></param>
		/// <returns></returns>

		public static JobBillableSheet Put(ActiveUser activeUser, JobBillableSheet jobBillableSheet)
		{
			var parameters = GetParameters(jobBillableSheet);
			// parameters.Add(new Parameter("@langCode", entity.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(jobBillableSheet.Id, jobBillableSheet));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobBillableSheet);
		}

		/// <summary>
		/// Deletes a specific JobBillableSheet record
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
		/// Deletes list of JobBillableSheet records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.JobBillableSheet, statusId, ReservedKeysEnum.StatusId);
		}

		public static IList<JobPriceCodeAction> GetJobPriceCodeAction(ActiveUser activeUser, long jobId)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", jobId)
			};

			var result = SqlSerializer.Default.DeserializeMultiRecords<JobPriceCodeAction>(StoredProceduresConstant.GetJobPriceCodeAction, parameters.ToArray(), storedProcedure: true);

			return result;
		}

		public static JobBillableSheet JobPriceCodeByProgram(ActiveUser activeUser, long id, long jobId)
		{
			var parameters = new[]
		  {
				new Parameter("@id", id),
				new Parameter("@jobId", jobId)
			};

			return SqlSerializer.Default.DeserializeSingleRecord<JobBillableSheet>(StoredProceduresConstant.GetJobPriceCodeByProgram, parameters, storedProcedure: true);
		}

		public static void InsertJobBillableSheetData(List<JobBillableSheet> jobBillableSheetList, long jobId)
		{
			try
			{
				var parameters = new[]
				   {
					  new Parameter("@uttJobPriceCode", GetJobBillableRateDT(jobBillableSheetList)),
					  new Parameter("@jobId", jobId)
				 };

				SqlSerializer.Default.Execute(StoredProceduresConstant.InsertJobBillableSheetData, parameters, true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error occuring while insertion data for Price Code", "InsertJobBillableSheetData", Utilities.Logger.LogType.Error);
			}
		}

		public static List<JobBillableSheet> GetPriceCodeDetailsForElectroluxOrder(long jobId, List<JobCargo> cargoDetails, string locationCode, int serviceId, long programId, ActiveUser activeUser, List<PrgBillableRate> programBillableRate, int? quantity)
		{
			List<JobBillableSheet> jobBillableSheetList = null;
			PrgBillableRate currentPrgBillableRate = null;
			jobBillableSheetList = new List<JobBillableSheet>();
			if (programBillableRate?.Count > 0)
			{
				currentPrgBillableRate = programBillableRate?.Where(x => x.IsDefault)?.FirstOrDefault();
				if (currentPrgBillableRate != null)
				{
					jobBillableSheetList.Add(new JobBillableSheet()
					{
						ItemNumber = currentPrgBillableRate.ItemNumber,
						JobID = jobId,
						PrcLineItem = currentPrgBillableRate.ItemNumber.ToString(),
						PrcChargeID = currentPrgBillableRate.Id,
						PrcChargeCode = currentPrgBillableRate.PbrCode,
						PrcTitle = currentPrgBillableRate.PbrTitle,
						PrcUnitId = currentPrgBillableRate.RateUnitTypeId,
						PrcRate = currentPrgBillableRate.PbrBillablePrice,
						ChargeTypeId = currentPrgBillableRate.RateTypeId,
						StatusId = currentPrgBillableRate.StatusId,
						PrcElectronicBilling = currentPrgBillableRate.PbrElectronicBilling,
						PrcQuantity = 1,
						DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
						EnteredBy = activeUser.UserName
					});
				}

				if (cargoDetails?.Count > 0)
				{
					foreach (var cargoLineItem in cargoDetails)
					{
						currentPrgBillableRate = cargoLineItem.CgoPackagingTypeId == serviceId ? programBillableRate.Where(x => x.PbrCustomerCode == cargoLineItem.CgoPartNumCode)?.FirstOrDefault() : null;
						if (currentPrgBillableRate != null)
						{
							jobBillableSheetList.Add(new JobBillableSheet()
							{
								ItemNumber = currentPrgBillableRate.ItemNumber,
								JobID = jobId,
								PrcLineItem = currentPrgBillableRate.ItemNumber.ToString(),
								PrcChargeID = currentPrgBillableRate.Id,
								PrcChargeCode = currentPrgBillableRate.PbrCode,
								PrcTitle = currentPrgBillableRate.PbrTitle,
								PrcUnitId = currentPrgBillableRate.RateUnitTypeId,
								PrcRate = currentPrgBillableRate.PbrBillablePrice,
								ChargeTypeId = currentPrgBillableRate.RateTypeId,
								StatusId = currentPrgBillableRate.StatusId,
								PrcElectronicBilling = currentPrgBillableRate.PbrElectronicBilling,
								PrcQuantity = cargoLineItem.CgoQtyOrdered,
								DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
								EnteredBy = activeUser.UserName
							});
						}
					}
				}
			}

			return jobBillableSheetList;
		}

		public static List<JobBillableSheet> GetPriceCodeDetailsForOrder(long jobId, ActiveUser activeUser, List<PrgBillableRate> programBillableRate, int? quantity)
		{
			List<JobBillableSheet> jobBillableSheetList = null;
			if (programBillableRate?.Count > 0)
			{
				jobBillableSheetList = new List<JobBillableSheet>();
				jobBillableSheetList.AddRange(programBillableRate.Select(billableCharge => new JobBillableSheet()
				{
					ItemNumber = billableCharge.ItemNumber,
					JobID = jobId,
					PrcLineItem = billableCharge.ItemNumber.ToString(),
					PrcChargeID = billableCharge.Id,
					PrcChargeCode = billableCharge.PbrCode,
					PrcTitle = billableCharge.PbrTitle,
					PrcUnitId = billableCharge.RateUnitTypeId,
					PrcRate = billableCharge.PbrBillablePrice,
					ChargeTypeId = billableCharge.RateTypeId,
					StatusId = billableCharge.StatusId,
					PrcElectronicBilling = billableCharge.PbrElectronicBilling,
					PrcQuantity = quantity.HasValue ? (decimal)quantity : 0,
					DateEntered = Utilities.TimeUtility.GetPacificDateTime(),
					EnteredBy = activeUser.UserName
				}));
			}

			return jobBillableSheetList;
		}

		/// <summary>
		/// Gets list of parameters required for the JobBillableSheet Module
		/// </summary>
		/// <param name="jobBillableSheet"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(JobBillableSheet jobBillableSheet)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", jobBillableSheet.JobID),
			   new Parameter("@prcLineItem", jobBillableSheet.PrcLineItem),
			   new Parameter("@prcChargeId", jobBillableSheet.PrcChargeID),
			   new Parameter("@prcChargeCode", jobBillableSheet.PrcChargeCode),
			   new Parameter("@prcTitle", jobBillableSheet.PrcTitle),
			   new Parameter("@prcSurchargeOrder", jobBillableSheet.PrcSurchargeOrder),
			   new Parameter("@prcSurchargePercent", jobBillableSheet.PrcSurchargePercent),
			   new Parameter("@chargeTypeId", jobBillableSheet.ChargeTypeId),
			   new Parameter("@prcNumberUsed", jobBillableSheet.PrcNumberUsed),
			   new Parameter("@prcDuration", jobBillableSheet.PrcDuration),
			   new Parameter("@prcQuantity", jobBillableSheet.PrcQuantity),
			   new Parameter("@costUnitId", jobBillableSheet.PrcUnitId),
			   new Parameter("@prcCostRate", jobBillableSheet.PrcRate),
			   new Parameter("@prcCost", jobBillableSheet.PrcAmount),
			   new Parameter("@prcMarkupPercent", jobBillableSheet.PrcMarkupPercent),
			   new Parameter("@statusId", jobBillableSheet.StatusId),
			   new Parameter("@prcElectronicBilling", jobBillableSheet.PrcElectronicBilling),
			   new Parameter("@isProblem", jobBillableSheet.IsProblem)
			};
			return parameters;
		}

		private static List<Parameter> GetParameterForCostSheet(JobBillableSheet jobBillableSheet, ActiveUser activeUser)
		{
			List<PrgCostRate> prgCostRate = Program.PrgCostRateCommands.GetProgramCostRate(activeUser, 0, null, jobBillableSheet.JobID);
			PrgCostRate currentProgramRate = prgCostRate?.Where(x => x.PcrCode == jobBillableSheet.PrcChargeCode)?.FirstOrDefault();
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", jobBillableSheet.JobID),
			   new Parameter("@cstLineItem", jobBillableSheet.PrcLineItem),
			   new Parameter("@cstChargeId", currentProgramRate != null ? currentProgramRate.Id : 0),
			   new Parameter("@cstChargeCode", jobBillableSheet.PrcChargeCode),
			   new Parameter("@cstTitle", jobBillableSheet.PrcTitle),
			   new Parameter("@cstSurchargeOrder", jobBillableSheet.PrcSurchargeOrder),
			   new Parameter("@cstSurchargePercent", jobBillableSheet.PrcSurchargePercent),
			   new Parameter("@chargeTypeId", jobBillableSheet.ChargeTypeId),
			   new Parameter("@cstNumberUsed", jobBillableSheet.PrcNumberUsed),
			   new Parameter("@cstDuration", jobBillableSheet.PrcDuration),
			   new Parameter("@cstQuantity", jobBillableSheet.PrcQuantity),
			   new Parameter("@costUnitId", jobBillableSheet.PrcUnitId),
			   new Parameter("@cstCostRate", currentProgramRate != null ? currentProgramRate.PcrCostRate : decimal.Zero),
			   new Parameter("@cstCost", currentProgramRate != null ? currentProgramRate.PcrCostRate : decimal.Zero),
			   new Parameter("@cstMarkupPercent", jobBillableSheet.PrcMarkupPercent),
			   new Parameter("@statusId", jobBillableSheet.StatusId),
			   new Parameter("@cstElectronicBilling", jobBillableSheet.PrcElectronicBilling),
			   new Parameter("@isProblem", jobBillableSheet.IsProblem)
			};
			return parameters;
		}

		public static DataTable GetJobBillableRateDT(List<JobBillableSheet> jobBillableRateList)
		{
			using (var jobPriceCodeUTT = new DataTable("uttJobPriceCode"))
			{
				jobPriceCodeUTT.Locale = CultureInfo.InvariantCulture;
				jobPriceCodeUTT.Columns.Add("LineNumber");
				jobPriceCodeUTT.Columns.Add("JobID");
				jobPriceCodeUTT.Columns.Add("prcLineItem");
				jobPriceCodeUTT.Columns.Add("prcChargeID");
				jobPriceCodeUTT.Columns.Add("prcChargeCode");
				jobPriceCodeUTT.Columns.Add("prcTitle");
				jobPriceCodeUTT.Columns.Add("prcUnitId");
				jobPriceCodeUTT.Columns.Add("prcRate");
				jobPriceCodeUTT.Columns.Add("ChargeTypeId");
				jobPriceCodeUTT.Columns.Add("PrcQuantity");
				jobPriceCodeUTT.Columns.Add("prcElectronicBilling");
				jobPriceCodeUTT.Columns.Add("IsProblem");
				jobPriceCodeUTT.Columns.Add("StatusId");
				jobPriceCodeUTT.Columns.Add("EnteredBy");
				jobPriceCodeUTT.Columns.Add("DateEntered");

				if (jobBillableRateList?.Count > 0)
				{
					int count = 1;
					int lineNumber = 10000;
					foreach (var jobBillableRate in jobBillableRateList)
					{
						var row = jobPriceCodeUTT.NewRow();
						row["LineNumber"] = lineNumber;
						row["JobID"] = jobBillableRate.JobID;
						row["prcLineItem"] = count;
						row["prcChargeID"] = jobBillableRate.PrcChargeID;
						row["prcChargeCode"] = jobBillableRate.PrcChargeCode;
						row["prcTitle"] = jobBillableRate.PrcTitle;
						row["prcUnitId"] = jobBillableRate.PrcUnitId;
						row["prcRate"] = jobBillableRate.PrcRate;
						row["ChargeTypeId"] = jobBillableRate.ChargeTypeId;
						row["PrcQuantity"] = jobBillableRate.PrcQuantity;
						row["prcElectronicBilling"] = jobBillableRate.PrcElectronicBilling;
						row["IsProblem"] = jobBillableRate.PrcChargeID > 0 ? false : true;
						row["StatusId"] = jobBillableRate.StatusId;
						row["EnteredBy"] = jobBillableRate.EnteredBy;
						row["DateEntered"] = jobBillableRate.DateEntered;
						jobPriceCodeUTT.Rows.Add(row);
						jobPriceCodeUTT.AcceptChanges();
						count = count + 1;
						lineNumber = lineNumber + 1;
					}
				}

				return jobPriceCodeUTT;
			}
		}
	}
}