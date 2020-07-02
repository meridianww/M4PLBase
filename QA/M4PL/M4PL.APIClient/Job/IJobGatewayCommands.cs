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
// Program Name:                                 IJobGatewayCommands
// Purpose:                                      Set of rules for JobGatewayCommands
//=============================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the JobGateway Entity
    /// </summary>
    public interface IJobGatewayCommands : IBaseCommands<JobGatewayView>
    {
        JobGatewayView GetGatewayWithParent(long id, long parentId, string entityFor = null, bool is3PlAction = false);
        JobGatewayComplete GetJobGatewayComplete(long id, long parentId);
        JobGatewayComplete PutJobGatewayComplete(JobGatewayComplete jobGateway);
        //IList<JobAction> GetJobAction(long jobId);
        JobGatewayView PutJobAction(JobGatewayView jobGatewayView);
        JobGatewayView PutWithSettings(JobGatewayView jobGatewayView);
        JobGatewayView PostWithSettings(JobGatewayView jobGatewayView);
        JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle);
        IList<JobGatewayDetails> GetJobGateway(long jobId);
    }
}