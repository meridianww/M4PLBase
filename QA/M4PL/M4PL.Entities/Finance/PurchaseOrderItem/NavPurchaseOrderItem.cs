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
// Date Programmed:                              10/03/2019
// Program Name:                                 NavSalesOrder
// Purpose:                                      Contains objects related to PurchaseOrderItem
//==========================================================================================================

using Newtonsoft.Json;

namespace M4PL.Entities.Finance.PurchaseOrderItem
{
	public class NavPurchaseOrderItem
	{
		[JsonProperty("@odata.etag")]
		public string DataETag { get; set; }

		public string Document_Type { get; set; }
		public string Document_No { get; set; }
		public int Line_No { get; set; }
		public string Type { get; set; }
		public string FilteredTypeField { get; set; }
		public string No { get; set; }
		public string M4PL_Job_ID { get; set; }
		public string Cross_Reference_No { get; set; }
		public string IC_Partner_Code { get; set; }
		public string IC_Partner_Ref_Type { get; set; }
		public string IC_Partner_Reference { get; set; }
		public string Variant_Code { get; set; }
		public bool Nonstock { get; set; }
		public string GST_HST { get; set; }
		public string VAT_Prod_Posting_Group { get; set; }
		public string Description { get; set; }
		public bool Drop_Shipment { get; set; }
		public string Return_Reason_Code { get; set; }
		public string Location_Code { get; set; }
		public string Bin_Code { get; set; }
		public decimal Quantity { get; set; }
		public decimal Reserved_Quantity { get; set; }
		public decimal Job_Remaining_Qty { get; set; }

		////public string Unit_of_Measure_Code { get; set; }
		public string Unit_of_Measure { get; set; }

		public decimal Direct_Unit_Cost { get; set; }
		public decimal Indirect_Cost_Percent { get; set; }
		public decimal Unit_Cost_LCY { get; set; }
		public decimal Unit_Price_LCY { get; set; }
		public bool Tax_Liable { get; set; }
		public string Tax_Area_Code { get; set; }
		public string Provincial_Tax_Area_Code { get; set; }
		public string Tax_Group_Code { get; set; }
		public bool Use_Tax { get; set; }
		public decimal Line_Discount_Percent { get; set; }
		public decimal Line_Amount { get; set; }
		public decimal Line_Discount_Amount { get; set; }
		public decimal Prepayment_Percent { get; set; }
		public decimal Prepmt_Line_Amount { get; set; }
		public decimal Prepmt_Amt_Inv { get; set; }
		public bool Allow_Invoice_Disc { get; set; }
		public decimal Inv_Discount_Amount { get; set; }
		public decimal Inv_Disc_Amount_to_Invoice { get; set; }
		public decimal Qty_to_Receive { get; set; }
		public decimal Quantity_Received { get; set; }
		public decimal Qty_to_Invoice { get; set; }
		public decimal Quantity_Invoiced { get; set; }
		public decimal Prepmt_Amt_to_Deduct { get; set; }
		public decimal Prepmt_Amt_Deducted { get; set; }
		public bool Allow_Item_Charge_Assignment { get; set; }
		public decimal Qty_to_Assign { get; set; }
		public decimal Qty_Assigned { get; set; }
		public string Job_No { get; set; }
		public string Job_Task_No { get; set; }
		public int Job_Planning_Line_No { get; set; }
		public string Job_Line_Type { get; set; }
		public decimal Job_Unit_Price { get; set; }
		public decimal Job_Line_Amount { get; set; }
		public decimal Job_Line_Discount_Amount { get; set; }
		public decimal Job_Line_Discount_Percent { get; set; }
		public decimal Job_Total_Price { get; set; }
		public decimal Job_Unit_Price_LCY { get; set; }
		public decimal Job_Total_Price_LCY { get; set; }
		public decimal Job_Line_Amount_LCY { get; set; }
		public decimal Job_Line_Disc_Amount_LCY { get; set; }
		public string Requested_Receipt_Date { get; set; }
		public string Promised_Receipt_Date { get; set; }
		public string Planned_Receipt_Date { get; set; }
		public string Expected_Receipt_Date { get; set; }
		public string Order_Date { get; set; }
		public string Lead_Time_Calculation { get; set; }
		public string Planning_Flexibility { get; set; }
		public string Prod_Order_No { get; set; }
		public int Prod_Order_Line_No { get; set; }
		public string Operation_No { get; set; }
		public string Work_Center_No { get; set; }
		public bool Finished { get; set; }
		public decimal Whse_Outstanding_Qty_Base { get; set; }
		public string Inbound_Whse_Handling_Time { get; set; }
		public string Blanket_Order_No { get; set; }
		public int Blanket_Order_Line_No { get; set; }
		public int Appl_to_Item_Entry { get; set; }
		public string Deferral_Code { get; set; }
		public string Shortcut_Dimension_1_Code { get; set; }
		public string Shortcut_Dimension_2_Code { get; set; }
		public string ShortcutDimCode_x005B_3_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_4_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_5_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_6_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_7_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_8_x005D_ { get; set; }
		public bool IRS_1099_Liable { get; set; }
		public bool Over_Receive { get; set; }
		public bool Over_Receive_Verified { get; set; }
		public decimal EDI_Unit_Cost { get; set; }
		public bool EDI_Cost_Discrepancy { get; set; }
		public int EDI_Segment_Group { get; set; }
		public decimal Invoice_Discount_Amount { get; set; }
		public decimal Invoice_Disc_Pct { get; set; }

		////public decimal Total_Amount_Excl_VAT { get; set; }
		public decimal Total_VAT_Amount { get; set; }

		////public decimal Total_Amount_Incl_VAT { get; set; }
		public string RefreshTotals { get; set; }
	}
}