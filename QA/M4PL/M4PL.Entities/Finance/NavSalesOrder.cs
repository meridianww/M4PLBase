/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrder
Purpose:                                      Contains objects related to NavSalesOrder
==========================================================================================================*/

using System;

namespace M4PL.Entities.Finance
{
	public class NavSalesOrder
	{
		public string No { get; set; }
		public string Sell_to_Customer_No { get; set; }
		public string Sell_to_Customer_Name { get; set; }
		public string Quote_No { get; set; }
		public string Sell_to_Address { get; set; }
		public string Sell_to_Address_2 { get; set; }
		public string Sell_to_City { get; set; }
		public string Sell_to_County { get; set; }
		public string Sell_to_Post_Code { get; set; }
		public string Sell_to_Contact_No { get; set; }
		public string Sell_to_Contact { get; set; }
		public int No_of_Archived_Versions { get; set; }
		public bool No_of_Archived_VersionsSpecified { get; set; }
		public string Document_Date { get; set; }
		public bool Document_DateSpecified { get; set; }
		public string Posting_Date { get; set; }
		public bool Posting_DateSpecified { get; set; }
		public string Order_Date { get; set; }
		public bool Order_DateSpecified { get; set; }
		public string Due_Date { get; set; }
		public bool Due_DateSpecified { get; set; }
		public string Requested_Delivery_Date { get; set; }
		public bool Requested_Delivery_DateSpecified { get; set; }
		public string Promised_Delivery_Date { get; set; }
		public bool Promised_Delivery_DateSpecified { get; set; }
		public string External_Document_No { get; set; }
		public string Salesperson_Code { get; set; }
		public string Cust_Reference_No { get; set; }
		public string Campaign_No { get; set; }
		public string Opportunity_No { get; set; }
		public string Responsibility_Center { get; set; }
		public string Assigned_User_ID { get; set; }
		public Job_Queue_Status Job_Queue_Status { get; set; }
		public bool Job_Queue_StatusSpecified { get; set; }
		public OrderStatus Status { get; set; }
		public bool StatusSpecified { get; set; }
		public string M4PL_Job_ID { get; set; }
		public bool FSC_Calculated { get; set; }
		public bool FSC_CalculatedSpecified { get; set; }
		public string WorkDescription { get; set; }
		public string Ship_from_Code { get; set; }
		public string Ship_from_Name { get; set; }
		public string Ship_from_Name_2 { get; set; }
		public string Ship_from_Address { get; set; }
		public string Ship_from_Address_2 { get; set; }
		public string Ship_from_City { get; set; }
		public string Ship_From_County { get; set; }
		public string Ship_From_Post_Code { get; set; }
		public string Ship_from_Contact { get; set; }
		public string Ship_from_Phone { get; set; }
		public string Ship_from_Mobile { get; set; }
		public string Ship_from_Email { get; set; }
		public string Ship_to_Code { get; set; }
		public string Ship_to_Name { get; set; }
		public string Ship_to_Address { get; set; }
		public string Ship_to_Address_2 { get; set; }
		public string Ship_to_City { get; set; }
		public string Ship_to_County { get; set; }
		public string Ship_to_Post_Code { get; set; }
		public string Ship_to_Contact { get; set; }
		public string Ship_to_UPS_Zone { get; set; }
		public string Ship_to_Phone { get; set; }
		public string Ship_to_Mobile { get; set; }
		public string Ship_to_Email { get; set; }
		public string Currency_Code { get; set; }
		public string Payment_Terms_Code { get; set; }
		public string Payment_Method_Code { get; set; }
		public bool Tax_Liable { get; set; }
		public bool Tax_LiableSpecified { get; set; }
		public string Tax_Area_Code { get; set; }
		public string SelectedPayments { get; set; }
		public string Transaction_Type { get; set; }
		public string Shortcut_Dimension_1_Code { get; set; }
		public string Shortcut_Dimension_2_Code { get; set; }
		public decimal Payment_Discount_Percent { get; set; }
		public bool Payment_Discount_PercentSpecified { get; set; }
		public string Pmt_Discount_Date { get; set; }
		public bool Pmt_Discount_DateSpecified { get; set; }
		public string Direct_Debit_Mandate_ID { get; set; }
		public string Shipment_Method_Code { get; set; }
		public string Shipping_Agent_Code { get; set; }
		public string Shipping_Agent_Service_Code { get; set; }
		public string Package_Tracking_No { get; set; }
		public string Bill_to_Name { get; set; }
		public string Bill_to_Address { get; set; }
		public string Bill_to_Address_2 { get; set; }
		public string Bill_to_City { get; set; }
		public string Bill_to_County { get; set; }
		public string Bill_to_Post_Code { get; set; }
		public string Bill_to_Contact_No { get; set; }
		public string Bill_to_Contact { get; set; }
		public string Location_Code { get; set; }
		public string Shipment_Date { get; set; }
		public bool Shipment_DateSpecified { get; set; }
		public ShippingAdvice Shipping_Advice { get; set; }
		public bool Shipping_AdviceSpecified { get; set; }
		public string Outbound_Whse_Handling_Time { get; set; }
		public string Shipping_Time { get; set; }
		public bool Late_Order_Shipping { get; set; }
		public bool Late_Order_ShippingSpecified { get; set; }
		public string Transaction_Specification { get; set; }
		public string Transport_Method { get; set; }
		public string Exit_Point { get; set; }
		public string Area { get; set; }
		public decimal Prepayment_Percent { get; set; }
		public bool Prepayment_PercentSpecified { get; set; }
		public bool Compress_Prepayment { get; set; }
		public bool Compress_PrepaymentSpecified { get; set; }
		public string Prepmt_Payment_Terms_Code { get; set; }
		public string Prepayment_Due_Date { get; set; }
		public bool Prepayment_Due_DateSpecified { get; set; }
		public decimal Prepmt_Payment_Discount_Percent { get; set; }
		public bool Prepmt_Payment_Discount_PercentSpecified { get; set; }
		public string Prepmt_Pmt_Discount_Date { get; set; }
		public bool Prepmt_Pmt_Discount_DateSpecified { get; set; }
		public bool Prepmt_Include_Tax { get; set; }
		public bool Prepmt_Include_TaxSpecified { get; set; }
		public bool EDI_Order { get; set; }
		public bool EDI_OrderSpecified { get; set; }
		public string EDI_Internal_Doc_No { get; set; }
		public bool EDI_Ack_Generated { get; set; }
		public bool EDI_Ack_GeneratedSpecified { get; set; }
		public string EDI_Ack_Gen_Date { get; set; }
		public bool EDI_Ack_Gen_DateSpecified { get; set; }
		public bool EDI_Released { get; set; }
		public bool EDI_ReleasedSpecified { get; set; }
		public bool EDI_WHSE_Shp_Gen { get; set; }
		public bool EDI_WHSE_Shp_GenSpecified { get; set; }
		public string EDI_WHSE_Shp_Gen_Date { get; set; }
		public bool EDI_WHSE_Shp_Gen_DateSpecified { get; set; }
		public string EDI_Transaction_Date { get; set; }
		public bool EDI_Transaction_DateSpecified { get; set; }
		public string EDI_Transaction_Time { get; set; }
		public bool EDI_Transaction_TimeSpecified { get; set; }
		public string EDI_Expected_Delivery_Date { get; set; }
		public bool EDI_Expected_Delivery_DateSpecified { get; set; }
		public string EDI_Trade_Partner { get; set; }
		public string EDI_Sell_to_Code { get; set; }
		public string EDI_Ship_for_Code { get; set; }
		public string EDI_Ship_to_Code { get; set; }
		public string EDI_Cancel_After_Date { get; set; }
		public bool EDI_Cancel_After_DateSpecified { get; set; }
		public bool EDI_Cancellation_Request { get; set; }
		public bool EDI_Cancellation_RequestSpecified { get; set; }
		public string EDI_Cancellation_Date { get; set; }
		public bool EDI_Cancellation_DateSpecified { get; set; }
		public bool EDI_Cancellation_Advice { get; set; }
		public bool EDI_Cancellation_AdviceSpecified { get; set; }
		public string EDI_Cancellation_Advice_Date { get; set; }
		public bool EDI_Cancellation_Advice_DateSpecified { get; set; }
		public bool EDI_Cancellation_Generated { get; set; }
		public bool EDI_Cancellation_GeneratedSpecified { get; set; }
		public NavSalesOrderItem[] SalesLines { get; set; }
		public NavEShipSalesOrderPart[] EShip_Sales_Order_Part { get; set; }

	}
}
