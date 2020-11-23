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
	/// Model class for Job Reschedule Details
	/// </summary>
	public class JobRescheduleDetail
	{
		/// <summary>
		/// Gets or Sets Install STatus
		/// </summary>
		public string InstallStatus { get; set; }
		/// <summary>
		/// Gets or Sets Reschedule Date
		/// </summary>
		public DateTime RescheduleDate { get; set; }
		/// <summary>
		/// Gets or Sets Reschedule Code
		/// </summary>
		public string RescheduleCode{ get; set; }
		/// <summary>
		/// Gets or Sets Reason for a reschedule
		/// </summary>
		public string RescheduleReason { get; set; }
	}
}
