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
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Driver Scrub Report Data
	/// </summary>
	public class JobDriverScrubReportData
	{
		/// <summary>
		/// Gets or Sets Customer Id
		/// </summary>
		public long CustomerId { get; set; }
		/// <summary>
		/// Gets or Sets Start Date
		/// </summary>
		public DateTime StartDate { get; set; }
		/// <summary>
		/// Gets or Sets End Date
		/// </summary>
		public DateTime EndDate { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public string Description { get; set; }
		/// <summary>
		/// Gets or Sets AWC Driver Scrub Report Raw Data
		/// </summary>
		public List<AWCDriverScrubReportRawData> AWCDriverScrubReportRawData { get; set; }
		/// <summary>
		/// Gets or Sets Common Driver Scrub Report Raw Data
		/// </summary>
		public List<CommonDriverScrubReportRawData> CommonDriverScrubReportRawData { get; set; }
	}
}
