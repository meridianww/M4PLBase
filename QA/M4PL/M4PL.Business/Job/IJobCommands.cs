#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IJobCommands
// Purpose:                                      Set of rules for JobCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.FarEye;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the Job Entity
    /// </summary>
    public interface IJobCommands : IBaseCommands<Entities.Job.Job>
    {
        JobDestination GetJobDestination(long id, long parentId);

        Job2ndPoc GetJob2ndPoc(long id, long parentId);

        JobSeller GetJobSeller(long id, long parentId);

        JobMapRoute GetJobMapRoute(long id);

        JobPod GetJobPod(long id);

        JobDestination PutJobDestination(JobDestination jobDestination);

        Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc);

        JobSeller PutJobSeller(JobSeller jobSeller);

        JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute);

        Entities.Job.Job GetJobByProgram(long id, long parentId);

        IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false);

        bool UpdateJobAttributes(long jobId);

        bool InsertJobComment(JobComment comment);

        bool InsertJobGateway(long jobId, string gatewayStatusCode);

        long CreateJobFromEDI204(long eshHeaderID);

        bool GetIsJobDataViewPermission(long recordId);

        bool CreateJobFromCSVImport(JobCSVData jobCSVData);

        List<ChangeHistoryData> GetChangeHistory(long jobId);

        int UpdateJobCompleted(long custId, long programId, long jobId, DateTime deliveryDate, bool includeNullableDeliveryDate, ActiveUser activeUser);

        List<Entities.Job.Job> GetActiveJobByProgramId(long programId);

        bool UpdateJobInvoiceDetail(long jobId, JobInvoiceDetail jobInvoiceDetail);

        StatusModel CancelJobByOrderNumber(string orderNumber, string cancelComment, string cancelReason);

        StatusModel UnCancelJobByOrderNumber(string orderNumber, string unCancelReason, string unCancelComment);

        OrderLocationCoordinate GetOrderLocationCoordinate(string orderNumber);

        StatusModel RescheduleJobByOrderNumber(JobRescheduleDetail jobRescheduleDetail, string orderNumber, SysSetting sysSetting);

        StatusModel AddDriver(DriverContact driverContact);

        StatusModel InsertOrderSpecialInstruction(JobSpecialInstruction jobSpecialInstruction, string orderNumber);

        JobContact GetJobContact(long id, long parentId);
        StatusModel AddJobIsSchedule(long jobId, DateTime scheduleDate, string statusCode);
    }
}