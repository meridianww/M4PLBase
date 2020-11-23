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
// Program Name:                                 NavCostCode
// Purpose:                                      Contains objects related to NavCostCode
//==========================================================================================================
namespace M4PL.Entities.Finance.CostCode
{
	/// <summary>
	/// Model Class for NAV Cost Code
	/// </summary>
	public class NavCostCode : BaseModel
	{
		/// <summary>
		/// Gets or Sets Item No
		/// </summary>
		public string Item_No { get; set; }
		/// <summary>
		/// Gets or Sets Vendor No
		/// </summary>
		public string Vendor_No { get; set; }
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
		/// Gets or Sets VendNoFilterCtrl
		/// </summary>
		public string VendNoFilterCtrl { get; set; }
		/// <summary>
		/// Gets or Sets ItemNoFIlterCtrl
		/// </summary>
		public string ItemNoFIlterCtrl { get; set; }
		/// <summary>
		/// Gets or Sets StartingDateFilter
		/// </summary>
		public string StartingDateFilter { get; set; }
		/// <summary>
		/// Gets or Sets Direct Unit Cost
		/// </summary>
		public decimal? Direct_Unit_Cost { get; set; }
		/// <summary>
		/// Gets or Sets Ending Date
		/// </summary>
		public string Ending_Date { get; set; }

	}
}