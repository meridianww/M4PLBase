/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              29/07/2019
Program Name:                                 JobBillableSheetCommands
Purpose:                                      Contains commands to perform CRUD on JobBillableSheet
=============================================================================================================*/
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
using System.Text;
using System.Threading.Tasks;
using _programPriceCommand = M4PL.DataAccess.Program.PrgBillableRateCommands;

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
            var parameters = GetParameters(jobBillableSheet);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobBillableSheet));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobBillableSheet);
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

		public static void UpdatePriceCodeDetailsForOrder(long jobId, List<JobCargo> cargoDetails, string locationCode, int serviceId, long programId, ActiveUser activeUser)
		{
			List<JobBillableSheet> jobBillableSheetList = null;
			PrgBillableRate currentPrgBillableRate = null;
			jobBillableSheetList = new List<JobBillableSheet>();
			var priceCodeData = _programPriceCommand.GetProgramBillableRate(activeUser, programId, locationCode);
			if (priceCodeData?.Count > 0)
			{
				currentPrgBillableRate = priceCodeData?.Where(x => x.IsDefault)?.FirstOrDefault();
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
						DateEntered = DateTime.UtcNow,
						EnteredBy = activeUser.UserName
					});
				}
			}

			if (cargoDetails?.Count > 0)
			{
				foreach (var cargoLineItem in cargoDetails)
				{
					currentPrgBillableRate = cargoLineItem.CgoPackagingTypeId == serviceId ? priceCodeData.Where(x => x.PbrCustomerCode == cargoLineItem.CgoPartNumCode)?.FirstOrDefault() : null;
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
							DateEntered = DateTime.UtcNow,
							EnteredBy = activeUser.UserName
						});
					}
				}
			}

			InsertJobBillableSheetData(jobBillableSheetList, jobId);
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
