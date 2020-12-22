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
	/// Model class for FarEye Delivery Status
	/// </summary>
	public class FarEyeDeliveryStatus
	{
		/// <summary>
		/// Gets or Sets order number
		/// </summary>
		public string order_number { get; set; }
		/// <summary>
		/// Gets or Sets type
		/// </summary>
		public string type { get; set; }
		/// <summary>
		/// Gets or Sets value
		/// </summary>
		public string value { get; set; }
		/// <summary>
		/// Gets or Sets fareye status
		/// </summary>
		public string fareye_status { get; set; }
		/// <summary>
		/// Gets or Sets fareye status code
		/// </summary>
		public string fareye_status_code { get; set; }
		/// <summary>
		/// Gets or Sets fareye status description
		/// </summary>
		public string fareye_status_description { get; set; }
		/// <summary>
		/// Gets or Sets fareye sub status
		/// </summary>
		public string fareye_sub_status { get; set; }
		/// <summary>
		/// Gets or Sets fareye sub status code
		/// </summary>
		public string fareye_sub_status_code { get; set; }
		/// <summary>
		/// Gets or Sets fareye sub status description
		/// </summary>
		public string fareye_sub_status_description { get; set; }
		/// <summary>
		/// Gets or Sets carrier code
		/// </summary>
		public string carrier_code { get; set; }
		/// <summary>
		/// Gets or Sets carrier status
		/// </summary>
		public string carrier_status { get; set; }
		/// <summary>
		/// Gets or Sets carrier status code
		/// </summary>
		public string carrier_status_code { get; set; }
		/// <summary>
		/// Gets or Sets carrier status description
		/// </summary>
		public string carrier_status_description { get; set; }
		/// <summary>
		/// Gets or Sets carrier sub status
		/// </summary>
		public string carrier_sub_status { get; set; }
		/// <summary>
		/// Gets or Sets carrier sub status description
		/// </summary>
		public string carrier_sub_status_description { get; set; }
		/// <summary>
		/// Gets or Sets status received at
		/// </summary>
		public string status_received_at { get; set; }
		/// <summary>
		/// Gets or Sets location code
		/// </summary>
		public string location_code { get; set; }
		/// <summary>
		/// Gets or Sets location name
		/// </summary>
		public string location_name { get; set; }
		/// <summary>
		/// Gets or Sets destination location
		/// </summary>
		public string destination_location { get; set; }
		/// <summary>
		/// Gets or Sets latitude
		/// </summary>
		public int latitude { get; set; }
		/// <summary>
		/// Gets or Sets longitude
		/// </summary>
		public int longitude { get; set; }
		/// <summary>
		/// Gets or Sets previous status
		/// </summary>
		public string previous_status { get; set; }
		/// <summary>
		/// Gets or Sets previous status time
		/// </summary>
		public string previous_status_time { get; set; }
		/// <summary>
		/// Gets or Sets last updated at
		/// </summary>
		public string last_updated_at { get; set; }
		/// <summary>
		/// Gets or Sets carrier status time gmt
		/// </summary>
		public string carrier_status_time_gmt { get; set; }
		/// <summary>
		/// Gets or Sets status identifier value
		/// </summary>
		public string status_identifier_value { get; set; }
		/// <summary>
		/// Gets or Sets shipment mode
		/// </summary>
		public string shipment_mode { get; set; }
		/// <summary>
		/// Gets or Sets extra info
		/// </summary>
		public DeliveryExtraInfo extra_info { get; set; }
		/// <summary>
		/// Gets or Sets Delivery info
		/// </summary>
		public DeliveryInfo info { get; set; }

	}
	/// <summary>
	/// Model class for Delivery Additional Info
	/// </summary>
	public class DeliveryExtraInfo
	{
		/// <summary>
		/// Gets or Sets comments
		/// </summary>
		public string comments { get; set; }
		/// <summary>
		/// Gets or Sets promised delivery date
		/// </summary>
		public string promised_delivery_date { get; set; }
		/// <summary>
		/// Gets or Sets expected delivery date
		/// </summary>
		public string expected_delivery_date { get; set; }
		/// <summary>
		/// Gets or Sets received by
		/// </summary>
		public string received_by { get; set; }
		/// <summary>
		/// Gets or Sets relation
		/// </summary>
		public string relation { get; set; }
		/// <summary>
		/// Gets or Sets epod
		/// </summary>
		public string epod { get; set; }
		/// <summary>
		/// Gets or Sets signature
		/// </summary>
		public string signature { get; set; }
		/// <summary>
		/// Gets or Sets customer code
		/// </summary>
		public string customer_code { get; set; }
		/// <summary>
		/// Gets or Sets customer name
		/// </summary>
		public string customer_name { get; set; }

	}
	/// <summary>
	/// Model class for Delivery Line Item
	/// </summary>
	public class DeliveryLineItem
	{
		/// <summary>
		/// Gets or Sets item number
		/// </summary>
		public string item_number { get; set; }
		/// <summary>
		/// Gets or Sets material id
		/// </summary>
		public string material_id { get; set; }

        public string serial_barcode { get; set; }
        public string serial_number { get; set; }
        /// <summary>
        /// Gets or Sets quantity
        /// </summary>
        public string quantity { get; set; }
		/// <summary>
		/// Gets or Sets unit of measure
		/// </summary>
		public string unit_of_measure { get; set; }
		/// <summary>
		/// Gets or Sets item install status
		/// </summary>
		public string item_install_status { get; set; }
		/// <summary>
		/// Gets or Sets comments
		/// </summary>
		public string comments { get; set; }
		/// <summary>
		/// Gets or Sets exception code
		/// </summary>
		public string exception_code { get; set; }
		/// <summary>
		/// Gets or Sets exception detail
		/// </summary>
		public string exception_detail { get; set; }
		/// <summary>
		/// Gets or Sets item Install status description
		/// </summary>
		public string item_Install_status_description { get; set; }

	}
	/// <summary>
	/// Gets or Sets Delivery Info
	/// </summary>
	public class DeliveryInfo
	{
		/// <summary>
		/// Gets or Sets Reschedule Date
		/// </summary>
		public string reschedule_date { get; set; }
		/// <summary>
		/// Gets or Sets Reschedule Reason
		/// </summary>
		public string reschedule_reason { get; set; }
		/// <summary>
		/// Gets or Sets List of  Delivery Line Items
		/// </summary>
		public List<DeliveryLineItem> LineItems { get; set; }
	}
}
