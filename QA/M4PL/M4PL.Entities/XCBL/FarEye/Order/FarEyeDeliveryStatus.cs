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
	public class FarEyeDeliveryStatus
	{
		public string order_number { get; set; }
		public string type { get; set; }
		public string value { get; set; }
		public string fareye_status { get; set; }
		public string fareye_status_code { get; set; }
		public string fareye_status_description { get; set; }
		public string fareye_sub_status { get; set; }
		public string fareye_sub_status_code { get; set; }
		public string fareye_sub_status_description { get; set; }
		public string carrier_code { get; set; }
		public string carrier_status { get; set; }
		public string carrier_status_code { get; set; }
		public string carrier_status_description { get; set; }
		public string carrier_sub_status { get; set; }
		public string carrier_sub_status_description { get; set; }
		public string status_received_at { get; set; }
		public string location_code { get; set; }
		public string location_name { get; set; }
		public string destination_location { get; set; }
		public int latitude { get; set; }
		public int longitude { get; set; }
		public string previous_status { get; set; }
		public string previous_status_time { get; set; }
		public string last_updated_at { get; set; }
		public string carrier_status_time_gmt { get; set; }
		public string status_identifier_value { get; set; }
		public string shipment_mode { get; set; }
		public DeliveryExtraInfo extra_info { get; set; }
		public DeliveryInfo info { get; set; }
	}

	public class DeliveryExtraInfo
	{
		public string comments { get; set; }
		public string promised_delivery_date { get; set; }
		public string expected_delivery_date { get; set; }
		public string received_by { get; set; }
		public string relation { get; set; }
		public string epod { get; set; }
		public string signature { get; set; }
		public string customer_code { get; set; }
		public string customer_name { get; set; }
	}

	public class DeliveryLineItem
	{
		public string item_number { get; set; }
		public string material_id { get; set; }
		public string quantity { get; set; }
		public string unit_of_measure { get; set; }
		public string item_install_status { get; set; }
		public string comments { get; set; }
		public string exception_code { get; set; }
		public string exception_detail { get; set; }
		public string item_Install_status_description { get; set; }
	}

	public class DeliveryInfo
	{
		public string reschedule_date { get; set; }
		public string reschedule_reason { get; set; }
		public List<DeliveryLineItem> LineItems { get; set; }
	}
}
