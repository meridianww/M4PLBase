/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobCommands
Purpose:                                      Set of rules for JobCommands
=============================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Job;
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
        bool UpdateJobCompleted(long custId, long programId, long jobId,DateTime deliveryDate, bool includeNullableDeliveryDate);
        List<Entities.Job.Job> GetActiveJobByProgramId(long programId);
    }
}