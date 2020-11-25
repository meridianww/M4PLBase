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
	/// <summary>
	/// Model class for Scanner Catalog List
	/// </summary>
	public class ScrCatalogList : BaseModel
	{
		/// <summary>
		/// Gets or Sets Catalog ProgramID
		/// </summary>
		public long? CatalogProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Catalog ProgramID Name
		/// </summary>
		public string CatalogProgramIDName { get; set; }
		/// <summary>
		/// Gets or Sets Catalog ItemNumber/Sorting Order
		/// </summary>
		public int? CatalogItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Code
		/// </summary>
		public string CatalogCode { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Title
		/// </summary>
		public string CatalogTitle { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Desc
		/// </summary>
		public string CatalogDesc { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Photo/Image
		/// </summary>
		public byte[] CatalogPhoto { get; set; }
		/// <summary>
		/// Gets or Sets CatalogCustCode
		/// </summary>
		public string CatalogCustCode { get; set; }
		/// <summary>
		/// Gets or Sets Catalog UoM Code
		/// </summary>
		public string CatalogUoMCode { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Cubes
		/// </summary>
		public decimal CatalogCubes { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Width
		/// </summary>
		public decimal CatalogWidth { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Length
		/// </summary>
		public decimal CatalogLength { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Height
		/// </summary>
		public decimal CatalogHeight { get; set; }
		/// <summary>
		/// Gets or Sets Catalog Weight
		/// </summary>
		public int CatalogWeight { get; set; }
		/// <summary>
		/// Gets or Sets Catalog WLHUoM
		/// </summary>
		public int CatalogWLHUoM { get; set; }

	}
}