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
	/// <summary>
	/// Model class for FarEye Order Details
	/// </summary>
	public class FarEyeOrderDetails
	{
		/// <summary>
		/// Gets or Sets reference id
		/// </summary>
		public string reference_id { get; set; }
		/// <summary>
		/// Gets or Sets order number
		/// </summary>
		public string order_number { get; set; }
		/// <summary>
		/// Gets or Sets tracking number
		/// </summary>
		public string tracking_number { get; set; }
		/// <summary>
		/// Gets or Sets carrier code
		/// </summary>
		public string carrier_code { get; set; }
		/// <summary>
		/// Gets or Sets shipper code
		/// </summary>
		public string shipper_code { get; set; }
		/// <summary>
		/// Gets or Sets merchant code
		/// </summary>
		public string merchant_code { get; set; }
		/// <summary>
		/// Gets or Sets type of order
		/// </summary>
		public string type_of_order { get; set; }
		/// <summary>
		/// Gets or Sets type of service
		/// </summary>
		public string type_of_service { get; set; }
		/// <summary>
		/// Gets or Sets type of action
		/// </summary>
		public string type_of_action { get; set; }
		/// <summary>
		/// Gets or Sets origin title
		/// </summary>
		public string origin_title { get; set; }
		/// <summary>
		/// Gets or Sets origin code
		/// </summary>
		public string origin_code { get; set; }
		/// <summary>
		/// Gets or Sets origin name
		/// </summary>
		public string origin_name { get; set; }
		/// <summary>
		/// Gets or Sets origin address line1
		/// </summary>
		public string origin_address_line1 { get; set; }
		/// <summary>
		/// Gets or Sets origin address line2
		/// </summary>
		public string origin_address_line2 { get; set; }
		/// <summary>
		/// Gets or Sets origin landmark
		/// </summary>
		public string origin_landmark { get; set; }
		/// <summary>
		/// Gets or Sets origin city
		/// </summary>
		public string origin_city { get; set; }
		/// <summary>
		/// Gets or Sets origin state province
		/// </summary>
		public string origin_state_province { get; set; }
		/// <summary>
		/// Gets or Sets origin country
		/// </summary>
		public string origin_country { get; set; }
		/// <summary>
		/// Gets or Sets origin postal code
		/// </summary>
		public string origin_postal_code { get; set; }
		/// <summary>
		/// Gets or Sets origin contact number
		/// </summary>
		public string origin_contact_number { get; set; }
		/// <summary>
		/// Gets or Sets origin contact number2
		/// </summary>
		public string origin_contact_number2 { get; set; }
		/// <summary>
		/// Gets or Sets origin email
		/// </summary>
		public string origin_email { get; set; }
		/// <summary>
		/// Gets or Sets origin company name
		/// </summary>
		public string origin_company_name { get; set; }
		/// <summary>
		/// Gets or Sets origin contact name
		/// </summary>
		public string origin_contact_name { get; set; }
		/// <summary>
		/// Gets or Sets origin latitude
		/// </summary>
		public string origin_latitude { get; set; }
		/// <summary>
		/// Gets or Sets origin longitude
		/// </summary>
		public string origin_longitude { get; set; }
		/// <summary>
		/// Gets or Sets origin preferred start time
		/// </summary>
		public string origin_preferred_start_time { get; set; }
		/// <summary>
		/// Gets or Sets origin preferred end time
		/// </summary>
		public string origin_preferred_end_time { get; set; }
		/// <summary>
		/// Gets or Sets destination title
		/// </summary>
		public string destination_title { get; set; }
		/// <summary>
		/// Gets or Sets destination code
		/// </summary>
		public string destination_code { get; set; }
		/// <summary>
		/// Gets or Sets destination name
		/// </summary>
		public string destination_name { get; set; }
		/// <summary>
		/// Gets or Sets destination address line1
		/// </summary>
		public string destination_address_line1 { get; set; }
		/// <summary>
		/// Gets or Sets destination address line2
		/// </summary>
		public string destination_address_line2 { get; set; }
		/// <summary>
		/// Gets or Sets destination landmark
		/// </summary>
		public string destination_landmark { get; set; }
		/// <summary>
		/// Gets or Sets destination city
		/// </summary>
		public string destination_city { get; set; }
		/// <summary>
		/// Gets or Sets destination state province
		/// </summary>
		public string destination_state_province { get; set; }
		/// <summary>
		/// Gets or Sets destination country
		/// </summary>
		public string destination_country { get; set; }
		/// <summary>
		/// Gets or Sets destination postal code
		/// </summary>
		public string destination_postal_code { get; set; }
		/// <summary>
		/// Gets or Sets destination contact number
		/// </summary>
		public string destination_contact_number { get; set; }
		/// <summary>
		/// Gets or Sets destination contact number2
		/// </summary>
		public string destination_contact_number2 { get; set; }
		/// <summary>
		/// Gets or Sets destination email
		/// </summary>
		public string destination_email { get; set; }
		/// <summary>
		/// Gets or Sets destination company name
		/// </summary>
		public string destination_company_name { get; set; }
		/// <summary>
		/// Gets or Sets destination contact name
		/// </summary>
		public string destination_contact_name { get; set; }
		/// <summary>
		/// Gets or Sets destination preferred start time
		/// </summary>
		public string destination_preferred_start_time { get; set; }
		/// <summary>
		/// Gets or Sets destination preferred end time
		/// </summary>
		public string destination_preferred_end_time { get; set; }
		/// <summary>
		/// Gets or Sets destination latitude
		/// </summary>
		public string destination_latitude { get; set; }
		/// <summary>
		/// Gets or Sets destination longitude
		/// </summary>
		public string destination_longitude { get; set; }
		/// <summary>
		/// Gets or Sets destination lot id
		/// </summary>
		public string destination_lot_id { get; set; }
		/// <summary>
		/// Gets or Sets return title
		/// </summary>
		public string return_title { get; set; }
		/// <summary>
		/// Gets or Sets return code
		/// </summary>
		public string return_code { get; set; }
		/// <summary>
		/// Gets or Sets return name
		/// </summary>
		public string return_name { get; set; }
		/// <summary>
		/// Gets or Sets return address line1
		/// </summary>
		public string return_address_line1 { get; set; }
		/// <summary>
		/// Gets or Sets return address line2
		/// </summary>
		public string return_address_line2 { get; set; }
		/// <summary>
		/// Gets or Sets return landmark
		/// </summary>
		public string return_landmark { get; set; }
		/// <summary>
		/// Gets or Sets return city
		/// </summary>
		public string return_city { get; set; }
		/// <summary>
		/// Gets or Sets return state province
		/// </summary>
		public string return_state_province { get; set; }
		/// <summary>
		/// Gets or Sets return country
		/// </summary>
		public string return_country { get; set; }
		/// <summary>
		/// Gets or Sets return postal code
		/// </summary>
		public string return_postal_code { get; set; }
		/// <summary>
		/// Gets or Sets return contact number
		/// </summary>
		public string return_contact_number { get; set; }
		/// <summary>
		/// Gets or Sets return contact number2
		/// </summary>
		public string return_contact_number2 { get; set; }
		/// <summary>
		/// Gets or Sets return email
		/// </summary>
		public string return_email { get; set; }
		/// <summary>
		/// Gets or Sets return preferred start time
		/// </summary>
		public string return_preferred_start_time { get; set; }
		/// <summary>
		/// Gets or Sets return preferred end time
		/// </summary>
		public string return_preferred_end_time { get; set; }
		/// <summary>
		/// Gets or Sets return latitude
		/// </summary>
		public string return_latitude { get; set; }
		/// <summary>
		/// Gets or Sets return longitude
		/// </summary>
		public string return_longitude { get; set; }
		/// <summary>
		/// Gets or Sets deliver to title
		/// </summary>
		public string deliver_to_title { get; set; }
		/// <summary>
		/// Gets or Sets deliver to code
		/// </summary>
		public string deliver_to_code { get; set; }
		/// <summary>
		/// Gets or Sets deliver to name
		/// </summary>
		public string deliver_to_name { get; set; }
		/// <summary>
		/// Gets or Sets deliver to address line1
		/// </summary>
		public string deliver_to_address_line1 { get; set; }
		/// <summary>
		/// Gets or Sets deliver to address line2
		/// </summary>
		public string deliver_to_address_line2 { get; set; }
		/// <summary>
		/// Gets or Sets deliver to landmark
		/// </summary>
		public string deliver_to_landmark { get; set; }
		/// <summary>
		/// Gets or Sets deliver to city
		/// </summary>
		public string deliver_to_city { get; set; }
		/// <summary>
		/// Gets or Sets deliver to state province
		/// </summary>
		public string deliver_to_state_province { get; set; }
		/// <summary>
		/// Gets or Sets deliver to country
		/// </summary>
		public string deliver_to_country { get; set; }
		/// <summary>
		/// Gets or Sets deliver to postal code
		/// </summary>
		public string deliver_to_postal_code { get; set; }
		/// <summary>
		/// Gets or Sets deliver to contact number
		/// </summary>
		public string deliver_to_contact_number { get; set; }
		/// <summary>
		/// Gets or Sets deliver to contact number2
		/// </summary>
		public string deliver_to_contact_number2 { get; set; }
		/// <summary>
		/// Gets or Sets deliver to email
		/// </summary>
		public string deliver_to_email { get; set; }
		/// <summary>
		/// Gets or Sets deliver to company name
		/// </summary>
		public string deliver_to_company_name { get; set; }
		/// <summary>
		/// Gets or Sets deliver to contact name
		/// </summary>
		public string deliver_to_contact_name { get; set; }
		/// <summary>
		/// Gets or Sets deliver to preferred start time
		/// </summary>
		public string deliver_to_preferred_start_time { get; set; }
		/// <summary>
		/// Gets or Sets deliver to preferred end time
		/// </summary>
		public string deliver_to_preferred_end_time { get; set; }
		/// <summary>
		/// Gets or Sets deliver to latitude
		/// </summary>
		public string deliver_to_latitude { get; set; }
		/// <summary>
		/// Gets or Sets deliver to longitude
		/// </summary>
		public string deliver_to_longitude { get; set; }
		/// <summary>
		/// Gets or Sets deliver lot id
		/// </summary>
		public string deliver_lot_id { get; set; }
		/// <summary>
		/// Gets or Sets number of shipments
		/// </summary>
		public string number_of_shipments { get; set; }
		/// <summary>
		/// Gets or Sets total weight
		/// </summary>
		public string total_weight { get; set; }
		/// <summary>
		/// Gets or Sets uom total weight
		/// </summary>
		public string uom_total_weight { get; set; }
		/// <summary>
		/// Gets or Sets product code
		/// </summary>
		public string product_code { get; set; }
		/// <summary>
		/// Gets or Sets product type
		/// </summary>
		public string product_type { get; set; }
		/// <summary>
		/// Gets or Sets payment mode
		/// </summary>
		public string payment_mode { get; set; }
		/// <summary>
		/// Gets or Sets invoice value
		/// </summary>
		public string invoice_value { get; set; }
		/// <summary>
		/// Gets or Sets amount to be collected
		/// </summary>
		public string amount_to_be_collected { get; set; }
		/// <summary>
		/// Gets or Sets currency code
		/// </summary>
		public string currency_code { get; set; }
		/// <summary>
		/// Gets or Sets custom value
		/// </summary>
		public string custom_value { get; set; }
		/// <summary>
		/// Gets or Sets shipping date time
		/// </summary>
		public string shipping_date_time { get; set; }
		/// <summary>
		/// Gets or Sets product description
		/// </summary>
		public string product_description { get; set; }
		/// <summary>
		/// Gets or Sets delivery instruction
		/// </summary>
		public string delivery_instruction { get; set; }
		/// <summary>
		/// Gets or Sets item list
		/// </summary>
		public List<FarEyeOrderDetailsItemList> item_list { get; set; }
		/// <summary>
		/// Gets or Sets sku list
		/// </summary>
		public List<FarEyeOrderDetailsSkuList> sku_list { get; set; }
		/// <summary>
		/// Gets or Sets info
		/// </summary>
		public FarEyeOrderDetailsInfo info { get; set; }
        
	}
	/// <summary>
	/// Models class for FarEye Order Details Info
	/// </summary>
	public class FarEyeOrderDetailsInfo
	{
		/// <summary>
		/// Gets or Sets customer po
		/// </summary>
		public string customer_po { get; set; }
		/// <summary>
		/// Gets or Sets purchase order type
		/// </summary>
		public string purchase_order_type { get; set; }
		/// <summary>
		/// Gets or Sets consignee po
		/// </summary>
		public string consignee_po { get; set; }
		/// <summary>
		/// Gets or Sets rma indicator
		/// </summary>
		public string rma_indicator { get; set; }
		/// <summary>
		/// Gets or Sets department number
		/// </summary>
		public string department_number { get; set; }
		/// <summary>
		/// Gets or Sets freight carrier code
		/// </summary>
		public string freight_carrier_code { get; set; }
		/// <summary>
		/// Gets or Sets hot order
		/// </summary>
		public string hot_order { get; set; }
		/// <summary>
		/// Gets or Sets bill of lading
		/// </summary>
		public string bill_of_lading { get; set; }
		/// <summary>
		/// Gets or Sets reserved id
		/// </summary>
		public string reserved_id { get; set; }
		/// <summary>
		/// Gets or Sets transport type
		/// </summary>
		public string transport_type { get; set; }
		/// <summary>
		/// Gets or Sets transportType description
		/// </summary>
		public string transportType_description { get; set; }
		/// <summary>
		/// Gets or Sets transport id
		/// </summary>
		public string transport_id { get; set; }
		/// <summary>
		/// Gets or Sets install date
		/// </summary>
		public string install_date { get; set; }
		/// <summary>
		/// Gets or Sets good issue date
		/// </summary>
		public string good_issue_date { get; set; }
		/// <summary>
		/// Gets or Sets loading date
		/// </summary>
		public string loading_date { get; set; }
		/// <summary>
		/// Gets or Sets transportation planning date
		/// </summary>
		public string transportation_planning_date { get; set; }
		/// <summary>
		/// Gets or Sets outbound delivery date
		/// </summary>
		public string outbound_delivery_date { get; set; }
		/// <summary>
		/// Gets or Sets picking date
		/// </summary>
		public string picking_date { get; set; }
		/// <summary>
		/// Gets or Sets requested delivery date
		/// </summary>
		public string requested_delivery_date { get; set; }
		public string non_executable { get; set; }
		public string non_executable_reason { get; set; }
		public string original_order_number { get; set; }
		public string rl_number { get; set; }
		public string scac_code { get; set; }
		public string rush_order { get; set; }
		public string facility_code { get; set; }
		public string edc_comm_date { get; set; }
	}
	/// <summary>
	/// Model class for Item List of FarEye Order Detail
	/// </summary>
	public class FarEyeOrderDetailsItemList
	{
		/// <summary>
		/// Gets or Sets item reference number
		/// </summary>
		public string item_reference_number { get; set; }
		/// <summary>
		/// Gets or Sets item name
		/// </summary>
		public string item_name { get; set; }
		/// <summary>
		/// Gets or Sets item code
		/// </summary>
		public string item_code { get; set; }
		/// <summary>
		/// Gets or Sets item material type
		/// </summary>
		public string item_material_type { get; set; }
		/// <summary>
		/// Gets or Sets item material descritpion
		/// </summary>
		public string item_material_descritpion { get; set; }
		/// <summary>
		/// Gets or Sets item status
		/// </summary>
		public string item_status { get; set; }
		/// <summary>
		/// Gets or Sets item length
		/// </summary>
		public string item_length { get; set; }
		/// <summary>
		/// Gets or Sets item width
		/// </summary>
		public string item_width { get; set; }
		/// <summary>
		/// Gets or Sets item height
		/// </summary>
		public string item_height { get; set; }
		/// <summary>
		/// Gets or Sets item uom
		/// </summary>
		public string item_uom { get; set; }
		/// <summary>
		/// Gets or Sets item weight uom
		/// </summary>
		public string item_weight_uom { get; set; }
		/// <summary>
		/// Gets or Sets item weight
		/// </summary>
		public double item_weight { get; set; }
		/// <summary>
		/// Gets or Sets item value
		/// </summary>
		public string item_value { get; set; }
		/// <summary>
		/// Gets or Sets item quantity
		/// </summary>
		public int item_quantity { get; set; }
		/// <summary>
		/// Gets or Sets item delivery service time
		/// </summary>
		public int item_delivery_service_time { get; set; }
		/// <summary>
		/// Gets or Sets item special instruction
		/// </summary>
		public string item_special_instruction { get; set; }
		/// <summary>
		/// Gets or Sets harmonized code
		/// </summary>
		public string harmonized_code { get; set; }
		/// <summary>
		/// Gets or Sets item volumn
		/// </summary>
		public string item_volumn { get; set; }
		/// <summary>
		/// Gets or Sets item volumn uom
		/// </summary>
		public string item_volumn_uom { get; set; }
		/// <summary>
		/// Gets or Sets secondary location
		/// </summary>
		public string secondary_location { get; set; }
		/// <summary>
		/// Gets or Sets customer stock number
		/// </summary>
		public string customer_stock_number { get; set; }
		/// <summary>
		/// Gets or Sets item serial number
		/// </summary>
		public string item_serial_number { get; set; }
		/// <summary>
		/// Gets or Sets sap material id
		/// </summary>
		public string sap_material_id { get; set; }
		/// <summary>
		/// Gets or Sets edc material id
		/// </summary>
		public string edc_material_id { get; set; }
		/// <summary>
		/// Gets or Sets item number of reference item
		/// </summary>
		public string item_number_of_reference_item { get; set; }
		/// <summary>
		/// Gets or Sets product hierarchy
		/// </summary>
		public string product_hierarchy { get; set; }
		/// <summary>
		/// Gets or Sets product hierarchy description
		/// </summary>
		public string product_hierarchy_description { get; set; }
		/// <summary>
		/// Gets or Sets customer po
		/// </summary>
		public string customer_po { get; set; }
		/// <summary>
		/// Gets or Sets purchase order type
		/// </summary>
		public string purchase_order_type { get; set; }
		/// <summary>
		/// Gets or Sets cosignee po
		/// </summary>
		public string cosignee_po { get; set; }

		/// <summary>
		/// Gets or Sets serial_barcode
		/// </summary>
		public string serial_barcode { get; set; }

    }
	/// <summary>
	/// Model class for sku List of FarEye Order Detail
	/// </summary>
	public class FarEyeOrderDetailsSkuList
	{
		/// <summary>
		/// Gets or Sets item reference number
		/// </summary>
		public string item_reference_number { get; set; }
		/// <summary>
		/// Gets or Sets sku number
		/// </summary>
		public string sku_number { get; set; }
		/// <summary>
		/// Gets or Sets sku code
		/// </summary>
		public string sku_code { get; set; }
		/// <summary>
		/// Gets or Sets sku item name
		/// </summary>
		public string sku_item_name { get; set; }
		/// <summary>
		/// Gets or Sets sku item description
		/// </summary>
		public string sku_item_description { get; set; }
		/// <summary>
		/// Gets or Sets sku hsn code
		/// </summary>
		public string sku_hsn_code { get; set; }
		/// <summary>
		/// Gets or Sets sku image url
		/// </summary>
		public string sku_image_url { get; set; }
		/// <summary>
		/// Gets or Sets sku quantity
		/// </summary>
		public int sku_quantity { get; set; }
		/// <summary>
		/// Gets or Sets sku value
		/// </summary>
		public string sku_value { get; set; }
		/// <summary>
		/// Gets or Sets sku item sequence
		/// </summary>
		public string sku_item_sequence { get; set; }
		/// <summary>
		/// Gets or Sets sku item unit price
		/// </summary>
		public string sku_item_unit_price { get; set; }

	}
}
