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
//=============================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the Job Entity
    /// </summary>
    public interface IJobCommands : IBaseCommands<JobView>
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

        JobView GetJobByProgram(long id, long parentId);

        IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false);
        bool GetIsJobDataViewPermission(long recordId);

        bool CreateJobFromCSVImport(JobCSVData jobCSVData);

        List<ChangeHistoryData> GetChangeHistory(long jobId);
    }
}