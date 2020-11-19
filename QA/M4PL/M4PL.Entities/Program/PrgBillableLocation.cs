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
// Programmer:                                   Nikhil
// Date Programmed:                              22/07/2019
// Program Name:                                 PrgBillableLocation
// Purpose:                                      Contains objects related to PrgBillableLocation
//==========================================================================================================

namespace M4PL.Entities.Program
{
	public class PrgBillableLocation : BaseModel
	{
		/// <summary>
		/// Gets or Sets Program ID
		/// </summary>
		public long? PblProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Identifier's Name
		/// </summary>
		public string PblProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the vendor identifier.
		/// </summary>
		/// <value>
		/// The  vendor identifier.
		/// </value>
		public long? PblVendorID { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Identifier's Name
		/// </summary>
		public string PblVendorIDName { get; set; }

		/// <summary>
		/// Gets or sets the sorting order.
		/// </summary>
		/// <value>
		/// The PblItemNumber.
		/// </value>
		public int PblItemNumber { get; set; }

		/// <summary>
		/// Gets or sets the vendor location type.  e.g. SACRAMENTO CA
		/// </summary>
		/// <value>
		/// The PblLocationCode.
		/// </value>
		public string PblLocationCode { get; set; }

		/// <summary>
		/// Gets or sets the location code of customer. e.g. Default
		/// </summary>
		/// <value>
		/// The PblLocationCodeCustomer.
		/// </value>
		public string PblLocationCodeVendor { get; set; }

		/// <summary>
		/// Gets or sets the title.  e.g. Pacific Storage - Sacramento
		/// </summary>
		/// <value>
		/// The PblLocationTitle.
		/// </value>
		public string PblLocationTitle { get; set; }

		/// <summary>

		/// <summary>
		/// Gets or sets the user Code 1.
		/// </summary>
		/// <value>
		/// The PblUserCode1.
		/// </value>
		public string PblUserCode1 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 2.
		/// </summary>
		/// <value>
		/// The PblUserCode2.
		/// </value>
		public string PblUserCode2 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 3.
		/// </summary>
		/// <value>
		/// The PblUserCode3.
		/// </value>
		public string PblUserCode3 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 4.
		/// </summary>
		/// <value>
		/// The PblUserCode4.
		/// </value>
		public string PblUserCode4 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 5.
		/// </summary>
		/// <value>
		/// The PblUserCode5.
		/// </value>
		public string PblUserCode5 { get; set; }
	}
}