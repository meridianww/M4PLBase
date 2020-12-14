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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              1/20/2020
// Program Name:                                 IJobAdvanceReportCommands
// Purpose:                                      Set of rules for JobAdvanceReportCommands
//=============================================================================================================

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
	/// <summary>
	/// Performs basic CRUD operation on the JobAdvanceReportCommands Entity
	/// </summary>
	public interface IJobAdvanceReportCommands : IBaseCommands<JobAdvanceReportView>
	{
		IList<JobAdvanceReportFilter> GetDropDownDataForProgram(string entity);

		StatusModel ImportScrubDriverDetails(JobDriverScrubReportData scriberDriverView);

		StatusModel ImportProjectedCapacityDetails(ProjectedCapacityData projectedCapacityView);
	}
}