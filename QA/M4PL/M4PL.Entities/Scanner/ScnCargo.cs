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
// Program Name:                                 ScnCargo
// Purpose:                                      Contains objects related to ScnCargo
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Cargos
	/// </summary>
	public class ScnCargo : BaseModel
	{
		/// <summary>
		/// Gets or Sets CargoID
		/// </summary>
		public long CargoID { get; set; }
		/// <summary>
		/// Gets or Sets JobID
		/// </summary>
		public long? JobID { get; set; }
		/// <summary>
		/// Gets or Sets CgoLine Item
		/// </summary>
		public int? CgoLineItem { get; set; }
		/// <summary>
		/// Gets or Sets Cgo PartNumCode
		/// </summary>
		public string CgoPartNumCode { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Ordered
		/// </summary>
		public decimal CgoQtyOrdered { get; set; }
		/// <summary>
		/// Gets or Sets CgoQtyExpected
		/// </summary>
		public decimal CgoQtyExpected { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Counted
		/// </summary>
		public decimal CgoQtyCounted { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Damaged
		/// </summary>
		public decimal CgoQtyDamaged { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty OnHold
		/// </summary>
		public decimal CgoQtyOnHold { get; set; }
		/// <summary>
		/// Gets or Sets Cgo QtyS hort
		/// </summary>
		public decimal CgoQtyShort { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Over
		/// </summary>
		public decimal CgoQtyOver { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Units
		/// </summary>
		public string CgoQtyUnits { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Status
		/// </summary>
		public string CgoStatus { get; set; }
		/// <summary>
		/// Gets or Sets Cgo InfoID
		/// </summary>
		public string CgoInfoID { get; set; }
		/// <summary>
		/// Gets or Sets Color CD
		/// </summary>
		public int? ColorCD { get; set; }
		/// <summary>
		/// Gets or Sets Cgo SerialCD
		/// </summary>
		public string CgoSerialCD { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Longitude
		/// </summary>
		public string CgoLong { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Latitude
		/// </summary>
		public string CgoLat { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag01
		/// </summary>
		public string CgoProFlag01 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag02
		/// </summary>
		public string CgoProFlag02 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag03
		/// </summary>
		public string CgoProFlag03 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag04
		/// </summary>
		public string CgoProFlag04 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag05
		/// </summary>
		public string CgoProFlag05 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag06
		/// </summary>
		public string CgoProFlag06 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag07
		/// </summary>
		public string CgoProFlag07 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag08
		/// </summary>
		public string CgoProFlag08 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag09
		/// </summary>
		public string CgoProFlag09 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag10
		/// </summary>
		public string CgoProFlag10 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag11
		/// </summary>
		public string CgoProFlag11 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag12
		/// </summary>
		public string CgoProFlag12 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag13
		/// </summary>
		public string CgoProFlag13 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag14
		/// </summary>
		public string CgoProFlag14 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag15
		/// </summary>
		public string CgoProFlag15 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag16
		/// </summary>
		public string CgoProFlag16 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag17
		/// </summary>
		public string CgoProFlag17 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag18
		/// </summary>
		public string CgoProFlag18 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag19
		/// </summary>
		public string CgoProFlag19 { get; set; }
		/// <summary>
		/// Gets or Sets CgoProFlag20
		/// </summary>
		public string CgoProFlag20 { get; set; }

	}
}