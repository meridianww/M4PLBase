﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobCargo
// Purpose:                                      Contains objects related to JobCargo
//==========================================================================================================

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	///
	/// </summary>
	public class JobCargo : BaseModel
	{
		/// <summary>
		/// Gets or sets the Job identifier.
		/// </summary>
		/// <value>
		/// The Job identifier.
		/// </value>
		public long? JobID { get; set; }

		public string JobIDName { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? CgoLineItem { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string CgoPartNumCode { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string CgoTitle { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string CgoSerialNumber { get; set; }

		public int? CgoPackagingTypeId { get; set; }

		public string CgoPackagingTypeIdName { get; set; }

		public string CgoMasterCartonLabel { get; set; }

		public decimal CgoWeight { get; set; }

		public int? CgoWeightUnitsId { get; set; }

		public string CgoWeightUnitsIdName { get; set; }

		public decimal CgoLength { get; set; }

		public decimal CgoWidth { get; set; }

		public decimal CgoHeight { get; set; }

		public int? CgoVolumeUnitsId { get; set; }

		public string CgoVolumeUnitsIdName { get; set; }

		public decimal CgoCubes { get; set; }

		public int CgoQtyOrdered { get; set; }

		public int CgoQtyExpected { get; set; }

		public int CgoQtyOnHand { get; set; }

		public int CgoQtyDamaged { get; set; }

		public int CgoQtyOnHold { get; set; }

		public int CgoQtyShortOver { get; set; }

		public int CgoQtyOver { get; set; }

		public int? CgoQtyUnitsId { get; set; }

		public string CgoQtyUnitsIdName { get; set; }

		public string CgoReasonCodeOSD { get; set; }

		public string CgoReasonCodeHold { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? CgoSeverityCode { get; set; }

		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string CgoProcessingFlags { get; set; }

		public bool JobCompleted { get; set; }

		public string CgoLatitude { get; set; }

		public string CgoLongitude { get; set; }

		public string CgoComment { get; set; }

		public DateTime? CgoDateLastScan { get; set; }
	}
}