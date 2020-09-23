#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using Newtonsoft.Json;

namespace M4PL.Entities.XCBL.FarEye
{
	public class OrderEvent
	{
		[JsonProperty("order_no")]
		public string OrderNumber { get; set; }

		[JsonProperty("type")]
		public string Type { get; set; }

		[JsonProperty("value")]
		public string TrackingNumber { get; set; }

		[JsonProperty("fareye_status")]
		public string Status { get; set; }

		[JsonProperty("fareye_status_code")]
		public string StatusCode { get; set; }

		[JsonProperty("fareye_status_description")]
		public string StatusDescription { get; set; }

		[JsonProperty("fareye_sub_status")]
		public string SubStatus { get; set; }

		[JsonProperty("fareye_sub_status_code")]
		public string SubStatusCode { get; set; }

		[JsonProperty("fareye_sub_status_description")]
		public string SubStatusDescription { get; set; }

		[JsonProperty("carrier_code")]
		public string CarrierCode { get; set; }

		[JsonProperty("carrier_status")]
		public string CarrierStatus { get; set; }

		[JsonProperty("carrier_status_code")]
		public string CarrierStatusCode { get; set; }

		[JsonProperty("carrier_status_description")]
		public string CarrierStatusDescription { get; set; }

		[JsonProperty("carrier_sub_status")]
		public string CarrierSubStatus { get; set; }

		[JsonProperty("carrier_sub_status_code")]
		public string CarrierSubStatusCode { get; set; }

		[JsonProperty("carrier_sub_status_description")]
		public string CarrierSubStatusDescription { get; set; }

		[JsonProperty("status_received_at")]
		public string StatusReceivedTime { get; set; }

		[JsonProperty("location_code")]
		public string LocationCode { get; set; }

		[JsonProperty("location_name")]
		public string LocationName { get; set; }

		[JsonProperty("destination_location")]
		public string DestinationLocation { get; set; }

		[JsonProperty("latitude")]
		public decimal Latitude { get; set; }

		[JsonProperty("longitude")]
		public decimal Longitude { get; set; }

		[JsonProperty("previous_status")]
		public string PreviousStatus { get; set; }

		[JsonProperty("previous_status_time")]
		public string PreviousStatusTime { get; set; }

		[JsonProperty("last_updated_at")]
		public string LastUpdateTime { get; set; }

		[JsonProperty("status_identifier_value")]
		public string StatusIdentifier { get; set; }

		[JsonProperty("shipment_mode")]
		public string ShipmentMode { get; set; }

		[JsonProperty("extra_info")]
		public ExtraInfo ExtraInfo { get; set; }

		[JsonProperty("info")]
		public Info Information { get; set; }
	}
}
