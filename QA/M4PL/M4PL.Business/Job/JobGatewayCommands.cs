/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobGatewayCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobGatewayCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobGatewayCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobGatewayCommands : BaseCommands<JobGateway>, IJobGatewayCommands
    {
        /// <summary>
        /// Get list of jobgateways data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobGateway> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific jobgateways record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobGateway Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public JobGateway GetGatewayWithParent(long id, long parentId,string entityFor)
        {
            var result = _commands.GetGatewayWithParent(ActiveUser, id, parentId, entityFor);
            result.ElectroluxProgramID = M4PBusinessContext.ComponentSettings.ElectroluxProgramId;
            return result;
        }

        /// <summary>
        /// Creates a new jobgateways record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public JobGateway Post(JobGateway jobGateway)
        {
            return _commands.Post(ActiveUser, jobGateway, M4PBusinessContext.ComponentSettings.ElectroluxProgramId);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        public JobGateway PostWithSettings(SysSetting userSysSetting, JobGateway jobGateway)
        {
            return _commands.PostWithSettings(ActiveUser, userSysSetting, jobGateway, M4PBusinessContext.ComponentSettings.ElectroluxProgramId);
        }

        /// <summary>
        /// Updates an existing jobgateways record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public JobGateway Put(JobGateway jobGateway)
        {
            return _commands.Put(ActiveUser, jobGateway);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        public JobGateway PutWithSettings(SysSetting userSysSetting, JobGateway jobGateway)
        {
            return _commands.PutWithSettings(ActiveUser, userSysSetting, jobGateway);
        }

        /// <summary>
        /// Deletes a specific jobgateways record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of jobgateways record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public JobGatewayComplete GetJobGatewayComplete(long id, long parentId)
        {
            return _commands.GetJobGatewayComplete(ActiveUser, id, parentId);
        }

        public JobGatewayComplete PutJobGatewayComplete(JobGatewayComplete jobGateway)
        {
            return _commands.PutJobGatewayComplete(ActiveUser, jobGateway);
        }

        public IList<JobAction> GetJobAction(long jobId)
        {
            return _commands.GetJobAction(ActiveUser, jobId);
        }

        public JobGateway PutJobAction(JobGateway jobGateway)
        {
            return _commands.PutJobAction(ActiveUser, jobGateway);
        }

        public IList<JobGateway> GetAllData()
        {
            throw new NotImplementedException();
        }

		public JobGateway Patch(JobGateway entity)
		{
			throw new NotImplementedException();
		}

        public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
        {
            return _commands.JobActionCodeByTitle(ActiveUser, jobId, gwyTitle);
        }
        public IList<JobGatewayDetails> GetJobGateway(long jobId)
        {
            return _commands.GetJobGateway(ActiveUser, jobId);
        }

        /// <summary>
        /// Updates an existing contact card record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact)
        {
            return _commands.PostContactCard(ActiveUser, contact);
        }
    }
}