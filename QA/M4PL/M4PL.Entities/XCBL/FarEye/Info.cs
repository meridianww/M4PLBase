#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL.FarEye
{
	/// <summary>
	/// Model class for FarEye Order Event Info
	/// </summary>
	public class Info
	{
		/// <summary>
		/// Gets or Sets Reschedule Date
		/// </summary>
		[JsonProperty("reschedule_date")]
		public string RescheduleDate { get; set; }
		/// <summary>
		/// Gets or Sets Reschedule Reason
		/// </summary>
		[JsonProperty("reschedule_reason")]
		public string RescheduleReason { get; set; }
	}
}
