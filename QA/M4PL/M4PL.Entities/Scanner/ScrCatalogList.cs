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
// Program Name:                                 ScrCatalogList
// Purpose:                                      Contains objects related to ScrCatalogList
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	public class ScrCatalogList : BaseModel
	{
		public long? CatalogProgramID { get; set; }
		public string CatalogProgramIDName { get; set; }
		public int? CatalogItemNumber { get; set; }
		public string CatalogCode { get; set; }
		public string CatalogTitle { get; set; }
		public string CatalogDesc { get; set; }
		public byte[] CatalogPhoto { get; set; }
		public string CatalogCustCode { get; set; }
		public string CatalogUoMCode { get; set; }
		public decimal CatalogCubes { get; set; }
		public decimal CatalogWidth { get; set; }
		public decimal CatalogLength { get; set; }
		public decimal CatalogHeight { get; set; }
		public int CatalogWeight { get; set; }
		public int CatalogWLHUoM { get; set; }
	}
}