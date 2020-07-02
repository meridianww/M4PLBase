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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/31/2019
// Program Name:                                 NavPriceCode
// Purpose:                                      Contains objects related to NavPriceCode
//==========================================================================================================

namespace M4PL.Entities.Finance.PriceCode
{
	public class NavPriceCode : BaseModel
	{
		public string Item_No { get; set; }
		public string Sales_Type { get; set; }
		public string Sales_Code { get; set; }
		public string Starting_Date { get; set; }
		public string Currency_Code { get; set; }
		public string Variant_Code { get; set; }
		public string Unit_of_Measure_Code { get; set; }
		public int Minimum_Quantity { get; set; }
		public string SalesTypeFilter { get; set; }
		public string SalesCodeFilterCtrl { get; set; }
		public string ItemNoFilterCtrl { get; set; }
		public string StartingDateFilter { get; set; }
		public string SalesCodeFilterCtrl2 { get; set; }
		public string GetFilterDescription { get; set; }
		public decimal? Unit_Price { get; set; }
		public string Ending_Date { get; set; }
		public bool Price_Includes_VAT { get; set; }
		public bool Allow_Line_Disc { get; set; }
		public bool Allow_Invoice_Disc { get; set; }
		public string VAT_Bus_Posting_Gr_Price { get; set; }
	}
}