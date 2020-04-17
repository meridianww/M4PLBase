/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobEDIXcblCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobXcblInfoCommands;
using System;

namespace M4PL.Business.Job
{
	public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>, IJobXcblInfoCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<JobXcblInfo> Get()
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<JobXcblInfo> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Patch(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Post(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo Put(JobXcblInfo entity)
		{
			throw new NotImplementedException();
		}

		public JobXcblInfo GetJobXcblInfo(long jobId, string gwyCode, string customerSalesOrder)
		{
			return _commands.GetJobXcblInfo(ActiveUser, jobId, gwyCode, customerSalesOrder);
		}

        public bool AcceptJobXcblInfo(JobXcblInfo jobXcblInfoView)
        {
            return _commands.AcceptJobXcblInfo(ActiveUser, jobXcblInfoView);
        }
    }
}