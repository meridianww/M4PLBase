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
// Program Name:                                 ScnCargoDetail
// Purpose:                                      Contains objects related to ScnCargoDetail
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model Class for Scanner Cargo Detail ID
	/// </summary>
	public class ScnCargoDetail : BaseModel
	{
		/// <summary>
		/// Gets or Sets Cargo Detail ID
		/// </summary>
		public long CargoDetailID { get; set; }
		/// <summary>
		/// Gets or Sets Cargo ID
		/// </summary>
		public long? CargoID { get; set; }
		/// <summary>
		/// Gets or Sets DetSerial Number
		/// </summary>
		public string DetSerialNumber { get; set; }
		/// <summary>
		/// Gets or Sets DetQty Counted
		/// </summary>
		public decimal DetQtyCounted { get; set; }
		/// <summary>
		/// Gets or Sets DetQty Damaged
		/// </summary>
		public decimal DetQtyDamaged { get; set; }
		/// <summary>
		/// Gets or Sets DetQty Short
		/// </summary>
		public decimal DetQtyShort { get; set; }
		/// <summary>
		/// Gets or Sets DetQty Over
		/// </summary>
		public decimal DetQtyOver { get; set; }
		/// <summary>
		/// Gets or Sets DetPick Status
		/// </summary>
		public string DetPickStatus { get; set; }
		/// <summary>
		/// Gets or Sets DetLongitude
		/// </summary>
		public string DetLong { get; set; }
		/// <summary>
		/// Gets or Sets DetLatitude
		/// </summary>
		public string DetLat { get; set; }

	}
}