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
// Program Name:                                 IJobReportCommands
// Purpose:                                      Set of rules for JobReportCommands
//==============================================================================================================
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
	/// <summary>
	/// Performs Reports for Job
	/// </summary>
	public interface IJobReportCommands : IBaseCommands<JobReport>
	{
		IList<JobVocReport> GetVocReportData(ActiveUser activeUser, long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport);

		IList<JobReport> GetDropDownDataForLocation(ActiveUser activeUser, long customerID, string entity);
	}
}