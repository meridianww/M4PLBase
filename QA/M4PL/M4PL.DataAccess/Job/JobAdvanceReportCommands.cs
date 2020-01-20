/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 JobAdvanceReportCommands
Purpose:                                      Contains commands to perform CRUD on JobAdvanceReportCommands
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReport>
    {
		/// <summary>
		/// Gets list of JobAdvanceReport records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<JobAdvanceReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobAdvanceReportView, EntitiesAlias.JobAdvanceReport);
        }

		/// <summary>
		/// Gets the specific JobAdvanceReport record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static JobAdvanceReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobAdvanceReport);
        }

		/// <summary>
		/// Deletes a specific JobAdvanceReport record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
        {
            return 0;
        }

		/// <summary>
		/// Deletes list of JobAdvanceReport records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobAdvanceReport, statusId, ReservedKeysEnum.StatusId);
        }
    }
}