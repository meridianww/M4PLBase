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
// Purpose:                                      Contains objects related to NavSalesOrder
//==========================================================================================================

using Newtonsoft.Json;

namespace M4PL.Entities.Finance.SalesOrder
{
	public class NavSalesOrder
	{
		/// <summary>
		/// Gets or Sets Data E Tag
		/// </summary>
		[JsonProperty("@odata.etag")]
		public string DataETag { get; set; }
		/// <summary>
		/// Gets or Sets Document Type
		/// </summary>
		public string Document_Type { get; set; }
		/// <summary>
		/// Gets or Sets NAV Sales Order Number
		/// </summary>
		public string No { get; set; }
		/// <summary>
		/// Gets or Sets Sell to Customer No
		/// </summary>
		public string Sell_to_Customer_No { get; set; }
		/// <summary>
		/// Gets or Sets Sell to customer Name
		/// </summary>
		public string Sell_to_Customer_Name { get; set; }
		/// <summary>
		/// Gets or Sets Quote Number
		/// </summary>
		public string Quote_No { get; set; }
		/// <summary>
		/// Gets or Sets Sell To Address
		/// </summary>
		public string Sell_to_Address { get; set; }
		/// <summary>
		/// Gets or Sets Sell To Address
		/// </summary>
		public string Sell_to_Address_2 { get; set; }
		/// <summary>
		/// Gets or Sets Sell To City
		/// </summary>
		public string Sell_to_City { get; set; }
		/// <summary>
		/// Gets or Sets Sell To Country
		/// </summary>
		public string Sell_to_County { get; set; }
		/// <summary>
		/// Gets or Sets Sell To Zip Code
		/// </summary>
		public string Sell_to_Post_Code { get; set; }
		/// <summary>
		/// Gets or Sets Sell To Sell to Contact Number
		/// </summary>
		public string Sell_to_Contact_No { get; set; }

		////public string Sell_to_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Number of Archived Versions
		/// </summary>
		public int No_of_Archived_Versions { get; set; }
		/// <summary>
		/// Gets or Sets Document Date
		/// </summary>
		public string Document_Date { get; set; }
		/// <summary>
		/// Gets or Sets Posting Date
		/// </summary>
		public string Posting_Date { get; set; }
		/// <summary>
		/// Gets or Sets NAV Order Date
		/// </summary>
		public string Order_Date { get; set; }
		/// <summary>
		/// Gets or Sets NAV Due Date
		/// </summary>
		public string Due_Date { get; set; }
		/// <summary>
		/// Gets or Sets NAV Received Date
		/// </summary>
		public string Received_Date { get; set; }
		/// <summary>
		/// Gets or Sets NAV Delivery Date
		/// </summary>
		public string Delivery_Date { get; set; }
		/// <summary>
		/// Gets or Sets Exyernal Document Number
		/// </summary>
		public string External_Document_No { get; set; }
		/// <summary>
		/// Gets or Sets Sales Person Code
		/// </summary>
		public string Salesperson_Code { get; set; }
		/// <summary>
		/// Gets or Sets Customer reference number
		/// </summary>
		public string Cust_Reference_No { get; set; }
		/// <summary>
		/// Gets or Sets Campaign No
		/// </summary>
		public string Campaign_No { get; set; }
		/// <summary>
		/// Gets or Sets Opportunity Number
		/// </summary>
		public string Opportunity_No { get; set; }
		/// <summary>
		/// Gets or Sets NAV Responsibility Center
		/// </summary>
		public string Responsibility_Center { get; set; }
		/// <summary>
		/// Gets or Sets Assigned User ID
		/// </summary>
		public string Assigned_User_ID { get; set; }
		/// <summary>
		/// Gets or Sets Job Queue Status
		/// </summary>
		public string Job_Queue_Status { get; set; }
		/// <summary>
		/// Gets or Sets NAV Order status
		/// </summary>
		public string Status { get; set; }
		/// <summary>
		/// Gets or Sets M4PL Job ID
		/// </summary>
		public string M4PL_Job_ID { get; set; }
		/// <summary>
		/// Gets or Sets FSC Calculated
		/// </summary>
		public bool FSC_Calculated { get; set; }
		/// <summary>
		/// Gets or Sets WorkDescription
		/// </summary>
		public string WorkDescription { get; set; }
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
		/// Gets or Sets Ship to Contact
		/// </summary>
		public string Ship_to_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Ship to UPS Zone
		/// </summary>
		public string Ship_to_UPS_Zone { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Phone
		/// </summary>
		public string Ship_to_Phone { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Mobile
		/// </summary>
		public string Ship_to_Mobile { get; set; }
		/// <summary>
		/// Gets or Sets Ship to Email
		/// </summary>
		public string Ship_to_Email { get; set; }
		/// <summary>
		/// Gets or Sets Currency Code
		/// </summary>
		public string Currency_Code { get; set; }
		/// <summary>
		/// Gets or Sets Payment Terms Code
		/// </summary>
		public string Payment_Terms_Code { get; set; }
		/// <summary>
		/// Gets or Sets Payment Method Code
		/// </summary>
		public string Payment_Method_Code { get; set; }
		/// <summary>
		/// Gets or Sets Tax Liable
		/// </summary>
		public bool Tax_Liable { get; set; }
		/// <summary>
		/// Gets or Sets Tax Area Code
		/// </summary>
		public string Tax_Area_Code { get; set; }
		/// <summary>
		/// Gets or Sets SelectedPayments
		/// </summary>
		public string SelectedPayments { get; set; }
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
		/// Gets or Sets Direct Debit Mandate ID
		/// </summary>
		public string Direct_Debit_Mandate_ID { get; set; }
		/// <summary>
		/// Gets or Sets ShippingOptions
		/// </summary>
		public string ShippingOptions { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Method Code
		/// </summary>
		public string Shipment_Method_Code { get; set; }
		/// <summary>
		/// Gets or Sets Shipping Agent Code
		/// </summary>
		public string Shipping_Agent_Code { get; set; }
		/// <summary>
		/// Gets or Sets Shipping Agent Service Code
		/// </summary>
		public string Shipping_Agent_Service_Code { get; set; }
		/// <summary>
		/// Gets or Sets Package Tracking No
		/// </summary>
		public string Package_Tracking_No { get; set; }
		/// <summary>
		/// Gets or Sets BillToOptions
		/// </summary>
		public string BillToOptions { get; set; }
		/// <summary>
		/// Gets or Sets Bill to Name
		/// </summary>
		public string Bill_to_Name { get; set; }

		////public string Bill_to_Address { get; set; }
		/// <summary>
		/// Gets or Sets Bill to Address 2
		/// </summary>
		public string Bill_to_Address_2 { get; set; }

		////public string Bill_to_City { get; set; }
		////public string Bill_to_County { get; set; }
		////public string Bill_to_Post_Code { get; set; }
		/// <summary>
		/// Gets or Sets Bill to Contact No
		/// </summary>
		public string Bill_to_Contact_No { get; set; }

		////public string Bill_to_Contact { get; set; }
		/// <summary>
		/// Gets or Sets Location Code
		/// </summary>
		public string Location_Code { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Date
		/// </summary>
		public string Shipment_Date { get; set; }
		/// <summary>
		/// Gets or Sets Shipping Advice
		/// </summary>
		public string Shipping_Advice { get; set; }
		/// <summary>
		/// Gets or Sets Outbound Whse Handling Time
		/// </summary>
		public string Outbound_Whse_Handling_Time { get; set; }
		/// <summary>
		/// Gets or Sets Shipping Time
		/// </summary>
		public string Shipping_Time { get; set; }
		/// <summary>
		/// Gets or Sets Late Order Shipping
		/// </summary>
		public bool Late_Order_Shipping { get; set; }
		/// <summary>
		/// Gets or Sets Transaction Specification
		/// </summary>
		public string Transaction_Specification { get; set; }
		/// <summary>
		/// Gets or Sets Transport Method
		/// </summary>
		public string Transport_Method { get; set; }
		/// <summary>
		/// Gets or Sets Exit Point
		/// </summary>
		public string Exit_Point { get; set; }
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
		/// Gets or Sets Prepmt Include Tax
		/// </summary>
		public bool Prepmt_Include_Tax { get; set; }
		/// <summary>
		/// Gets or Sets EDI Order
		/// </summary>
		public bool EDI_Order { get; set; }
		/// <summary>
		/// Gets or Sets EDI Internal Doc No
		/// </summary>
		public string EDI_Internal_Doc_No { get; set; }
		/// <summary>
		/// Gets or Sets EDI Ack Generated
		/// </summary>
		public bool EDI_Ack_Generated { get; set; }
		/// <summary>
		/// Gets or Sets EDI Ack Gen Date
		/// </summary>
		public string EDI_Ack_Gen_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Released
		/// </summary>
		public bool EDI_Released { get; set; }
		/// <summary>
		/// Gets or Sets EDI WHSE Shp Gen
		/// </summary>
		public bool EDI_WHSE_Shp_Gen { get; set; }
		/// <summary>
		/// Gets or Sets EDI WHSE Shp Gen Date
		/// </summary>
		public string EDI_WHSE_Shp_Gen_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Transaction Date
		/// </summary>
		public string EDI_Transaction_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Transaction Time
		/// </summary>
		public string EDI_Transaction_Time { get; set; }
		/// <summary>
		/// Gets or Sets EDI Expected Delivery Date
		/// </summary>
		public string EDI_Expected_Delivery_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Trade Partner
		/// </summary>
		public string EDI_Trade_Partner { get; set; }
		/// <summary>
		/// Gets or Sets EDI Sell to Code
		/// </summary>
		public string EDI_Sell_to_Code { get; set; }
		/// <summary>
		/// Gets or Sets EDI Ship for Code
		/// </summary>
		public string EDI_Ship_for_Code { get; set; }
		/// <summary>
		/// Gets or Sets EDI Ship to Code
		/// </summary>
		public string EDI_Ship_to_Code { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancel After Date
		/// </summary>
		public string EDI_Cancel_After_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancellation Request
		/// </summary>
		public bool EDI_Cancellation_Request { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancellation Date
		/// </summary>
		public string EDI_Cancellation_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancellation Advice
		/// </summary>
		public bool EDI_Cancellation_Advice { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancellation Advice Date
		/// </summary>
		public string EDI_Cancellation_Advice_Date { get; set; }
		/// <summary>
		/// Gets or Sets EDI Cancellation Generated
		/// </summary>
		public bool EDI_Cancellation_Generated { get; set; }
		/// <summary>
		/// Gets or Sets Mileage
		/// </summary>
		public decimal Mileage { get; set; }
		/// <summary>
		/// Gets or Sets Storage
		/// </summary>
		public decimal Storage { get; set; }
		/// <summary>
		/// Gets or Sets VendorNo
		/// </summary>
		public string VendorNo { get; set; }
		/// <summary>
		/// Gets or Sets Electronic Invoice
		/// </summary>
		public bool Electronic_Invoice { get; set; }
		/// <summary>
		/// Gets or Sets ManualSalesOrderNo
		/// </summary>
		public string ManualSalesOrderNo { get; set; }
		/// <summary>
		/// Gets or Sets ElectronicSalesOrderNo
		/// </summary>
		public string ElectronicSalesOrderNo { get; set; }
		/// <summary>
		/// Gets or Sets ManualPurchaseOrderNo
		/// </summary>
		public string ManualPurchaseOrderNo { get; set; }
		/// <summary>
		/// Gets or Sets ElectronicPurchaseOrderNo
		/// </summary>
		public string ElectronicPurchaseOrderNo { get; set; }
		/// <summary>
		/// Gets or Sets Parent ID
		/// </summary>
		public string Parent_ID { get; set; }

	}
}