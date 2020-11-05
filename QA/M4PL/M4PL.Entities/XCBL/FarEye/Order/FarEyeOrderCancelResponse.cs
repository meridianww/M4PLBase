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

namespace M4PL.Entities.XCBL.FarEye.Order
{
	public class FarEyeOrderCancelResponse
	{
		public int status { get; set; }
		public string reference_id { get; set; }
		public long timestamp { get; set; }
		public string order_number { get; set; }
		public int execution_time { get; set; }
		public List<ItemsTrackDetail> items_track_details { get; set; }
		public List<string> errors { get; set; }
	}

	public class ItemsTrackDetail
	{
		public string tracking_number { get; set; }
		public string status { get; set; }
		public string message { get; set; }
	}
}