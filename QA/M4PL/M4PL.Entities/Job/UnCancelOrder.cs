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
	/// Model class for revoking cancellation
	/// </summary>
	public class UnCancelOrder
	{
		/// <summary>
		/// Gets or Sets Order Number/ COntract #
		/// </summary>
		public string OrderNumber { get; set; }
		/// <summary>
		/// Gets or Sets reason for un cancellation
		/// </summary>
		public string UnCancelReason { get; set; }
		/// <summary>
		/// Gets or Sets Comments for Uncancellation
		/// </summary>
		public string UnCancelComment { get; set; }
	}
}
