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
	public class NavPurchaseOrder
	{
		public string No { get; set; }
		public string Buy_from_Vendor_No { get; set; }
		public string Buy_from_Vendor_Name { get; set; }
		public string M4PL_Job_ID { get; set; }
		public string Buy_from_Address { get; set; }
		public string Buy_from_Address_2 { get; set; }
		public string Buy_from_City { get; set; }
		public string Buy_from_County { get; set; }
		public string Buy_from_Post_Code { get; set; }
		public string Buy_from_Contact_No { get; set; }
		public string Buy_from_Contact { get; set; }
		public string Document_Date { get; set; }
		public bool Document_DateSpecified { get; set; }
		public string Posting_Date { get; set; }
		public bool Posting_DateSpecified { get; set; }
		public string Due_Date { get; set; }
		public bool Due_DateSpecified { get; set; }
		public string Vendor_Invoice_No { get; set; }
		public string Purchaser_Code { get; set; }
		public int No_of_Archived_Versions { get; set; }
		public bool No_of_Archived_VersionsSpecified { get; set; }
		public string Posting_Description { get; set; }
		public string Order_Date { get; set; }
		public bool Order_DateSpecified { get; set; }
		public string Quote_No { get; set; }
		public string Vendor_Order_No { get; set; }
		public string Vendor_Shipment_No { get; set; }
		public string Order_Address_Code { get; set; }
		public string Responsibility_Center { get; set; }
		public string Assigned_User_ID { get; set; }
		public OrderStatus Status { get; set; }
		public bool StatusSpecified { get; set; }
		public Job_Queue_Status Job_Queue_Status { get; set; }
		public bool Job_Queue_StatusSpecified { get; set; }
		public bool FSC_Calculated { get; set; }
		public bool FSC_CalculatedSpecified { get; set; }
		public string Currency_Code { get; set; }
		public string Expected_Receipt_Date { get; set; }
		public bool Expected_Receipt_DateSpecified { get; set; }
		public string Payment_Terms_Code { get; set; }
		public string Transaction_Type { get; set; }
		public string Shortcut_Dimension_1_Code { get; set; }
		public string Shortcut_Dimension_2_Code { get; set; }
		public decimal Payment_Discount_Percent { get; set; }
		public bool Payment_Discount_PercentSpecified { get; set; }
		public string Pmt_Discount_Date { get; set; }
		bool Pmt_Discount_DateSpecified { get; set; }
		public bool Tax_Liable { get; set; }
		public bool Tax_LiableSpecified { get; set; }
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
		public bool Requested_Receipt_DateSpecified { get; set; }
		public string Promised_Receipt_Date { get; set; }
		public bool Promised_Receipt_DateSpecified { get; set; }
		public string IRS_1099_Code { get; set; }
		public string Location_Code { get; set; }
		public string Sell_to_Customer_No { get; set; }
		public string Ship_to_Code { get; set; }
		public string Ship_to_Name { get; set; }
		public string Ship_to_Address { get; set; }
		public string Ship_to_Address_2 { get; set; }
		public string Ship_to_City { get; set; }
		public string Ship_to_County { get; set; }
		public string Ship_to_Post_Code { get; set; }
		public string Ship_to_Country_Region_Code { get; set; }
		public string Ship_to_Contact { get; set; }
		public string Ship_to_UPS_Zone { get; set; }
		public string Pay_to_Name { get; set; }
		public string Pay_to_Address { get; set; }
		public string Pay_to_Address_2 { get; set; }
		public string Pay_to_City { get; set; }
		public string Pay_to_County { get; set; }
		public string Pay_to_Post_Code { get; set; }
		public string Pay_to_Contact_No { get; set; }
		public string Pay_to_Contact { get; set; }
		public string Transaction_Specification { get; set; }
		public string Transport_Method { get; set; }
		public string Entry_Point { get; set; }
		public string Area { get; set; }
		public decimal Prepayment_Percent { get; set; }
		public bool Prepayment_PercentSpecified { get; set; }
		public bool Compress_Prepayment { get; set; }
		public bool Compress_PrepaymentSpecified { get; set; }
		public string Prepmt_Payment_Terms_Code { get; set; }
		public string Prepayment_Due_Date { get; set; }
		public bool Prepayment_Due_DateSpecified { get; set; }
		public decimal Prepmt_Payment_Discount_Percent { get; set; }
		public string Prepmt_Pmt_Discount_Date { get; set; }
		public bool Prepmt_Payment_Discount_PercentSpecified { get; set; }
		public string Vendor_Cr_Memo_No { get; set; }
		public bool Prepmt_Include_Tax { get; set; }
		public bool Prepmt_Include_TaxSpecified { get; set; }
		public string Fiscal_Invoice_Number_PAC { get; set; }
		public bool EDI_Order { get; set; }
		public bool EDI_OrderSpecified { get; set; }
		public string EDI_Internal_Doc_No { get; set; }
		public bool EDI_PO_Generated { get; set; }
		public bool EDI_PO_GeneratedSpecified { get; set; }
		public string EDI_PO_Gen_Date { get; set; }
		public bool EDI_PO_Gen_DateSpecified { get; set; }
		public bool EDI_Released { get; set; }
		public bool EDI_ReleasedSpecified { get; set; }
		public bool EDI_Ship_Adv_Gen { get; set; }
		public bool EDI_Ship_Adv_GenSpecified { get; set; }
		public string EDI_Ship_Adv_Gen_Date { get; set; }
		public bool EDI_Ship_Adv_Gen_DateSpecified { get; set; }
		public bool E_Mail_Confirmation_Handled { get; set; }
		public bool E_Mail_Confirmation_HandledSpecified { get; set; }
		public string EDI_Trade_Partner { get; set; }
		public string EDI_Buy_from_Code { get; set; }
		public PurchaseOrderItem[] PurchLines { get; set; }
	}
}
