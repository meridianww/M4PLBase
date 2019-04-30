/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobAttributeCommands
Purpose:                                      Contains commands to perform CRUD on JobAttribute
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobAttributeCommands : BaseCommands<JobAttribute>
    {
        /// <summary>
        /// Gets list of JobAttribute records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobAttribute> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobAttributeView, EntitiesAlias.JobAttribute);
        }

        /// <summary>
        /// Gets the specific JobAttribute record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobAttribute Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobAttribute);
        }

        /// <summary>
        /// Creates a new JobAttribute record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobAttribute"></param>
        /// <returns></returns>

        public static JobAttribute Post(ActiveUser activeUser, JobAttribute jobAttribute)
        {
            var parameters = GetParameters(jobAttribute);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobAttribute));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobAttribute);
        }

        /// <summary>
        /// Updates the existing JobAttribute record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobAttribute"></param>
        /// <returns></returns>

        public static JobAttribute Put(ActiveUser activeUser, JobAttribute jobAttribute)
        {
            var parameters = GetParameters(jobAttribute);
            // parameters.Add(new Parameter("@langCode", entity.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobAttribute.Id, jobAttribute));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobAttribute);
        }

        /// <summary>
        /// Deletes a specific JobAttribute record
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
        /// Deletes list of JobAttribute records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobAttribute, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the JobAttribute Module
        /// </summary>
        /// <param name="jobAttribute"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobAttribute jobAttribute)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@jobId", jobAttribute.JobID),
               new Parameter("@ajbLineOrder", jobAttribute.AjbLineOrder),
               new Parameter("@ajbAttributeCode", jobAttribute.AjbAttributeCode),
               new Parameter("@ajbAttributeTitle", jobAttribute.AjbAttributeTitle),
               new Parameter("@ajbAttributeQty", jobAttribute.AjbAttributeQty),
               new Parameter("@ajbUnitTypeId", jobAttribute.AjbUnitTypeId),
               new Parameter("@ajbDefault", jobAttribute.AjbDefault),
               new Parameter("@statusId", jobAttribute.StatusId),
           };
            return parameters;
        }
    }
}