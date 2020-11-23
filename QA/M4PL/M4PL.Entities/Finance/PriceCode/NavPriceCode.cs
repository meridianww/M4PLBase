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
	/// <summary>
	/// Model Class for NAV Price Code
	/// </summary>
	public class NavPriceCode : BaseModel
	{
		/// <summary>
		/// Gets or Sets Item No
		/// </summary>
		public string Item_No { get; set; }
		/// <summary>
		/// Gets or Sets Sales Type
		/// </summary>
		public string Sales_Type { get; set; }
		/// <summary>
		/// Gets or Sets Sales Code
		/// </summary>
		public string Sales_Code { get; set; }
		/// <summary>
		/// Gets or Sets Starting Date
		/// </summary>
		public string Starting_Date { get; set; }
		/// <summary>
		/// Gets or Sets Currency Code
		/// </summary>
		public string Currency_Code { get; set; }
		/// <summary>
		/// Gets or Sets Variant Code
		/// </summary>
		public string Variant_Code { get; set; }
		/// <summary>
		/// Gets or Sets Unit of Measure Code
		/// </summary>
		public string Unit_of_Measure_Code { get; set; }
		/// <summary>
		/// Gets or Sets Minimum Quantity
		/// </summary>
		public int Minimum_Quantity { get; set; }
		/// <summary>
		/// Gets or Sets SalesTypeFilter
		/// </summary>
		public string SalesTypeFilter { get; set; }
		/// <summary>
		/// Gets or Sets SalesCodeFilterCtrl
		/// </summary>
		public string SalesCodeFilterCtrl { get; set; }
		/// <summary>
		/// Gets or Sets ItemNoFilterCtrl
		/// </summary>
		public string ItemNoFilterCtrl { get; set; }
		/// <summary>
		/// Gets or Sets StartingDateFilter
		/// </summary>
		public string StartingDateFilter { get; set; }
		/// <summary>
		/// Gets or Sets SalesCodeFilterCtrl2
		/// </summary>
		public string SalesCodeFilterCtrl2 { get; set; }
		/// <summary>
		/// Gets or Sets GetFilterDescription
		/// </summary>
		public string GetFilterDescription { get; set; }
		/// <summary>
		/// Gets or Sets Unit Price
		/// </summary>
		public decimal? Unit_Price { get; set; }
		/// <summary>
		/// Gets or Sets Ending Date
		/// </summary>
		public string Ending_Date { get; set; }
		/// <summary>
		/// Gets or Sets Price Includes VAT
		/// </summary>
		public bool Price_Includes_VAT { get; set; }
		/// <summary>
		/// Gets or Sets Allow Line Disc
		/// </summary>
		public bool Allow_Line_Disc { get; set; }
		/// <summary>
		/// Gets or Sets Allow Invoice Disc
		/// </summary>
		public bool Allow_Invoice_Disc { get; set; }
		/// <summary>
		/// Gets or Sets VAT Bus Posting Gr Price
		/// </summary>
		public string VAT_Bus_Posting_Gr_Price { get; set; }

	}
}