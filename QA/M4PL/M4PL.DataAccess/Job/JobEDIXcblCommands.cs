/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Contains commands to perform CRUD on JobEDIXcbl
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobEDIXcblCommands : BaseCommands<JobEDIXcbl>
    {
		/// <summary>
		/// Gets list of JobEDIXcbl records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<JobEDIXcbl> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobEDIXcblView, EntitiesAlias.JobEDIXcbl);
        }

		/// <summary>
		/// Gets the specific JobEDIXcbl record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static JobEDIXcbl Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobEDIXcbl);
        }

		/// <summary>
		/// Creates a new JobEDIXcbl record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="jobEDIXcbl"></param>
		/// <returns></returns>

		public static JobEDIXcbl Post(ActiveUser activeUser, JobEDIXcbl jobEDIXcbl)
        {
            var parameters = GetParameters(jobEDIXcbl);
            parameters.AddRange(activeUser.PostDefaultParams(jobEDIXcbl));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobEDIXcbl);
        }

		/// <summary>
		/// Updates the existing JobEDIXcbl record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="jobEDIXcbl"></param>
		/// <returns></returns>

		public static JobEDIXcbl Put(ActiveUser activeUser, JobEDIXcbl jobEDIXcbl)
        {
            var parameters = GetParameters(jobEDIXcbl);
            parameters.AddRange(activeUser.PutDefaultParams(jobEDIXcbl.Id, jobEDIXcbl));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobEDIXcbl);
        }

        /// <summary>
        /// Deletes a specific JobCargo record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return 0;
        }

		/// <summary>
		/// Deletes list of JobEDIXcbl records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobEDIXcbl, statusId, ReservedKeysEnum.StatusId);
        }

		/// <summary>
		/// Gets list of parameters required for the JobEDIXcbl Module
		/// </summary>
		/// <param name="jobCargo"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(JobEDIXcbl JobEDIXcbl)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@jobId", JobEDIXcbl.JobId),
			   new Parameter("@statusId", JobEDIXcbl.StatusId),
			   new Parameter("@edtCode", JobEDIXcbl.EdtCode),
			   new Parameter("@edtTitle", JobEDIXcbl.EdtTitle),
			   new Parameter("@edtData", JobEDIXcbl.EdtData),
			   new Parameter("@edtTypeId ", JobEDIXcbl.EdtTypeId)
			};

			return parameters;
		}
    }
}