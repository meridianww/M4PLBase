/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/03/2019
Program Name:                                 NavSalesOrder
Purpose:                                      Contains objects related to NavEShipSalesOrderPart
==========================================================================================================*/

namespace M4PL.Entities.Finance
{
	public class NavEShipSalesOrderPart
	{
		public string Key { get; set; }
		public string Shipping_Agent_Code { get; set; }
		public string E_Ship_Agent_Service { get; set; }
		public bool Residential_Delivery { get; set; }
		public bool Residential_DeliverySpecified { get; set; }
		public bool Blind_Shipment { get; set; }
		public bool Blind_ShipmentSpecified { get; set; }
		public bool Double_Blind_Shipment { get; set; }
		public bool Double_Blind_ShipmentSpecified { get; set; }
		public string Double_Blind_Ship_from_Cust_No { get; set; }
		public string Ship_for_Code { get; set; }
		public string EShipValidation_SalesHeader_PackingStatus_Rec { get; set; }
		public Shipping_Payment_Type Shipping_Payment_Type { get; set; }
		public bool Shipping_Payment_TypeSpecified { get; set; }
		public string Third_Party_Ship_Account_No { get; set; }
		public Shipping_Insurance Shipping_Insurance { get; set; }
		public bool Shipping_InsuranceSpecified { get; set; }
		public bool Free_Freight { get; set; }
		public bool Free_FreightSpecified { get; set; }
		public bool E_Mail_Confirmation_Handled { get; set; }
		public bool E_Mail_Confirmation_HandledSpecified { get; set; }
		public string Invoice_for_Bill_of_Lading_No { get; set; }
		public string Invoice_for_Shipment_No { get; set; }
		public bool Shipment_Invoice_Override { get; set; }
		public bool Shipment_Invoice_OverrideSpecified { get; set; }
	}
}
