/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgCostRateCommands
Purpose:                                      Contains commands to perform CRUD on PrgCostRate
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Program
{
    public class PrgCostRateCommands : BaseCommands<PrgCostRate>
    {
        /// <summary>
        /// Gets list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgCostRate> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetProgramCostRateView, EntitiesAlias.PrgCostRate);
        }

        /// <summary>
        /// Gets the specific SystemMessageCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgCostRate Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetProgramCostRate);
        }

        public static List<PrgCostRate> GetProgramCostRate(ActiveUser activeUser, long programId, string locationCode, long jobId)
        {
            List<PrgCostRate> result = null;
            try
            {
                var parameters = new List<Parameter>
                {
                   new Parameter("@programId", programId),
                   new Parameter("@userId", activeUser.UserId),
                   new Parameter("@locationCode", locationCode),
                   new Parameter("@jobId", jobId)
                };

                result = SqlSerializer.Default.DeserializeMultiRecords<PrgCostRate>(StoredProceduresConstant.GetCostCodeListByProgramId, parameters.ToArray(), dateTimeAsUtc: false, storedProcedure: true);
            }
            catch (Exception exp)
            {
                Logger.ErrorLogger.Log(exp, "Error occuring while getting data for Program Cost Rate for a Program", "GetProgramCostRate", Utilities.Logger.LogType.Error);
            }

            return result;
        }

        /// <summary>
        /// Creates a new SystemMessageCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgCostRate"></param>
        /// <returns></returns>

        public static PrgCostRate Post(ActiveUser activeUser, PrgCostRate prgCostRate)
        {
            var parameters = GetParameters(prgCostRate);
            // parameters.Add(new Parameter("@langCode", prgCostRate.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(prgCostRate));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertProgramCostRate);
        }

        /// <summary>
        /// Updates the existing SystemMessageCode record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgCostRate"></param>
        /// <returns></returns>

        public static PrgCostRate Put(ActiveUser activeUser, PrgCostRate prgCostRate)
        {
            var parameters = GetParameters(prgCostRate);
            // parameters.Add(new Parameter("@langCode", prgCostRate.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(prgCostRate.Id, prgCostRate));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateProgramCostRate);
        }

        /// <summary>
        /// Deletes a specific SystemPageTableName record
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
        /// Deletes list of SystemPageTableName records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgCostRate, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the systemPageTabName Module
        /// </summary>
        /// <param name="prgCostRate"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(PrgCostRate prgCostRate)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@programLocationId", prgCostRate.ProgramLocationId),
               new Parameter("@pcrCode", prgCostRate.PcrCode),
               new Parameter("@pcrVendorCode", prgCostRate.PcrVendorCode),
               new Parameter("@pcrEffectiveDate", prgCostRate.PcrEffectiveDate),
               new Parameter("@pcrTitle", prgCostRate.PcrTitle),
               new Parameter("@rateCategoryTypeId", prgCostRate.RateCategoryTypeId),
               new Parameter("@rateTypeId", prgCostRate.RateTypeId),
               new Parameter("@pcrCostRate", prgCostRate.PcrCostRate),
               new Parameter("@rateUnitTypeId", prgCostRate.RateUnitTypeId),
               new Parameter("@pcrFormat", prgCostRate.PcrFormat),
               new Parameter("@pcrExpression01", prgCostRate.PcrExpression01),
               new Parameter("@pcrLogic01", prgCostRate.PcrLogic01),
               new Parameter("@pcrExpression02", prgCostRate.PcrExpression02),
               new Parameter("@pcrLogic02", prgCostRate.PcrLogic02),
               new Parameter("@pcrExpression03", prgCostRate.PcrExpression03),
               new Parameter("@pcrLogic03", prgCostRate.PcrLogic03),
               new Parameter("@pcrExpression04", prgCostRate.PcrExpression04),
               new Parameter("@pcrLogic04", prgCostRate.PcrLogic04),
               new Parameter("@pcrExpression05", prgCostRate.PcrExpression05),
               new Parameter("@pcrLogic05", prgCostRate.PcrLogic05),
               new Parameter("@statusId", prgCostRate.StatusId),
               new Parameter("@pcrCustomerId", prgCostRate.PcrCustomerID),
               new Parameter("@pcrElectronicBilling", prgCostRate.PcrElectronicBilling),
            };

            return parameters;
        }
    }
}