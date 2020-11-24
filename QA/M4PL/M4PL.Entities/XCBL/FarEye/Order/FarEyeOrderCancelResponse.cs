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
	/// <summary>
	/// Model class for FarEye Order Cancel Response
	/// </summary>
	public class FarEyeOrderCancelResponse
	{
		/// <summary>
		/// Gets or Sets status
		/// </summary>
		public int status { get; set; }
		/// <summary>
		/// Gets or Sets reference id
		/// </summary>
		public string reference_id { get; set; }
		/// <summary>
		/// Gets or Sets timestamp
		/// </summary>
		public long timestamp { get; set; }
		/// <summary>
		/// Gets or Sets order number
		/// </summary>
		public string order_number { get; set; }
		/// <summary>
		/// Gets or Sets execution time
		/// </summary>
		public int execution_time { get; set; }
		/// <summary>
		/// Gets or Sets List of items track details
		/// </summary>
		public List<ItemsTrackDetail> items_track_details { get; set; }
		/// <summary>
		/// Gets or Sets List of errors
		/// </summary>
		public List<string> errors { get; set; }

	}
	/// <summary>
	/// Model class Items Track Detail
	/// </summary>
	public class ItemsTrackDetail
	{
		/// <summary>
		/// Gets or Sets Tracking Number
		/// </summary>
		public string tracking_number { get; set; }
		/// <summary>
		/// Gets or Sets Status
		/// </summary>
		public string status { get; set; }
		/// <summary>
		/// Gets or Sets Message
		/// </summary>
		public string message { get; set; }
	}
}