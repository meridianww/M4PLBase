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
// Programmer:                                 Prashant Aggarwal
// Date Programmed:                            19/02/2020
// Program Name:                                 JobEDIXcblCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobEDIXcblCommands
//====================================================================================================================

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobEDIXcblCommands;

namespace M4PL.Business.Job
{
	public class JobEDIXcblCommands : BaseCommands<JobEDIXcbl>, IJobEDIXcblCommands
	{
		/// <summary>
		/// Get list of job cargo data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<JobEDIXcbl> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific job cargo record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public JobEDIXcbl Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a newjob cargo record
		/// </summary>
		/// <param name="jobEDIXcbl"></param>
		/// <returns></returns>

		public JobEDIXcbl Post(JobEDIXcbl jobEDIXcbl)
		{
			return _commands.Post(ActiveUser, jobEDIXcbl);
		}

		/// <summary>
		/// Updates an existing job cargo record
		/// </summary>
		/// <param name="jobEDIXcbl"></param>
		/// <returns></returns>

		public JobEDIXcbl Put(JobEDIXcbl jobEDIXcbl)
		{
			return _commands.Put(ActiveUser, jobEDIXcbl);
		}

		/// <summary>
		/// Deletes a specific job cargo record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of job cargo record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public JobEDIXcbl Patch(JobEDIXcbl entity)
		{
			throw new NotImplementedException();
		}
	}
}