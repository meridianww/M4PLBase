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
	public class ScnCargo : BaseModel
	{
		public long CargoID { get; set; }
		public long? JobID { get; set; }
		public int? CgoLineItem { get; set; }
		public string CgoPartNumCode { get; set; }
		public decimal CgoQtyOrdered { get; set; }
		public decimal CgoQtyExpected { get; set; }
		public decimal CgoQtyCounted { get; set; }
		public decimal CgoQtyDamaged { get; set; }
		public decimal CgoQtyOnHold { get; set; }
		public decimal CgoQtyShort { get; set; }
		public decimal CgoQtyOver { get; set; }
		public string CgoQtyUnits { get; set; }
		public string CgoStatus { get; set; }
		public string CgoInfoID { get; set; }
		public int? ColorCD { get; set; }
		public string CgoSerialCD { get; set; }
		public string CgoLong { get; set; }
		public string CgoLat { get; set; }
		public string CgoProFlag01 { get; set; }
		public string CgoProFlag02 { get; set; }
		public string CgoProFlag03 { get; set; }
		public string CgoProFlag04 { get; set; }
		public string CgoProFlag05 { get; set; }
		public string CgoProFlag06 { get; set; }
		public string CgoProFlag07 { get; set; }
		public string CgoProFlag08 { get; set; }
		public string CgoProFlag09 { get; set; }
		public string CgoProFlag10 { get; set; }
		public string CgoProFlag11 { get; set; }
		public string CgoProFlag12 { get; set; }
		public string CgoProFlag13 { get; set; }
		public string CgoProFlag14 { get; set; }
		public string CgoProFlag15 { get; set; }
		public string CgoProFlag16 { get; set; }
		public string CgoProFlag17 { get; set; }
		public string CgoProFlag18 { get; set; }
		public string CgoProFlag19 { get; set; }
		public string CgoProFlag20 { get; set; }
	}
}