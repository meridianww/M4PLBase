﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Site Code
	/// </summary>
	public class JobsSiteCode : BaseModel
	{
		/// <summary>
		/// Gets or sets Location Code
		/// </summary>
		/// <value>
		/// The JobSiteCode.
		/// </value>
		public string PvlLocationCode { get; set; }

		/// <summary>
		/// Gets or sets the Vendor ID
		/// </summary>
		/// <value>
		/// The JobSiteId.
		/// </value>
		public long PvlVendorID { get; set; }
	}
}