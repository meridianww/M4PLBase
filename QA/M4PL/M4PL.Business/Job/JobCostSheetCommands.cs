#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Nikhil
// Date Programmed:                              25/07/2019
// Program Name:                                 JobCostSheetCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.job.JobCostSheetCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Job.JobCostSheetCommands;

namespace M4PL.Business.Job
{
	public class JobCostSheetCommands : BaseCommands<JobCostSheet>, IJobCostSheetCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN", true); }
		}

		/// <summary>
		/// Get list of jobrefcostsheet data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<JobCostSheet> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific jobrefcostsheet record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public JobCostSheet Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new jobrefcostsheet record
		/// </summary>
		/// <param name="jobRefCostSheet"></param>
		/// <returns></returns>

		public JobCostSheet Post(JobCostSheet jobRefCostSheet)
		{
			var result = _commands.Post(ActiveUser, jobRefCostSheet);
			if (result != null)
			{
				new JobCommands().GenerateOrderInNAVAfterPostedInvoice(result.JobID, ActiveUser, M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), result.Id, result.BillableChargeId);
			}

			return result;
		}

		/// <summary>
		/// Updates an existing jobrefcostsheet record
		/// </summary>
		/// <param name="jobRefCostSheet"></param>
		/// <returns></returns>

		public JobCostSheet Put(JobCostSheet jobRefCostSheet)
		{
			return _commands.Put(ActiveUser, jobRefCostSheet);
		}

		/// <summary>
		/// Deletes a specific jobrefcostsheet record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of jobrefcostsheet record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public JobCostSheet Patch(JobCostSheet entity)
		{
			throw new NotImplementedException();
		}

		public IList<JobCostCodeAction> GetJobCostCodeAction(long jobId)
		{
			return _commands.GetJobCostCodeAction(ActiveUser, jobId);
		}

		public JobCostSheet JobCostCodeByProgram(long id, long jobId)
		{
			return _commands.JobCostCodeByProgram(ActiveUser, id, jobId);
		}
	}
}