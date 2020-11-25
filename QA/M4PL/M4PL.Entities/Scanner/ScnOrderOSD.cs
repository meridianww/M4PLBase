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
// Program Name:                                 ScnOrderOSD
// Purpose:                                      Contains objects related to ScnOrderOSD
//==========================================================================================================

using System;

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Order OSD
	/// </summary>
	public class ScnOrderOSD : BaseModel
	{
		/// <summary>
		/// Gets or Sets Cargo OSDID
		/// </summary>
		public long CargoOSDID { get; set; }
		/// <summary>
		/// Gets or Sets OSDID
		/// </summary>
		public long? OSDID { get; set; }
		/// <summary>
		/// Gets or Sets DateTime
		/// </summary>
		public DateTime? DateTime { get; set; }
		/// <summary>
		/// Gets or Sets Cargo DetailID
		/// </summary>
		public long? CargoDetailID { get; set; }
		/// <summary>
		/// Gets or Sets Cargo ID
		/// </summary>
		public long? CargoID { get; set; }
		/// <summary>
		/// Gets or Sets CgoSerial Number
		/// </summary>
		public string CgoSerialNumber { get; set; }
		/// <summary>
		/// Gets or Sets OSD ReasonID
		/// </summary>
		public long? OSDReasonID { get; set; }
		/// <summary>
		/// Gets or Sets OSD Qty
		/// </summary>
		public decimal OSDQty { get; set; }
		/// <summary>
		/// Gets or Sets Notes
		/// </summary>
		public string Notes { get; set; }
		/// <summary>
		/// Gets or Sets EditCD
		/// </summary>
		public string EditCD { get; set; }
		/// <summary>
		/// Gets or Sets StatusID
		/// </summary>
		public string StatusID { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Severity Code
		/// </summary>
		public string CgoSeverityCode { get; set; }

	}
}