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
	/// Model class for FarEye Order Response
	/// </summary>
	public class FarEyeOrderResponse
	{
		/// <summary>
		/// Gets or Sets Status e.g. 200
		/// </summary>
		public int status { get; set; }
		/// <summary>
		/// Gets or Sets Order Number
		/// </summary>
		public string orderNumber { get; set; }
		/// <summary>
		/// Gets or Sets Tracking Number
		/// </summary>
		public string trackingNumber { get; set; }
		/// <summary>
		/// Gets or Sets time stamp
		/// </summary>
		public long timestamp { get; set; }
		/// <summary>
		/// Gets or Sets List of errors
		/// </summary>
		public List<string> errors { get; set; }
	}
}
