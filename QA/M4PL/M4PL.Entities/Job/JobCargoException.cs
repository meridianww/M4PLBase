#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Cargo Exception
	/// </summary>
	public class JobCargoException
	{
		/// <summary>
		/// Gets or Sets Exception Code
		/// </summary>
		public string ExceptionCode { get; set; }
		/// <summary>
		/// Gets or Sets Exception Reason
		/// </summary>
		public string ExceptionReason { get; set; }
		/// <summary>
		/// Gets or Sets Install Status
		/// </summary>
		public string InstallStatus { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Quantity
		/// </summary>
		public int CargoQuantity { get; set; }
		/// <summary>
		/// Gets or Sets CgoReason Code OSD
		/// </summary>
		public string CgoReasonCodeOSD { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Date LastScan
		/// </summary>
		public DateTime? CgoDateLastScan { get; set; }

	}
}