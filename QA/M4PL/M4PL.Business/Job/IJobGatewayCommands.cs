﻿#region Copyright

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
//==============================================================================================================

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
		JobGateway GetGatewayWithParent(long id, long parentId, string entityFor, bool is3PlAction, string gatewayCode = null);

		JobGatewayComplete GetJobGatewayComplete(long id, long parentId);

		JobGatewayComplete PutJobGatewayComplete(JobGatewayComplete jobGateway);

		//IList<JobAction> GetJobAction(long jobId);
		JobGateway PutJobAction(JobGateway jobGateway);

		JobGateway PutWithSettings(SysSetting userSysSetting, JobGateway jobGateway);

		JobGateway PostWithSettings(SysSetting userSysSetting, JobGateway jobGateway);

		JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle);

		Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact);

		bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId);

		List<JobActionGateway> GetActionsByJobIds(string jobIds);
	}
}