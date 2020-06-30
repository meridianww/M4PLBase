/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 JobRefStatusCommands
Purpose:                                      Contains commands to perform CRUD on JobRefStatus
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobRefStatusCommands : BaseCommands<JobRefStatus>
    {
        /// <summary>
        /// Gets list of JobRefStatus records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobRefStatus> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobRefStatusView, EntitiesAlias.JobRefStatus);
        }

        /// <summary>
        /// Gets the specific JobRefStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobRefStatus Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobRefStatus);
        }

        /// <summary>
        /// Creates a new JobRefStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefStatus"></param>
        /// <returns></returns>

        public static JobRefStatus Post(ActiveUser activeUser, JobRefStatus jobRefStatus)
        {
            var parameters = GetParameters(jobRefStatus);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobRefStatus));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobRefStatus);
        }

        /// <summary>
        /// Updates the existing JobRefStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobRefStatus"></param>
        /// <returns></returns>

        public static JobRefStatus Put(ActiveUser activeUser, JobRefStatus jobRefStatus)
        {
            var parameters = GetParameters(jobRefStatus);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobRefStatus.Id, jobRefStatus));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobRefStatus);
        }

        /// <summary>
        /// Deletes a specific JobRefStatus record
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
        /// Deletes list of JobRefStatus records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobRefStatus, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the JobRefStatus Module
        /// </summary>
        /// <param name="jobRefStatus"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobRefStatus jobRefStatus)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobRefStatus.JobID),
               new Parameter("@jbsOutlineCode", jobRefStatus.JbsOutlineCode),
               new Parameter("@jbsStatusCode", jobRefStatus.JbsStatusCode),
               new Parameter("@jbsTitle", jobRefStatus.JbsTitle),
               new Parameter("@statusId", jobRefStatus.StatusId),
               new Parameter("@severityId", jobRefStatus.SeverityId),
            };
            return parameters;
        }
    }
}