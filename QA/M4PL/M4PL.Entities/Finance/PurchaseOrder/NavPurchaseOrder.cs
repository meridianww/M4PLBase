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
// Purpose:                                      Contains objects related to NavPurchaseOrder
//==========================================================================================================

using Newtonsoft.Json;

namespace M4PL.Entities.Finance.PurchaseOrder
{
	/// <summary>
	/// Model Class for Nav purchase Order
	/// </summary>
	public class NavPurchaseOrder
	{
		/// <summary>
		/// Gets or Sets Data ETag
		/// </summary>
		[JsonProperty("@odata.etag")]
		public string DataETag { get; set; }

		/// <summary>
		/// Gets or Sets Document Type
		/// </summary>
		public string Document_Type { get; set; }
		/// <summary>
		/// Gets or Sets No
		/// </summary>
		public string No { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Vendor No
		/// </summary>
		public string Buy_from_Vendor_No { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Vendor Name
		/// </summary>
		public string Buy_from_Vendor_Name { get; set; }
		/// <summary>
		/// Gets or Sets M4PL Job ID
		/// </summary>
		public string M4PL_Job_ID { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Code
		/// </summary>
		public string Ship_from_Code { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Name
		/// </summary>
		public string Ship_from_Name { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Name 2
		/// </summary>
		public string Ship_from_Name_2 { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Address
		/// </summary>
		public string Ship_from_Address { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Address 2
		/// </summary>
		public string Ship_from_Address_2 { get; set; }
		/// <summary>
		/// Gets or Sets Ship from City
		/// </summary>
		public string Ship_from_City { get; set; }
		/// <summary>
		/// Gets or Sets Ship from County
		/// </summary>
		public string Ship_from_County { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Post Code
		/// </summary>
		public string Ship_from_Post_Code { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Contact
		/// </summary>
		public string Ship_from_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Phone
		/// </summary>
		public string Ship_from_Phone { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Mobile
		/// </summary>
		public string Ship_from_Mobile { get; set; }
		/// <summary>
		/// Gets or Sets Ship from Email
		/// </summary>
		public string Ship_from_Email { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Address
		/// </summary>
		public string Buy_from_Address { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Address 2
		/// </summary>
		public string Buy_from_Address_2 { get; set; }
		/// <summary>
		/// Gets or Sets Buy from City
		/// </summary>
		public string Buy_from_City { get; set; }
		/// <summary>
		/// Gets or Sets Buy from County
		/// </summary>
		public string Buy_from_County { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Post Code
		/// </summary>
		public string Buy_from_Post_Code { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Contact No
		/// </summary>
		public string Buy_from_Contact_No { get; set; }
		/// <summary>
		/// Gets or Sets Buy from Contact
		/// </summary>
		public string Buy_from_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Document Date
		/// </summary>
		public string Document_Date { get; set; }
		/// <summary>
		/// Gets or Sets Posting Date
		/// </summary>
		public string Posting_Date { get; set; }
		/// <summary>
		/// Gets or Sets Due Date
		/// </summary>
		public string Due_Date { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Date
		/// </summary>
		public string Shipment_Date { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Invoice No
		/// </summary>
		public string Vendor_Invoice_No { get; set; }
		/// <summary>
		/// Gets or Sets External Document No
		/// </summary>
		public string External_Document_No { get; set; }
		/// <summary>
		/// Gets or Sets Purchaser Code
		/// </summary>
		public string Purchaser_Code { get; set; }
		/// <summary>
		/// Gets or Sets No of Archived Versions
		/// </summary>
		public int No_of_Archived_Versions { get; set; }
		/// <summary>
		/// Gets or Sets Posting Description
		/// </summary>
		public string Posting_Description { get; set; }
		/// <summary>
		/// Gets or Sets Order Date
		/// </summary>
		public string Order_Date { get; set; }
		/// <summary>
		/// Gets or Sets Quote No
		/// </summary>
		public string Quote_No { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Order No
		/// </summary>
		public string Vendor_Order_No { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Shipment No
		/// </summary>
		public string Vendor_Shipment_No { get; set; }
		/// <summary>
		/// Gets or Sets Order Address Code
		/// </summary>
		public string Order_Address_Code { get; set; }
		/// <summary>
		/// Gets or Sets Responsibility Center
		/// </summary>
		public string Responsibility_Center { get; set; }
		/// <summary>
		/// Gets or Sets Assigned User ID
		/// </summary>
		public string Assigned_User_ID { get; set; }
		/// <summary>
		/// Gets or Sets Status
		/// </summary>
		public string Status { get; set; }
		/// <summary>
		/// Gets or Sets Job Queue Status
		/// </summary>
		public string Job_Queue_Status { get; set; }
		/// <summary>
		/// Gets or Sets Currency Code
		/// </summary>
		public string Currency_Code { get; set; }
		/// <summary>
		/// Gets or Sets Received Date
		/// </summary>
		public string Received_Date { get; set; }
		/// <summary>
		/// Gets or Sets Payment Terms Code
		/// </summary>
		public string Payment_Terms_Code { get; set; }
		/// <summary>
		/// Gets or Sets Transaction Type
		/// </summary>
		public string Transaction_Type { get; set; }
		/// <summary>
		/// Gets or Sets Shortcut Dimension 1 Code
		/// </summary>
		public string Shortcut_Dimension_1_Code { get; set; }
		/// <summary>
		/// Gets or Sets Shortcut Dimension 2 Code
		/// </summary>
		public string Shortcut_Dimension_2_Code { get; set; }
		/// <summary>
		/// Gets or Sets Payment Discount Percent
		/// </summary>
		public decimal Payment_Discount_Percent { get; set; }
		/// <summary>
		/// Gets or Sets Pmt Discount Date
		/// </summary>
		public string Pmt_Discount_Date { get; set; }
		/// <summary>
		/// Gets or Sets Tax Liable
		/// </summary>
		public string Tax_Liable { get; set; }
		/// <summary>
		/// Gets or Sets Tax Area Code
		/// </summary>
		public string Tax_Area_Code { get; set; }
		/// <summary>
		/// Gets or Sets Tax Exemption No
		/// </summary>
		public string Tax_Exemption_No { get; set; }
		/// <summary>
		/// Gets or Sets Provincial Tax Area Code
		/// </summary>
		public string Provincial_Tax_Area_Code { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Method Code
		/// </summary>
		public string Shipment_Method_Code { get; set; }
		/// <summary>
		/// Gets or Sets Payment Reference
		/// </summary>
		public string Payment_Reference { get; set; }
		/// <summary>
		/// Gets or Sets Creditor No
		/// </summary>
		public string Creditor_No { get; set; }
		/// <summary>
		/// Gets or Sets On Hold
		/// </summary>
		public string On_Hold { get; set; }
		/// <summary>
		/// Gets or Sets Inbound Whse Handling Time
		/// </summary>
		public string Inbound_Whse_Handling_Time { get; set; }
		/// <summary>
		/// Gets or Sets Lead Time Calculation
		/// </summary>
		public string Lead_Time_Calculation { get; set; }
		/// <summary>
		/// Gets or Sets Delivery Date
		/// </summary>
		public string Delivery_Date { get; set; }
		/// <summary>
		/// Gets or Sets Promised Receipt Date
		/// </summary>
		public string Promised_Receipt_Date { get; set; }
		/// <summary>
		/// Gets or Sets IRS 1099 Code
		/// </summary>
		public string IRS_1099_Code { get; set; }
		/// <summary>
		/// Gets or Sets ShippingOptionWithLocation
		/// </summary>
		public string ShippingOptionWithLocation { get; set; }
		/// <summary>
		/// Gets or Sets Location Code
		/// </summary>
		public string Location_Code { get; set; }
		/// <summary>
		/// Gets or Sets Sell to Customer No
		/// </summary>
		public string Sell_to_Customer_No { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Code
		/// </summary>
		public string Ship_to_Code { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Name
		/// </summary>
		public string Ship_to_Name { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Address
		/// </summary>
		public string Ship_to_Address { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Address 2
		/// </summary>
		public string Ship_to_Address_2 { get; set; }
		/// <summary>
		/// Gets or Sets Ship to City
		/// </summary>
		public string Ship_to_City { get; set; }
		/// <summary>
		/// Gets or Sets Ship to County
		/// </summary>
		public string Ship_to_County { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Post Code
		/// </summary>
		public string Ship_to_Post_Code { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Country Region Code
		/// </summary>
		public string Ship_to_Country_Region_Code { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Contact
		/// </summary>
		public string Ship_to_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Ship to UPS Zone
		/// </summary>
		public string Ship_to_UPS_Zone { get; set; }
		/// <summary>
		/// Gets or Sets PayToOptions
		/// </summary>
		public string PayToOptions { get; set; }
		/// <summary>
		/// Gets or Sets Pay to Name
		/// </summary>
		public string Pay_to_Name { get; set; }
		/// <summary>
		/// Gets or Sets Pay to Address
		/// </summary>
		public string Pay_to_Address { get; set; }
		/// <summary>
		/// Gets or Sets Pay to Address 2
		/// </summary>
		public string Pay_to_Address_2 { get; set; }
		/// <summary>
		/// Gets or Sets Pay to County
		/// </summary>
		public string Pay_to_County { get; set; }
		/// <summary>
		/// Gets or Sets Pay to Contact No
		/// </summary>
		public string Pay_to_Contact_No { get; set; }
		/// <summary>
		/// Gets or Sets Pay to Contact
		/// </summary>
		public string Pay_to_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Transaction Specification
		/// </summary>
		public string Transaction_Specification { get; set; }
		/// <summary>
		/// Gets or Sets Transport Method
		/// </summary>
		public string Transport_Method { get; set; }
		/// <summary>
		/// Gets or Sets Entry Point
		/// </summary>
		public string Entry_Point { get; set; }
		/// <summary>
		/// Gets or Sets Area
		/// </summary>
		public string Area { get; set; }
		/// <summary>
		/// Gets or Sets Prepayment Percent
		/// </summary>
		public decimal Prepayment_Percent { get; set; }
		/// <summary>
		/// Gets or Sets Compress Prepayment
		/// </summary>
		public bool Compress_Prepayment { get; set; }
		/// <summary>
		/// Gets or Sets Prepmt Payment Terms Code
		/// </summary>
		public string Prepmt_Payment_Terms_Code { get; set; }
		/// <summary>
		/// Gets or Sets Prepayment Due Date
		/// </summary>
		public string Prepayment_Due_Date { get; set; }
		/// <summary>
		/// Gets or Sets Prepmt Payment Discount Percent
		/// </summary>
		public decimal Prepmt_Payment_Discount_Percent { get; set; }
		/// <summary>
		/// Gets or Sets Prepmt Pmt Discount Date
		/// </summary>
		public string Prepmt_Pmt_Discount_Date { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Cr Memo No
		/// </summary>
		public string Vendor_Cr_Memo_No { get; set; }
		/// <summary>
		/// Gets or Sets Prepmt Include Tax
		/// </summary>
		public bool Prepmt_Include_Tax { get; set; }
		/// <summary>
		/// Gets or Sets Fiscal Invoice Number PAC
		/// </summary>
		public string Fiscal_Invoice_Number_PAC { get; set; }
		/// <summary>
		/// Gets or Sets E Mail Confirmation Handled
		/// </summary>
		public bool E_Mail_Confirmation_Handled { get; set; }
		/// <summary>
		/// Gets or Sets Mileage
		/// </summary>
		public decimal Mileage { get; set; }
		/// <summary>
		/// Gets or Sets Storage
		/// </summary>
		public decimal Storage { get; set; }
		/// <summary>
		/// Gets or Sets Electronic Invoice
		/// </summary>
		public bool Electronic_Invoice { get; set; }
		/// <summary>
		/// Gets or Sets Parent ID
		/// </summary>
		public string Parent_ID { get; set; }

	}
}