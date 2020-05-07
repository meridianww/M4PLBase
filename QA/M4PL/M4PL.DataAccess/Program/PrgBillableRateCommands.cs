/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgBillableRateCommands
Purpose:                                      Contains commands to perform CRUD on PrgBillableRate
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Program
{
    public class PrgBillableRateCommands : BaseCommands<PrgBillableRate>
    {
        /// <summary>
        /// Gets list of PrgBillableRate records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgBillableRate> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetProgramBillableRateView, EntitiesAlias.PrgBillableRate);
        }

        /// <summary>
        /// Gets the specific PrgBillableRate record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgBillableRate Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetProgramBillableRate);
        }

		public static List<PrgBillableRate> GetProgramBillableRate(ActiveUser activeUser, long programId)
		{
			List<PrgBillableRate> result = null;
			try
			{
				var parameters = new List<Parameter>
				{
				   new Parameter("@programId", programId),
				   new Parameter("@userId", activeUser.UserId)
				};

				result = SqlSerializer.Default.DeserializeMultiRecords<PrgBillableRate>(StoredProceduresConstant.GetPriceCodeListByProgramId, parameters.ToArray(), dateTimeAsUtc: false, storedProcedure: true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error occuring while getting data for Program Billable Rate for a Program", "GetProgramBillableRate", Utilities.Logger.LogType.Error);
			}

			return result;
		}

        /// <summary>
        /// Creates a new PrgBillableRate record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgBillableRate"></param>
        /// <returns></returns>

        public static PrgBillableRate Post(ActiveUser activeUser, PrgBillableRate prgBillableRate)
        {
            var parameters = GetParameters(prgBillableRate);
            // parameters.Add(new Parameter("@langCode", prgBillableRate.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(prgBillableRate));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertProgramBillableRate);
        }

        /// <summary>
        /// Updates the existing PrgBillableRate record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgBillableRate"></param>
        /// <returns></returns>

        public static PrgBillableRate Put(ActiveUser activeUser, PrgBillableRate prgBillableRate)
        {
            var parameters = GetParameters(prgBillableRate);
            // parameters.Add(new Parameter("@langCode", prgBillableRate.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(prgBillableRate.Id, prgBillableRate));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateProgramBillableRate);
        }

        /// <summary>
        /// Deletes a specific PrgBillableRate record
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
        /// Deletes list of PrgBillableRate records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgBillableRate, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the PrgBillableRate Module
        /// </summary>
        /// <param name="prgBillableRate"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgBillableRate prgBillableRate)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@programLocationId", prgBillableRate.ProgramLocationId),
               new Parameter("@pbrCode", prgBillableRate.PbrCode),
               new Parameter("@pbrCustomerCode", prgBillableRate.PbrCustomerCode),
               new Parameter("@pbrEffectiveDate", prgBillableRate.PbrEffectiveDate),
               new Parameter("@pbrTitle", prgBillableRate.PbrTitle),
               new Parameter("@rateCategoryTypeId", prgBillableRate.RateCategoryTypeId),
               new Parameter("@rateTypeId", prgBillableRate.RateTypeId),
               new Parameter("@pbrBillablePrice", prgBillableRate.PbrBillablePrice),
               new Parameter("@rateUnitTypeId", prgBillableRate.RateUnitTypeId),
               new Parameter("@pbrFormat", prgBillableRate.PbrFormat),
               new Parameter("@pbrExpression01", prgBillableRate.PbrExpression01),
               new Parameter("@pbrLogic01", prgBillableRate.PbrLogic01),
               new Parameter("@pbrExpression02", prgBillableRate.PbrExpression02),
               new Parameter("@pbrLogic02", prgBillableRate.PbrLogic02),
               new Parameter("@pbrExpression03", prgBillableRate.PbrExpression03),
               new Parameter("@pbrLogic03", prgBillableRate.PbrLogic03),
               new Parameter("@pbrExpression04", prgBillableRate.PbrExpression04),
               new Parameter("@pbrLogic04", prgBillableRate.PbrLogic04),
               new Parameter("@pbrExpression05", prgBillableRate.PbrExpression05),
               new Parameter("@pbrLogic05", prgBillableRate.PbrLogic05),
               new Parameter("@statusId", prgBillableRate.StatusId),
               new Parameter("@pbrVendLocationId", prgBillableRate.PbrVendLocationID),
			   new Parameter("@pbrElectronicBilling", prgBillableRate.PbrElectronicBilling),
			};
            return parameters;
        }
	}
}