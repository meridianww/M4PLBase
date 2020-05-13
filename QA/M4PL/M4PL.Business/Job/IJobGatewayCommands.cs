/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobGatewayCommands
Purpose:                                      Set of rules for JobGatewayCommands
=============================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the JobGateway Entity
    /// </summary>
    public interface IJobGatewayCommands : IBaseCommands<JobGateway>
    {
        JobGateway GetGatewayWithParent(long id, long parentId ,string entityFor, bool is3PlAction);
        JobGatewayComplete GetJobGatewayComplete(long id, long parentId);
        JobGatewayComplete PutJobGatewayComplete(JobGatewayComplete jobGateway);
        IList<JobAction> GetJobAction(long jobId);
        JobGateway PutJobAction(JobGateway jobGateway);
        JobGateway PutWithSettings(SysSetting userSysSetting, JobGateway jobGateway);
        JobGateway PostWithSettings(SysSetting userSysSetting, JobGateway jobGateway);
        JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle);
        IList<JobGatewayDetails> GetJobGateway(long jobId);
        Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact);
    }
}