/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobRefCostSheetCommands
Purpose:                                      Contains commands to perform CRUD on JobRefCostSheet
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobRefCostSheetCommands : BaseCommands<JobRefCostSheet>
    {
        /// <summary>
        /// Gets list of JobRefCostSheet records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobRefCostSheet> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobRefCostSheetView, EntitiesAlias.JobRefCostSheet);
        }

        /// <summary>
        /// Gets the specific JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobRefCostSheet Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobRefCostSheet);
        }

        /// <summary>
        /// Creates a new JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public static JobRefCostSheet Post(ActiveUser activeUser, JobRefCostSheet jobRefCostSheet)
        {
            var parameters = GetParameters(jobRefCostSheet);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobRefCostSheet));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobRefCostSheet);
        }

        /// <summary>
        /// Updates the existing JobRefCostSheet record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        public static JobRefCostSheet Put(ActiveUser activeUser, JobRefCostSheet jobRefCostSheet)
        {
            var parameters = GetParameters(jobRefCostSheet);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobRefCostSheet.Id, jobRefCostSheet));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobRefCostSheet);
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
            return Delete(activeUser, ids, EntitiesAlias.JobRefCostSheet, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the JobRefCostSheet Module
        /// </summary>
        /// <param name="jobRefCostSheet"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobRefCostSheet jobRefCostSheet)
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
               new Parameter("@costUnitId", jobRefCostSheet.CostUnitId),
               new Parameter("@cstCostRate", jobRefCostSheet.CstCostRate),
               new Parameter("@cstCost", jobRefCostSheet.CstCost),
               new Parameter("@cstMarkupPercent", jobRefCostSheet.CstMarkupPercent),
               new Parameter("@cstRevenueRate", jobRefCostSheet.CstRevenueRate),
               new Parameter("@cstRevDuration", jobRefCostSheet.CstRevDuration),
               new Parameter("@cstRevQuantity", jobRefCostSheet.CstRevQuantity),
               new Parameter("@cstRevBillable", jobRefCostSheet.CstRevBillable),
               new Parameter("@statusId", jobRefCostSheet.StatusId),
            };
            return parameters;
        }
    }
}