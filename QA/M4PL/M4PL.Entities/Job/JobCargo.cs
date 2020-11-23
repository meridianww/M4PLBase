#region Copyright

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
		/// <summary>
		/// Gets or Sets Job Identifier's Name
		/// </summary>
		public string JobIDName { get; set; }

		/// <summary>
		/// Gets or sets the Cargo Line Item.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? CgoLineItem { get; set; }

		/// <summary>
		/// Gets or sets the Cargo Part Number Code.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string CgoPartNumCode { get; set; }

		/// <summary>
		/// Gets or sets the Cargo Title.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string CgoTitle { get; set; }

		/// <summary>
		/// Gets or sets the Cargo Serial Number.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string CgoSerialNumber { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Packaging Type Id
		/// </summary>
		public int? CgoPackagingTypeId { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Packaging Type Identifier's Name
		/// </summary>
		public string CgoPackagingTypeIdName { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Master Carton Label
		/// </summary>
		public string CgoMasterCartonLabel { get; set; }
		/// <summary>
		/// Gets or Sets Cargo weight
		/// </summary>
		public decimal CgoWeight { get; set; }

		/// <summary>
		/// Gets or Sets CgoWeightUnitsId
		/// </summary>
		public int? CgoWeightUnitsId { get; set; }
		/// <summary>
		/// Gets or Sets CgoWeightUnitsIdName
		/// </summary>
		public string CgoWeightUnitsIdName { get; set; }
		/// <summary>
		/// Gets or Sets CgoLength
		/// </summary>
		public decimal CgoLength { get; set; }
		/// <summary>
		/// Gets or Sets CgoWidth
		/// </summary>
		public decimal CgoWidth { get; set; }
		/// <summary>
		/// Gets or Sets CgoHeight
		/// </summary>
		public decimal CgoHeight { get; set; }
		/// <summary>
		/// Gets or Sets CgoVolumeUnitsId
		/// </summary>
		public int? CgoVolumeUnitsId { get; set; }
		/// <summary>
		/// Gets or Sets CgoVolumeUnitsIdName
		/// </summary>
		public string CgoVolumeUnitsIdName { get; set; }
		/// <summary>
		/// Gets or Sets CgoCubes
		/// </summary>
		public decimal CgoCubes { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyOrdered
		/// </summary>
		public int CgoQtyOrdered { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyExpected
		/// </summary>
		public int CgoQtyExpected { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyOnHand
		/// </summary>
		public int CgoQtyOnHand { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyDamaged
		/// </summary>
		public int CgoQtyDamaged { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyOnHold
		/// </summary>
		public int CgoQtyOnHold { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyShortOver
		/// </summary>
		public int CgoQtyShortOver { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyOver
		/// </summary>
		public int CgoQtyOver { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyUnitsId
		/// </summary>
		public int? CgoQtyUnitsId { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyUnitsIdName
		/// </summary>
		public string CgoQtyUnitsIdName { get; set; }
		/// <summary>
		/// Gets or Sets CgoReasonCodeOSD
		/// </summary>
		public string CgoReasonCodeOSD { get; set; }
		/// <summary>
		/// Gets or Sets CgoReasonCodeHold
		/// </summary>
		public string CgoReasonCodeHold { get; set; }

		/// <summary>
		/// Gets or sets the Cargo Severity Code.
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

		/// <summary>
		/// Gets or Sets flag if  JobCompleted
		/// </summary>
		public bool JobCompleted { get; set; }
		/// <summary>
		/// Gets or Sets CgoLatitude
		/// </summary>
		public string CgoLatitude { get; set; }
		/// <summary>
		/// Gets or Sets CgoLongitude
		/// </summary>
		public string CgoLongitude { get; set; }
		/// <summary>
		/// Gets or Sets CgoComment
		/// </summary>
		public string CgoComment { get; set; }
		/// <summary>
		/// Gets or Sets CgoDateLastScan
		/// </summary>
		public DateTime? CgoDateLastScan { get; set; }
		/// <summary>
		/// Gets or Sets JobGatewayStatus
		/// </summary>
		public string JobGatewayStatus { get; set; }
		/// <summary>
		/// Gets or Sets CustomerId
		/// </summary>
		public long CustomerId { get; set; }

	}
}