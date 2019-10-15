/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrder
Purpose:                                      Contains objects related to NavPurchaseOrder
==========================================================================================================*/

namespace M4PL.Entities.Finance
{
	public class NavPurchaseOrderRequest
	{
		public string Buy_from_Vendor_No { get; set; }
		public string Buy_from_Vendor_Name { get; set; }
		public string M4PL_Job_ID { get; set; }
		public string Ship_from_Code { get; set; }
		public string Ship_from_Name { get; set; }
		public string Ship_from_Name_2 { get; set; }
		public string Ship_from_Address { get; set; }
		public string Ship_from_Address_2 { get; set; }
		public string Ship_from_City { get; set; }
		////public string Ship_From_County { get; set; }
		////public string Ship_From_Post_Code { get; set; }
		public string Ship_from_Contact { get; set; }
		public string Ship_from_Phone { get; set; }
		public string Ship_from_Mobile { get; set; }
		public string Ship_from_Email { get; set; }
		////public string Cust_Reference_No { get; set; }
		public string Buy_from_Address { get; set; }
		public string Buy_from_Address_2 { get; set; }
		public string Buy_from_City { get; set; }
		public string Buy_from_County { get; set; }
		public string Buy_from_Post_Code { get; set; }
		public string Buy_from_Contact_No { get; set; }
		public string Buy_from_Contact { get; set; }
		public string Document_Date { get; set; }
		public string Posting_Date { get; set; }
		public string Due_Date { get; set; }
		public string Shipment_Date { get; set; }
		public string Vendor_Invoice_No { get; set; }
		public string Purchaser_Code { get; set; }
		public int No_of_Archived_Versions { get; set; }
		public string Posting_Description { get; set; }
		public string Order_Date { get; set; }
		public string Quote_No { get; set; }
		public string Vendor_Order_No { get; set; }
		public string Vendor_Shipment_No { get; set; }
		public string Order_Address_Code { get; set; }
		public string Responsibility_Center { get; set; }
		public string Assigned_User_ID { get; set; }
		public string Status { get; set; }
		public string Job_Queue_Status { get; set; }
		public string Currency_Code { get; set; }
		public string Expected_Receipt_Date { get; set; }
		public string Payment_Terms_Code { get; set; }
		public string Transaction_Type { get; set; }
		public string Shortcut_Dimension_1_Code { get; set; }
		public string Shortcut_Dimension_2_Code { get; set; }
		public decimal Payment_Discount_Percent { get; set; }
		public string Pmt_Discount_Date { get; set; }
		public string Tax_Liable { get; set; }
		public string Tax_Area_Code { get; set; }
		public string Tax_Exemption_No { get; set; }
		public string Provincial_Tax_Area_Code { get; set; }
		public string Shipment_Method_Code { get; set; }
		public string Payment_Reference { get; set; }
		public string Creditor_No { get; set; }
		public string On_Hold { get; set; }
		public string Inbound_Whse_Handling_Time { get; set; }
		public string Lead_Time_Calculation { get; set; }
		public string Requested_Receipt_Date { get; set; }
		public string Promised_Receipt_Date { get; set; }
		public string IRS_1099_Code { get; set; }
		public string ShippingOptionWithLocation { get; set; }
		public string Location_Code { get; set; }
		public string Sell_to_Customer_No { get; set; }
		////public string Ship_to_Code { get; set; }
		////public string Ship_to_Name { get; set; }
		////public string Ship_to_Address { get; set; }
		////public string Ship_to_Address_2 { get; set; }
		////public string Ship_to_City { get; set; }
		////public string Ship_to_County { get; set; }
		////public string Ship_to_Post_Code { get; set; }
		////public string Ship_to_Country_Region_Code { get; set; }
		////public string Ship_to_Contact { get; set; }
		////public string Ship_to_UPS_Zone { get; set; }
		public string PayToOptions { get; set; }
		////public string Pay_to_Name { get; set; }
		////public string Pay_to_Address { get; set; }
		////public string Pay_to_Address_2 { get; set; }
		////public string Pay_to_County { get; set; }
		////public string Pay_to_Contact_No { get; set; }
		////public string Pay_to_Contact { get; set; }
		public string Transaction_Specification { get; set; }
		public string Transport_Method { get; set; }
		public string Entry_Point { get; set; }
		public string Area { get; set; }
		public decimal Prepayment_Percent { get; set; }
		public bool Compress_Prepayment { get; set; }
		public string Prepmt_Payment_Terms_Code { get; set; }
		public string Prepayment_Due_Date { get; set; }
		public decimal Prepmt_Payment_Discount_Percent { get; set; }
		public string Prepmt_Pmt_Discount_Date { get; set; }
		public string Vendor_Cr_Memo_No { get; set; }
		public bool Prepmt_Include_Tax { get; set; }
		public string Fiscal_Invoice_Number_PAC { get; set; }
		public bool E_Mail_Confirmation_Handled { get; set; }
	}
}
