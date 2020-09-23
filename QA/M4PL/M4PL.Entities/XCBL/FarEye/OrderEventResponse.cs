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
	public class OrderEventResponse
	{
		[JsonProperty("status")]
		public int Status { get; set; }

		[JsonProperty("orderNumber")]
		public string OrderNumber { get; set; }

		[JsonProperty("trackingNumber")]
		public string TrackingNumber { get; set; }

		[JsonProperty("timestamp")]
		public long Timestamp { get; set; }

		[JsonProperty("errors")]
		public List<string> Errors { get; set; }
	}
}
