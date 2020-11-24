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
	/// Model class for FarEye Order Cancel Request 
	/// </summary>
	public class FarEyeOrderCancelRequest
	{
		/// <summary>
		/// Gets or Sets order number
		/// </summary>
		public string order_number { get; set; }
		/// <summary>
		/// Gets or Sets reference id
		/// </summary>
		public string reference_id { get; set; }
		/// <summary>
		/// Gets or Sets tracking number
		/// </summary>
		public List<string> tracking_number { get; set; }
		/// <summary>
		/// Gets or Sets carrier code
		/// </summary>
		public string carrier_code { get; set; }
		/// <summary>
		/// Gets or Sets reason
		/// </summary>
		public string reason { get; set; }

	}
}
