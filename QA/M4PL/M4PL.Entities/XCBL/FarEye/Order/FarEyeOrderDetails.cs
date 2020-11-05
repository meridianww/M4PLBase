#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL.FarEye.Order
{
	public class FarEyeOrderDetails
	{
		public string reference_id { get; set; }
		public string order_number { get; set; }
		public string tracking_number { get; set; }
		public string carrier_code { get; set; }
		public string shipper_code { get; set; }
		public string merchant_code { get; set; }
		public string type_of_order { get; set; }
		public string type_of_service { get; set; }
		public string type_of_action { get; set; }
		public string origin_title { get; set; }
		public string origin_code { get; set; }
		public string origin_name { get; set; }
		public string origin_address_line1 { get; set; }
		public string origin_address_line2 { get; set; }
		public string origin_landmark { get; set; }
		public string origin_city { get; set; }
		public string origin_state_province { get; set; }
		public string origin_country { get; set; }
		public string origin_postal_code { get; set; }
		public string origin_contact_number { get; set; }
		public string origin_contact_number2 { get; set; }
		public string origin_email { get; set; }
		public string origin_company_name { get; set; }
		public string origin_contact_name { get; set; }
		public string origin_latitude { get; set; }
		public string origin_longitude { get; set; }
		public string origin_preferred_start_time { get; set; }
		public string origin_preferred_end_time { get; set; }
		public string destination_title { get; set; }
		public string destination_code { get; set; }
		public string destination_name { get; set; }
		public string destination_address_line1 { get; set; }
		public string destination_address_line2 { get; set; }
		public string destination_landmark { get; set; }
		public string destination_city { get; set; }
		public string destination_state_province { get; set; }
		public string destination_country { get; set; }
		public string destination_postal_code { get; set; }
		public string destination_contact_number { get; set; }
		public string destination_contact_number2 { get; set; }
		public string destination_email { get; set; }
		public string destination_company_name { get; set; }
		public string destination_contact_name { get; set; }
		public string destination_preferred_start_time { get; set; }
		public string destination_preferred_end_time { get; set; }
		public string destination_latitude { get; set; }
		public string destination_longitude { get; set; }
		public string destination_lot_id { get; set; }
		public string return_title { get; set; }
		public string return_code { get; set; }
		public string return_name { get; set; }
		public string return_address_line1 { get; set; }
		public string return_address_line2 { get; set; }
		public string return_landmark { get; set; }
		public string return_city { get; set; }
		public string return_state_province { get; set; }
		public string return_country { get; set; }
		public string return_postal_code { get; set; }
		public string return_contact_number { get; set; }
		public string return_contact_number2 { get; set; }
		public string return_email { get; set; }
		public string return_preferred_start_time { get; set; }
		public string return_preferred_end_time { get; set; }
		public string return_latitude { get; set; }
		public string return_longitude { get; set; }
		public string deliver_to_title { get; set; }
		public string deliver_to_code { get; set; }
		public string deliver_to_name { get; set; }
		public string deliver_to_address_line1 { get; set; }
		public string deliver_to_address_line2 { get; set; }
		public string deliver_to_landmark { get; set; }
		public string deliver_to_city { get; set; }
		public string deliver_to_state_province { get; set; }
		public string deliver_to_country { get; set; }
		public string deliver_to_postal_code { get; set; }
		public string deliver_to_contact_number { get; set; }
		public string deliver_to_contact_number2 { get; set; }
		public string deliver_to_email { get; set; }
		public string deliver_to_company_name { get; set; }
		public string deliver_to_contact_name { get; set; }
		public string deliver_to_preferred_start_time { get; set; }
		public string deliver_to_preferred_end_time { get; set; }
		public string deliver_to_latitude { get; set; }
		public string deliver_to_longitude { get; set; }
		public string deliver_lot_id { get; set; }
		public string number_of_shipments { get; set; }
		public string total_weight { get; set; }
		public string uom_total_weight { get; set; }
		public string product_code { get; set; }
		public string product_type { get; set; }
		public string payment_mode { get; set; }
		public string invoice_value { get; set; }
		public string amount_to_be_collected { get; set; }
		public string currency_code { get; set; }
		public string custom_value { get; set; }
		public string shipping_date_time { get; set; }
		public string product_description { get; set; }
		public string delivery_instruction { get; set; }
		public List<FarEyeOrderDetailsItemList> item_list { get; set; }
		public List<FarEyeOrderDetailsSkuList> sku_list { get; set; }
		public FarEyeOrderDetailsInfo info { get; set; }
	}
	public class FarEyeOrderDetailsInfo
	{
		public string customer_po { get; set; }
		public string purchase_order_type { get; set; }
		public string consignee_po { get; set; }
		public string rma_indicator { get; set; }
		public string department_number { get; set; }
		public string freight_carrier_code { get; set; }
		public string hot_order { get; set; }
		public string bill_of_lading { get; set; }
		public string reserved_id { get; set; }
		public string transport_type { get; set; }
		public string transportType_description { get; set; }
		public string transport_id { get; set; }
		public string install_date { get; set; }
		public string good_issue_date { get; set; }
		public string loading_date { get; set; }
		public string transportation_planning_date { get; set; }
		public string outbound_delivery_date { get; set; }
		public string picking_date { get; set; }
		public string requested_delivery_date { get; set; }
	}
	public class FarEyeOrderDetailsItemList
	{
		public string item_reference_number { get; set; }
		public string item_name { get; set; }
		public string item_code { get; set; }
		public string item_material_type { get; set; }
		public string item_material_descritpion { get; set; }
		public string item_status { get; set; }
		public string item_length { get; set; }
		public string item_width { get; set; }
		public string item_height { get; set; }
		public string item_uom { get; set; }
		public string item_weight_uom { get; set; }
		public double item_weight { get; set; }
		public string item_value { get; set; }
		public int item_quantity { get; set; }
		public int item_delivery_service_time { get; set; }
		public string item_special_instruction { get; set; }
		public string harmonized_code { get; set; }
		public string item_volumn { get; set; }
		public string item_volumn_uom { get; set; }
		public string secondary_location { get; set; }
		public string customer_stock_number { get; set; }
		public string item_serial_number { get; set; }
		public string sap_material_id { get; set; }
		public string edc_material_id { get; set; }
		public string item_number_of_reference_item { get; set; }
		public string product_hierarchy { get; set; }
		public string product_hierarchy_description { get; set; }
		public string customer_po { get; set; }
		public string purchase_order_type { get; set; }
		public string cosignee_po { get; set; }
	}
	public class FarEyeOrderDetailsSkuList
	{
		public string item_reference_number { get; set; }
		public string sku_number { get; set; }
		public string sku_code { get; set; }
		public string sku_item_name { get; set; }
		public string sku_item_description { get; set; }
		public string sku_hsn_code { get; set; }
		public string sku_image_url { get; set; }
		public int sku_quantity { get; set; }
		public string sku_value { get; set; }
		public string sku_item_sequence { get; set; }
		public string sku_item_unit_price { get; set; }
	}
}
