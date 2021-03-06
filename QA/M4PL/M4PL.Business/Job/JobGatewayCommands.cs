﻿#region Copyright

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
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Job.JobGatewayCommands;
using _jobCargoCommands = M4PL.DataAccess.Job.JobCargoCommands;

namespace M4PL.Business.Job
{
    public class JobGatewayCommands : BaseCommands<JobGateway>, IJobGatewayCommands
    {
        public BusinessConfiguration M4PLBusinessConfiguration
        {
            get { return CoreCache.GetBusinessConfiguration("EN", true); }
        }

        ////public string NavAPIUrl
        ////{
        ////    get { return M4PLBusinessConfiguration.NavAPIUrl; }
        ////}

        ////public string NavAPIUserName
        ////{
        ////    get { return M4PLBusinessConfiguration.NavAPIUserName; }
        ////}

        ////public string NavAPIPassword
        ////{
        ////    get { return M4PLBusinessConfiguration.NavAPIPassword; }
        ////}
        public List<CustomerNavConfiguration> CustomerNavConfiguration
        {
            get { return M4PLBusinessConfiguration.CustomerNavConfiguration; }
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
            PushDataToNav(gateway.JobID, jobGateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId, ActiveUser, gateway.CustomerId, gateway.PgdGatewayNavOrderOption);
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
                    if (!string.IsNullOrEmpty(item))
                    {
                        gateway = new JobGateway();
                        gateway = _commands.PostWithSettings(ActiveUser, userSysSetting, jobGateway,
                            M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong(), Convert.ToInt64(item));
                        gatewaysIds += gateway.Id + ",";
                    }
                }
                gateway.GatewayIds = gatewaysIds.Remove(gatewaysIds.Length - 1);
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId, ActiveUser, gateway.CustomerId, gateway.PgdGatewayNavOrderOption);
            }
            else
            {
                gateway = _commands.PostWithSettings(ActiveUser, userSysSetting, jobGateway, M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong());
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, gateway.GwyCompleted, gateway.JobTransitionStatusId, ActiveUser, gateway.CustomerId, gateway.PgdGatewayNavOrderOption);
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
           //// PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId, ActiveUser, gateway.CustomerId);
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
            ////PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, jobGateway.GwyCompleted, jobGateway.JobTransitionStatusId, ActiveUser, gateway.CustomerId);
            return gateway;
        }

        public bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId)
        {
            var gateway = _commands.InsJobGatewayPODIfPODDocExistsByJobId(ActiveUser, jobId);
            if (gateway != null)
            {
                PushDataToNav(gateway.JobID, gateway.GwyGatewayCode, gateway.GwyCompleted, 0, ActiveUser, gateway.CustomerId, gateway.PgdGatewayNavOrderOption);
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

        public void PushDataToNav(long? jobId, string gatewayCode, bool gatewayStatus, int? JobTransitionStatusId, ActiveUser activeUser, long customerId, int? gatewayNavOrderOption)
        {
            bool isSalesOrderPushRequired = false;
            bool isPurchaseOrderPushRequired = false;
            if (gatewayNavOrderOption.HasValue)
            {
                var systemOptions = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
                var pushRequiredStatus = systemOptions != null ? systemOptions.FirstOrDefault(x => x.Id == (int)gatewayNavOrderOption) : null;
                if (pushRequiredStatus != null && pushRequiredStatus.SysOptionName.Equals("Both", StringComparison.OrdinalIgnoreCase))
                {
                    isSalesOrderPushRequired = true;
                    isPurchaseOrderPushRequired = true;
                }
                else if(pushRequiredStatus != null && pushRequiredStatus.SysOptionName.Equals("Sales Order", StringComparison.OrdinalIgnoreCase))
                {
                    isSalesOrderPushRequired = true;
                }
                else if (pushRequiredStatus != null && pushRequiredStatus.SysOptionName.Equals("Purchase Order", StringComparison.OrdinalIgnoreCase))
                {
                    isPurchaseOrderPushRequired = true;
                }
            }

            Finance.Order.NavOrderCommands navOrderRepo = new Finance.Order.NavOrderCommands();
            string NavAPIUrl = string.Empty;
            string NavAPIUserName = string.Empty; 
            string NavAPIPassword = string.Empty;
            CustomerNavConfiguration currentCustomerNavConfiguration = null;
            long electroluxCustomerId = M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong();
            if (jobId.HasValue && customerId != electroluxCustomerId && !string.IsNullOrEmpty(gatewayCode) && (gatewayCode.Equals("Delivered", StringComparison.OrdinalIgnoreCase) || gatewayCode.Equals("DS Delivered", StringComparison.OrdinalIgnoreCase)))
            {
                UpdatePriceCostDeliveryChargeQuantity((long)jobId);
            }

            if (CustomerNavConfiguration != null && CustomerNavConfiguration.Count > 0)
            {
                if (CustomerNavConfiguration.Any(x => x.CustomerId == customerId))
                {
                    currentCustomerNavConfiguration = CustomerNavConfiguration.Where(x => x.CustomerId == customerId).FirstOrDefault();
                    NavAPIUrl = currentCustomerNavConfiguration.ServiceUrl;
                    NavAPIUserName = currentCustomerNavConfiguration.ServiceUserName;
                    NavAPIPassword = currentCustomerNavConfiguration.ServicePassword;
                }
                else
                {
                    NavAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
                    NavAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
                    NavAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
                }
            }
            else
            {
                NavAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
                NavAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
                NavAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
            }

            if (isSalesOrderPushRequired)
            {
                Task.Run(() =>
                {
                    navOrderRepo.GenerateSalesOrderInNav((long)jobId, NavAPIUrl, NavAPIUserName, NavAPIPassword, electroluxCustomerId, activeUser);
                });
            }

            if (isPurchaseOrderPushRequired)
            {
                Task.Run(() =>
                {
                    navOrderRepo.GeneratePurchaseOrderInNav((long)jobId, NavAPIUrl, NavAPIUserName, NavAPIPassword, electroluxCustomerId, activeUser);
                });
            }
        }

        private void UpdatePriceCostDeliveryChargeQuantity(long jobId)
        {
            DataAccess.Job.JobCommands.UpdatePriceCostDeliveryChargeQuantity(jobId);
        }

        public List<JobActionGateway> GetActionsByJobIds(string jobIds)
        {
            return _commands.GetActionsByJobIds(jobIds);
        }
    }
}