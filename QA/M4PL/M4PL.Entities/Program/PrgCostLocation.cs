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
// Program Name:                                 PrgCostLocation
// Purpose:                                      Contains objects related to PrgCostLocation
//==========================================================================================================

namespace M4PL.Entities.Program
{
	/// <summary>
	/// Model Class for Program Cost Locations
	/// </summary>
	public class PrgCostLocation : BaseModel
	{
		/// <summary>
		/// Gets or sets the progarm identifier.
		/// </summary>
		/// <value>
		/// The program identifier.
		/// </value>
		public long? PclProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Identifier's Name
		/// </summary>
		public string PclProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the vendor identifier.
		/// </summary>
		/// <value>
		/// The  vendor identifier.
		/// </value>
		public long? PclVendorID { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Identifier's Name
		/// </summary>
		public string PclVendorIDName { get; set; }

		/// <summary>
		/// Gets or sets the sorting order.
		/// </summary>
		/// <value>
		/// The PclItemNumber.
		/// </value>
		public int PclItemNumber { get; set; }

		/// <summary>
		/// Gets or sets the vendor location Code. e.g. SACRAMENTO CA
		/// </summary>
		/// <value>
		/// The PclLocationCode.
		/// </value>
		public string PclLocationCode { get; set; }

		/// <summary>
		/// Gets or sets the location code of customer. e.g. Default
		/// </summary>
		/// <value>
		/// The PclLocationCodeCustomer.
		/// </value>
		public string PclLocationCodeCustomer { get; set; }

		/// <summary>
		/// Gets or sets the title. e.g. Pacific Storage - Sacramento
		/// </summary>
		/// <value>
		/// The PclLocationTitle.
		/// </value>
		public string PclLocationTitle { get; set; }

		/// <summary>

		/// <summary>
		/// Gets or sets the user Code 1.
		/// </summary>
		/// <value>
		/// The PclUserCode1.
		/// </value>
		public string PclUserCode1 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 2.
		/// </summary>
		/// <value>
		/// The PclUserCode2.
		/// </value>
		public string PclUserCode2 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 3.
		/// </summary>
		/// <value>
		/// The PclUserCode3.
		/// </value>
		public string PclUserCode3 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 4.
		/// </summary>
		/// <value>
		/// The PclUserCode4.
		/// </value>
		public string PclUserCode4 { get; set; }

		/// <summary>
		/// Gets or sets the user Code 5.
		/// </summary>
		/// <value>
		/// The PclUserCode5.
		/// </value>
		public string PclUserCode5 { get; set; }
	}
}