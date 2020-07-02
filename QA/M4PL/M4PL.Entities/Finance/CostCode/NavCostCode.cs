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
    public class NavCostCode : BaseModel
    {

        public string Item_No { get; set; }
        public string Vendor_No { get; set; }
        public string Starting_Date { get; set; }
        public string Currency_Code { get; set; }
        public string Variant_Code { get; set; }
        public string Unit_of_Measure_Code { get; set; }
        public int Minimum_Quantity { get; set; }
        public string VendNoFilterCtrl { get; set; }
        public string ItemNoFIlterCtrl { get; set; }
        public string StartingDateFilter { get; set; }
        public decimal? Direct_Unit_Cost { get; set; }
        public string Ending_Date { get; set; }
    }
}
