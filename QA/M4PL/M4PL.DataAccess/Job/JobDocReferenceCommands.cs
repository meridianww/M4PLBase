/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobDocReferenceCommands
Purpose:                                      Contains commands to perform CRUD on JobDocReference
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Job
{
    public class JobDocReferenceCommands : BaseCommands<JobDocReference>
    {
        /// <summary>
        /// Gets list of Job Document Reference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobDocReference> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobDocReferenceView, EntitiesAlias.JobDocReference);
        }

        /// <summary>
        /// Gets the specific Job Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobDocReference Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobDocReference);
        }

        /// <summary>
        /// Creates a new Job Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        public static JobDocReference Post(ActiveUser activeUser, JobDocReference jobDocReference)
        {
            var parameters = GetParameters(jobDocReference);
            // parameters.Add(new Parameter("@langCode", jobDocReference.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(jobDocReference));
            parameters.Add(new Parameter("@DocRefId", jobDocReference.Id));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobDocReference);
        }

        public static JobDocReference PostWithSettings(ActiveUser activeUser, SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            var parameters = GetParameters(jobDocReference, userSysSetting);
            parameters.AddRange(activeUser.PostDefaultParams(jobDocReference));
            parameters.Add(new Parameter("@DocRefId", jobDocReference.Id));
            var result = Post(activeUser, parameters, StoredProceduresConstant.InsertJobDocReference);
            return result;
        }

        /// <summary>
        /// Updates the existing Job Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        public static JobDocReference Put(ActiveUser activeUser, JobDocReference jobDocReference)
        {
            var parameters = GetParameters(jobDocReference);
            parameters.AddRange(activeUser.PutDefaultParams(jobDocReference.Id, jobDocReference));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobDocReference);
        }

        public static JobDocReference PutWithSettings(ActiveUser activeUser, SysSetting userSysSetting, JobDocReference jobDocReference)
        {
            var parameters = GetParameters(jobDocReference, userSysSetting);
            // parameters.Add(new Parameter("@langCode", jobDocReference.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(jobDocReference.Id, jobDocReference));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobDocReference);
        }

        /// <summary>
        /// Deletes a specific Job Document Reference record
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
        /// Deletes list of Job Document Reference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobDocReference, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Job Document Reference Module
        /// </summary>
        /// <param name="jobDocReference"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(JobDocReference jobDocReference, SysSetting userSysSetting = null)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobDocReference.JobID),
               new Parameter("@jdrItemNumber", jobDocReference.JdrItemNumber),
               new Parameter("@jdrCode", jobDocReference.JdrCode),
               new Parameter("@jdrTitle", jobDocReference.JdrTitle),
               new Parameter("@docTypeId", jobDocReference.DocTypeId),
               new Parameter("@jdrAttachment", jobDocReference.JdrAttachment),
               new Parameter("@jdrDateStart", jobDocReference.JdrDateStart),
               new Parameter("@jdrDateEnd", jobDocReference.JdrDateEnd),
               new Parameter("@jdrRenewal", jobDocReference.JdrRenewal),
               new Parameter("@statusId", jobDocReference.StatusId)
            };

            if (userSysSetting != null && userSysSetting.Settings != null)
            {
                var whereCondition = string.Empty;
                var itemNumberConditions = userSysSetting.Settings.Where(s => s.EntityName == EntitiesAlias.JobDocReference.ToString() && s.Name.Equals("ItemNumber"));
                foreach (var setting in itemNumberConditions)
                {
                    if (setting != null && !string.IsNullOrEmpty(setting.Value))
                    {
                        var columnList = setting.Value.SplitComma();
                        var properties = jobDocReference.GetType().GetProperties();
                        foreach (var columnName in columnList)
                        {
                            var propInfo = properties.FirstOrDefault(p => columnName.Contains(p.Name));
                            if (propInfo != null)
                            {
                                if (!setting.ValueType.Equals("string", System.StringComparison.OrdinalIgnoreCase))
                                    whereCondition = whereCondition + " " + columnName + " " + propInfo.GetValue(jobDocReference, null);
                                else
                                    whereCondition = whereCondition + " " + columnName + " '" + propInfo.GetValue(jobDocReference, null) + "'";
                            }
                        }
                    }
                }
                parameters.Add(new Parameter("@where", whereCondition));
            }

            return parameters;
        }

        public static long GetNextSequence()
        {
            try
            {
                var parameters = new List<Parameter>
            {
               new Parameter("@Entity", "DocumentReference")
            };


                return SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.GetSequenceForEntity, parameters.ToArray(), storedProcedure: true);
            }
            catch(Exception ex)
            {
                return 0;
            }
        }

    }
}