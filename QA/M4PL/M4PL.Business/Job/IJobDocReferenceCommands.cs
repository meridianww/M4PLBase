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
// Program Name:                                 IJobDocReferenceCommands
// Purpose:                                      Set of rules for JobDocReferenceCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;

namespace M4PL.Business.Job
{
	/// <summary>
	/// Performs basis CRUD operation on the JobDocReference Entity
	/// </summary>
	public interface IJobDocReferenceCommands : IBaseCommands<JobDocReference>
	{
		JobDocReference PutWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference);

		JobDocReference PostWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference);

		StatusModel InsertJobDocumentData(JobDocumentAttachment jobDocumentAttachment, long jobId, string documentType);

		long GetNextSequence();
	}
}