#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Gets or Sets model Data for VOC Report request
	/// </summary>
	public class JobVOCReportRequest // : Support.MvcRoute
	{
		/// <summary>
		/// Gets or Sets list of Locations
		/// </summary>
		public List<string> Location { get; set; }
		/// <summary>
		/// Gets or Sets StartDate
		/// </summary>
		[DisplayName("Start Date")]
		public DateTime? StartDate { get; set; }
		/// <summary>
		/// Gets or Sets EndDate
		/// </summary>
		[DisplayName("End Date")]
		public DateTime? EndDate { get; set; }
		/// <summary>
		/// Gets or Sets CompanyId
		/// </summary>
		public long? CompanyId { get; set; }
		/// <summary>
		/// Gets or Sets flag if the current request is for PBS Report
		/// </summary>
		public bool IsPBSReport { get; set; }
	}
}