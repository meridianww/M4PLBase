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
	/// Model class for FarEye Order Event Response
	/// </summary>
	public class OrderEventResponse
	{
		/// <summary>
		/// Gets or Sets Status
		/// </summary>
		[JsonProperty("status")]
		public int Status { get; set; }
		/// <summary>
		/// Gets or Sets OrderN umber
		/// </summary>
		[JsonProperty("orderNumber")]
		public string OrderNumber { get; set; }
		/// <summary>
		/// Gets or Sets Tracking Number
		/// </summary>
		[JsonProperty("trackingNumber")]
		public string TrackingNumber { get; set; }
		/// <summary>
		/// Gets or Sets Timestamp
		/// </summary>
		[JsonProperty("timestamp")]
		public long Timestamp { get; set; }
		/// <summary>
		/// Gets or Sets List of Errors
		/// </summary>
		[JsonProperty("errors")]
		public List<string> Errors { get; set; }

	}
}
