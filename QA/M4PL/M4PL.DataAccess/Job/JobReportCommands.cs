#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobReportCommands : BaseCommands<JobReport>
    {
        /// <summary>
        /// Gets list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.JobReport);
        }

        /// <summary>
        /// Gets the specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public static JobReport Post(ActiveUser activeUser, JobReport jobReport)
        {
            var parameters = GetParameters(jobReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobReport));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// Updates the existing Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobReport"></param>
        /// <returns></returns>

        public static JobReport Put(ActiveUser activeUser, JobReport jobReport)
        {
            var parameters = GetParameters(jobReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobReport.Id, jobReport));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific Job record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteJob);
        }

        /// <summary>
        /// Deletes list of Job records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Job, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Job Module
        /// </summary>
        /// <param name="JobReport"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobReport JobReport)
        {
            var parameters = new List<Parameter>
            {
            };
            return parameters;
        }


        /// <summary>
        /// Gets list of Job tree data
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>
        public static IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@CompanyId", companyId),
                new Parameter("@LocationCode", locationCode),
                new Parameter("@StartDate", startDate),
                new Parameter("@EndDate",endDate),
                new Parameter("@IsPBSReport",IsPBSReport)
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobVocReport>(StoredProceduresConstant.GetVocReportData, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static IList<JobReport> GetDropDownDataForLocation(ActiveUser activeUser, long customerId, string entity)
        {
            var parameters = new List<Parameter>
                  {
                     new Parameter("@CustomerId", customerId),
                     new Parameter("@entity", entity),
                     new Parameter("@userId", activeUser.UserId),
                     new Parameter("@roleId", activeUser.RoleId),
                     new Parameter("@orgId", activeUser.OrganizationId)
                 };
            if (entity == "Location")
            {
                var locationRecord = SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.JobReport>(StoredProceduresConstant.GetRecordsByCustomerEnity, parameters.ToArray(), storedProcedure: true);
                return locationRecord;
            }
            else
            {
                return null;
            }

        }
    }
}