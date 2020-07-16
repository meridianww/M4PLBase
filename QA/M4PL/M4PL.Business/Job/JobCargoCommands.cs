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
// Program Name:                                 JobCargoCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobCargoCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using _commands = M4PL.DataAccess.Job.JobCargoCommands;

namespace M4PL.Business.Job
{
    public class JobCargoCommands : BaseCommands<JobCargo>, IJobCargoCommands
    {
        /// <summary>
        /// Get list of job cargo data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<JobCargo> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job cargo record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public JobCargo Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a newjob cargo record
        /// </summary>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public JobCargo Post(JobCargo jobCargo)
        {
            return _commands.Post(ActiveUser, jobCargo);
        }

        /// <summary>
        /// Updates an existing job cargo record
        /// </summary>
        /// <param name="jobCargo"></param>
        /// <returns></returns>

        public JobCargo Put(JobCargo jobCargo)
        {
            return _commands.Put(ActiveUser, jobCargo);
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

        public JobCargo Patch(JobCargo entity)
        {
            throw new NotImplementedException();
        }

		public StatusModel CreateCargoException(JobCargoException jobCargoException, long cargoId)
		{
			JobExceptionInfo selectedJobExceptionInfo = null;
			JobInstallStatus selectedJobInstallStatus = null;
			StatusModel statusModel = CargoExceptionValidation(jobCargoException, cargoId, out selectedJobExceptionInfo, out selectedJobInstallStatus);
			if (statusModel != null) { return statusModel; }

			statusModel = _commands.CreateCargoException(cargoId, selectedJobExceptionInfo, selectedJobInstallStatus, jobCargoException.CargoQuantity, jobCargoException.CgoReasonCodeOSD, jobCargoException.CgoDateLastScan, ActiveUser);

			if (statusModel == null) { return new StatusModel() { AdditionalDetail = "There is some issue while processing the request.", Status = "Failure", StatusCode = 500 };}

			return statusModel;
		}

		private StatusModel CargoExceptionValidation(JobCargoException jobCargoException, long cargoId, out JobExceptionInfo selectedJobExceptionInfo, out JobInstallStatus selectedJobInstallStatus)
		{
			StatusModel statusModel = null;
			selectedJobExceptionInfo = null;
			selectedJobInstallStatus = null;
			if (cargoId <= 0)
			{
				return new StatusModel() { AdditionalDetail = "CargoId can not be less then or equal to zero.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (jobCargoException == null)
			{
				return new StatusModel() { AdditionalDetail = "Request model can not be empty.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (jobCargoException.CargoQuantity <= 0)
			{
				return new StatusModel() { AdditionalDetail = "Cargo Quantity can not be less then or equal to zero.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobCargoException.InstallStatus))
			{
				return new StatusModel() { AdditionalDetail = "InstallStatus can not be empty, please sent a ExceptionCode for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobCargoException.ExceptionCode))
			{
				return new StatusModel() { AdditionalDetail = "ExceptionCode can not be empty, please sent a ExceptionCode for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (string.IsNullOrEmpty(jobCargoException.ExceptionReason))
			{
				return new StatusModel() { AdditionalDetail = "ExceptionReason can not be empty, please sent a ExceptionReason for processing.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			var jobExceptionDetail = M4PL.DataAccess.Common.CommonCommands.GetJobExceptionDetail(cargoId);
			if (jobExceptionDetail != null)
			{
				if (jobExceptionDetail.JobExceptionInfo != null && jobExceptionDetail.JobExceptionInfo.Count > 0)
				{
					var exceptionList = jobExceptionDetail.JobExceptionInfo.Where(x => x.ExceptionReasonCode.Equals(jobCargoException.ExceptionCode, StringComparison.OrdinalIgnoreCase));
					if (exceptionList.Any())
					{
						selectedJobExceptionInfo = exceptionList.Where(x => x.ExceptionTitle.Equals(jobCargoException.ExceptionReason, StringComparison.OrdinalIgnoreCase)).Any() ? exceptionList.Where(x => x.ExceptionTitle.Equals(jobCargoException.ExceptionReason, StringComparison.OrdinalIgnoreCase)).FirstOrDefault() : null;
						if (selectedJobExceptionInfo == null)
						{
							selectedJobExceptionInfo = exceptionList.FirstOrDefault();
						}
					}
				}

				if (jobExceptionDetail.JobInstallStatus != null && jobExceptionDetail.JobInstallStatus.Count > 0)
				{
					var installStatusList = jobExceptionDetail.JobInstallStatus.Where(x => x.InstallStatusDescription.Equals(jobCargoException.InstallStatus, StringComparison.OrdinalIgnoreCase));
					if (installStatusList.Any())
					{
						selectedJobInstallStatus = installStatusList.FirstOrDefault();
					}
				}
			}
			else
			{
				return new StatusModel() { AdditionalDetail = "There is some issue while M4PL API trying to fetch the avaliable exception list, please try again.", StatusCode = (int)HttpStatusCode.InternalServerError, Status = "Failure" };
			}

			if (selectedJobInstallStatus == null)
			{
				return new StatusModel() { AdditionalDetail = "InstallStatus recieved in the request is not avalible in M4PL.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			if (selectedJobExceptionInfo == null)
			{
				return new StatusModel() { AdditionalDetail = "ExceptionCode recieved in the request is not avalible in M4PL.", StatusCode = (int)HttpStatusCode.PreconditionFailed, Status = "Failure" };
			}

			return statusModel;
		}
	}
}