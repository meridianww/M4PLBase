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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobGatewayCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobGatewayCommands
//====================================================================================================================

using M4PL.Business.Event;
using M4PL.Business.XCBL.HelperClasses;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Job.JobGatewayCommands;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using _jobCargoCommands = M4PL.DataAccess.Job.JobCargoCommands;
using M4PL.Utilities;

namespace M4PL.Business.Job
{
    public class JobGatewayCommands : BaseCommands<JobGateway>, IJobGatewayCommands
    {
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}
		public string NavAPIUrl
        {
            get { return M4PLBusinessConfiguration.NavAPIUrl; }
        }

        public string NavAPIUserName
        {
            get { return M4PLBusinessConfiguration.NavAPIUserName; }
        }

        public string NavAPIPassword
        {
            get { return M4PLBusinessConfiguration.NavAPIPassword; }
        }

        public string PODTransitionStatusId
        {
            get { return M4PLBusinessConfiguration.CompletedTransitionStatusId; }
        }

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

        public JobGateway GetGatewayWithParent(long id, long parentId, string entityFor, bool is3PlAction, string gatewayCode = null)
        {
            var result = _commands.GetGatewayWithParent(ActiveUser, id, parentId, entityFor, is3PlAction, gatewayCode);
            result.IsSpecificCustomer = result.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() ? true : false;
            return result;
        }

        /// <summary>
        /// Creates a new jobgateways record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public JobGateway Post(JobGateway jobGateway)
        {
            var gateway = _commands.Post(ActiveUser, jobGateway, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
            PushDataToNav(gateway.JobID, jobGateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId);
			int scenarioId = gateway.CustomerId == M4PLBusinessConfiguration.AWCCustomerId.ToLong() ? 1 : gateway.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() ? 2 : 0;
			if (scenarioId > 0)
			{
				if (jobGateway.GwyCargoId > 0)
				{
					var jobCargo = _jobCargoCommands.Get(ActiveUser, jobGateway.GwyCargoId);
					string cargoExceptionBody = EventBodyHelper.GetCargoExceptionMailBody(ActiveUser, jobGateway.GwyExceptionStatusIdName, (long)jobGateway.JobID, jobGateway.ContractNumber, (DateTime)jobGateway.GwyGatewayACD, jobGateway.GwyAddtionalComment, jobCargo.CgoPartNumCode, jobCargo.CgoTitle, jobCargo.CgoSerialNumber, jobCargo.JobGatewayStatus);
					EventBodyHelper.CreateEventMailNotificationForCargoException(scenarioId, (long)jobGateway.ProgramID, jobGateway.ContractNumber, cargoExceptionBody);
				}
				else if (string.Compare(jobGateway.GwyGatewayCode, "Exception", true) == 0)
				{
					string cargoExceptionBody = EventBodyHelper.GetCargoExceptionMailBody(ActiveUser, jobGateway.GwyTitle, (long)jobGateway.JobID, jobGateway.ContractNumber, gateway.GwyGatewayACD.HasValue ? (DateTime)gateway.GwyGatewayACD : Utilities.TimeUtility.GetPacificDateTime(), jobGateway.GwyAddtionalComment, string.Empty, string.Empty, string.Empty, string.Empty);
					EventBodyHelper.CreateEventMailNotificationForCargoException(scenarioId, (long)jobGateway.ProgramID, jobGateway.ContractNumber, cargoExceptionBody);
				}
			}

            if (gateway.IsFarEyePushRequired)
            {
                FarEyeHelper.PushStatusUpdateToFarEye((long)jobGateway.JobID, ActiveUser);
            }

            return gateway;
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        public JobGateway PostWithSettings(SysSetting userSysSetting, JobGateway jobGateway)
        {
            var gatewaysIds = string.Empty;
            jobGateway.IsMultiOperation = false;
            JobGateway gateway = null;
            if (jobGateway.JobIds != null && jobGateway.JobIds.Length > 0)
            {
                jobGateway.IsMultiOperation = true;
                gateway = new JobGateway();
                foreach (var item in jobGateway.JobIds[0].Split(','))
                {
                    gateway = new JobGateway();
                    gateway = _commands.PostWithSettings(ActiveUser, userSysSetting, jobGateway,
						M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), Convert.ToInt64(item));
                    gatewaysIds += gateway.Id + ",";
                }
                gateway.GatewayIds = gatewaysIds.Remove(gatewaysIds.Length - 1);
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId);
            }
            else
            {
                gateway = _commands.PostWithSettings(ActiveUser, userSysSetting, jobGateway, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId);
            }

			int scenarioId = gateway.CustomerId == M4PLBusinessConfiguration.AWCCustomerId.ToLong() ? 1 : gateway.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() ? 2 : 0;
			if (scenarioId > 0)
			{
				if (jobGateway.GwyCargoId > 0)
				{
					var jobCargo = _jobCargoCommands.Get(ActiveUser, jobGateway.GwyCargoId);
					string cargoExceptionBody = EventBodyHelper.GetCargoExceptionMailBody(ActiveUser, jobGateway.GwyTitle, (long)jobGateway.JobID, jobGateway.ContractNumber, gateway.GwyGatewayACD.HasValue ? (DateTime)gateway.GwyGatewayACD : Utilities.TimeUtility.GetPacificDateTime(), jobGateway.GwyAddtionalComment, jobCargo.CgoPartNumCode, jobCargo.CgoTitle, jobCargo.CgoSerialNumber, jobCargo.JobGatewayStatus);
					EventBodyHelper.CreateEventMailNotificationForCargoException(scenarioId, (long)jobGateway.ProgramID, jobGateway.ContractNumber, cargoExceptionBody);
				}
				else if (string.Compare(jobGateway.GwyGatewayCode, "Exception", true) == 0)
				{
					string cargoExceptionBody = EventBodyHelper.GetCargoExceptionMailBody(ActiveUser, jobGateway.GwyTitle, (long)jobGateway.JobID, jobGateway.ContractNumber, gateway.GwyGatewayACD.HasValue ? (DateTime)gateway.GwyGatewayACD : Utilities.TimeUtility.GetPacificDateTime(), jobGateway.GwyAddtionalComment, string.Empty, string.Empty, string.Empty, string.Empty);
					EventBodyHelper.CreateEventMailNotificationForCargoException(scenarioId, (long)jobGateway.ProgramID, jobGateway.ContractNumber, cargoExceptionBody);
				}
			}

            if (gateway.IsFarEyePushRequired)
            {
                FarEyeHelper.PushStatusUpdateToFarEye((long)jobGateway.JobID, ActiveUser);
            }

            return gateway;
        }

        /// <summary>
        /// Updates an existing jobgateways record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public JobGateway Put(JobGateway jobGateway)
        {
            var gateway = _commands.Put(ActiveUser, jobGateway);
            PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId);
            return gateway;
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        public JobGateway PutWithSettings(SysSetting userSysSetting, JobGateway jobGateway)
        {
            var gateway = _commands.PutWithSettings(ActiveUser, userSysSetting, jobGateway);
            PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId);
            return gateway;
        }

        public bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId)
        {
            var gateway = _commands.InsJobGatewayPODIfPODDocExistsByJobId(ActiveUser, jobId);
            if (gateway != null)
            {
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, gateway.GwyCompleted, 0);
                return true;
            }
            return false;
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

        //public IList<JobAction> GetJobAction(long jobId)
        //{
        //    return _commands.GetJobAction(ActiveUser, jobId);
        //}

        public JobGateway PutJobAction(JobGateway jobGateway)
        {
            return _commands.PutJobAction(ActiveUser, jobGateway);
        }

        public JobGateway Patch(JobGateway entity)
        {
            throw new NotImplementedException();
        }

        public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
        {
            return _commands.JobActionCodeByTitle(ActiveUser, jobId, gwyTitle);
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


        public void PushDataToNav(long? jobId, string gatewayCode, bool gatewayStatus, int? JobTransitionStatusId)
        {
            List<int> completedTransitionStatus = PODTransitionStatusId.Split(',').Select(int.Parse).ToList();

            if (jobId != null && gatewayStatus && (string.Equals(gatewayCode, "POD Completion", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(gatewayCode, "Will Call", StringComparison.OrdinalIgnoreCase) || (JobTransitionStatusId.HasValue && completedTransitionStatus.Contains((int)JobTransitionStatusId))))
            {
                var jobResult = _jobCommands.Get(ActiveUser, Convert.ToInt64(jobId));
                if (jobResult != null && jobResult.JobCompleted && jobResult.JobOriginDateTimeActual.HasValue && jobResult.JobDeliveryDateTimeActual.HasValue)
                {
                    Task.Run(() =>
                    {
                        bool isDeliveryChargeRemovalRequired = false;
                        if (!string.IsNullOrEmpty(jobResult.JobSONumber) || !string.IsNullOrEmpty(jobResult.JobElectronicInvoiceSONumber))
                        {
                            isDeliveryChargeRemovalRequired = false;
                        }
                        else
                        {
                            isDeliveryChargeRemovalRequired = _jobCommands.GetJobDeliveryChargeRemovalRequired(Convert.ToInt64(jobResult.Id), M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
                        }

                        if (isDeliveryChargeRemovalRequired)
                        {
                            _jobCommands.UpdateJobPriceOrCostCodeStatus(jobResult.Id, (int)StatusType.Delete, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
                        }

                        try
                        {
                            JobRollupHelper.StartJobRollUpProcess(jobResult, ActiveUser, NavAPIUrl, NavAPIUserName, NavAPIPassword);
                        }
                        catch (Exception exp)
                        {
                            DataAccess.Logger.ErrorLogger.Log(exp, "Error while creating Order in NAV after job Completion.", "StartJobRollUpProcess", Utilities.Logger.LogType.Error);
                        }

                        if (isDeliveryChargeRemovalRequired)
                        {
                            _jobCommands.UpdateJobPriceOrCostCodeStatus(jobResult.Id, (int)StatusType.Active, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
                        }
                    });
                }
            }
        }


    }
}