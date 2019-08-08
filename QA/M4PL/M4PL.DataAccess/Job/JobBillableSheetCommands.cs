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
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
            };
            return parameters;
        }
    }
}
