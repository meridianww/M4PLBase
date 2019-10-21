/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrderItem
Purpose:                                      Contains objects related to NavSalesOrderItem
==========================================================================================================*/

namespace M4PL.Entities.Finance
{
	public class NavSalesOrderItem
	{
		public string Document_Type { get; set; }
		public string Document_No { get; set; }
		public int Line_No { get; set; }
		public string Type { get; set; }
		public string FilteredTypeField { get; set; }
		public string No { get; set; }
		public string M4PL_Job_ID { get; set; }
		public bool Surcharge { get; set; }
		public string Cross_Reference_No { get; set; }
		public string IC_Partner_Code { get; set; }
		public string IC_Partner_Ref_Type { get; set; }
		public string IC_Partner_Reference { get; set; }
		public string Variant_Code { get; set; }
		public bool Substitution_Available { get; set; }
		public string Purchasing_Code { get; set; }
		public bool Nonstock { get; set; }
		public string VAT_Prod_Posting_Group { get; set; }
		public string Description { get; set; }
		public decimal Net_Weight { get; set; }
		public bool Rate_Quoted { get; set; }
		public bool Drop_Shipment { get; set; }
		public bool Special_Order { get; set; }
		public string Return_Reason_Code { get; set; }
		public string Package_Tracking_No { get; set; }
		public string Location_Code { get; set; }
		public string Bin_Code { get; set; }
		public string Reserve { get; set; }
		public decimal Quantity { get; set; }
		public decimal Qty_to_Assemble_to_Order { get; set; }
		public decimal Std_Pack_Quantity { get; set; }
		public decimal Reserved_Quantity { get; set; }
		public string Unit_of_Measure_Code { get; set; }
		public string Std_Pack_Unit_of_Measure_Code { get; set; }
		public int Std_Packs_per_Package { get; set; }
		public string Unit_of_Measure { get; set; }
		public decimal Unit_Cost_LCY { get; set; }
		public bool SalesPriceExist { get; set; }
		public decimal Unit_Price { get; set; }
		public bool Tax_Liable { get; set; }
		public string Tax_Area_Code { get; set; }
		public string Tax_Group_Code { get; set; }
		public decimal Line_Discount_Percent { get; set; }
		public decimal Line_Amount { get; set; }
		public decimal Amount_Including_VAT { get; set; }
		public bool SalesLineDiscExists { get; set; }
		public decimal Line_Discount_Amount { get; set; }
		public decimal Prepayment_Percent { get; set; }
		public decimal Prepmt_Line_Amount { get; set; }
		public decimal Prepmt_Amt_Inv { get; set; }
		public bool Allow_Invoice_Disc { get; set; }
		public decimal Inv_Discount_Amount { get; set; }
		public decimal Inv_Disc_Amount_to_Invoice { get; set; }
		public decimal Qty_to_Ship { get; set; }
		public decimal Std_Pack_Qty_to_Ship { get; set; }
		public decimal Package_Qty_to_Ship { get; set; }
		public decimal Quantity_Shipped { get; set; }
		public decimal Qty_to_Invoice { get; set; }
		public decimal Quantity_Invoiced { get; set; }
		public decimal Prepmt_Amt_to_Deduct { get; set; }
		public decimal Prepmt_Amt_Deducted { get; set; }
		public bool Allow_Item_Charge_Assignment { get; set; }
		public decimal Qty_to_Assign { get; set; }
		public decimal Qty_Assigned { get; set; }
		public string Requested_Delivery_Date { get; set; }
		public string Promised_Delivery_Date { get; set; }
		public string Planned_Delivery_Date { get; set; }
		public string Planned_Shipment_Date { get; set; }
		public string Shipment_Date { get; set; }
		public string Shipping_Agent_Code { get; set; }
		public string Shipping_Agent_Service_Code { get; set; }
		public string Shipping_Time { get; set; }
		public string Work_Type_Code { get; set; }
		public decimal Whse_Outstanding_Qty { get; set; }
		public decimal Whse_Outstanding_Qty_Base { get; set; }
		public decimal ATO_Whse_Outstanding_Qty { get; set; }
		public decimal ATO_Whse_Outstd_Qty_Base { get; set; }
		public string Outbound_Whse_Handling_Time { get; set; }
		public string Blanket_Order_No { get; set; }
		public int Blanket_Order_Line_No { get; set; }
		public string FA_Posting_Date { get; set; }
		public bool Depr_until_FA_Posting_Date { get; set; }
		public string Depreciation_Book_Code { get; set; }
		public bool Use_Duplication_List { get; set; }
		public string Duplicate_in_Depreciation_Book { get; set; }
		public decimal Appl_from_Item_Entry { get; set; }
		public decimal Appl_to_Item_Entry { get; set; }
		public string Deferral_Code { get; set; }
		public string Shortcut_Dimension_1_Code { get; set; }
		public string Shortcut_Dimension_2_Code { get; set; }
		public string ShortcutDimCode_x005B_3_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_4_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_5_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_6_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_7_x005D_ { get; set; }
		public string ShortcutDimCode_x005B_8_x005D_ { get; set; }
		public string Required_Shipping_Agent_Code { get; set; }
		public string Required_E_Ship_Agent_Service { get; set; }
		public bool Allow_Other_Ship_Agent_Serv { get; set; }
		public decimal TotalSalesLine_Line_Amount { get; set; }
		public decimal Invoice_Discount_Amount { get; set; }
		public decimal Invoice_Disc_Pct { get; set; }
		public decimal Total_Amount_Excl_VAT { get; set; }
		public decimal Total_VAT_Amount { get; set; }
		public decimal Total_Amount_Incl_VAT { get; set; }
	}
}
