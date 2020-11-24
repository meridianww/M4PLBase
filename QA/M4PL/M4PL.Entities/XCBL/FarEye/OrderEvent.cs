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
	/// <summary>
	/// Model class for Order Event
	/// </summary>
	public class OrderEvent
	{
		/// <summary>
		/// Gets or Sets Order Number
		/// </summary>
		[JsonProperty("order_no")]
		public string OrderNumber { get; set; }
		/// <summary>
		/// Gets or Sets Order Type
		/// </summary>
		[JsonProperty("type")]
		public string Type { get; set; }
		/// <summary>
		/// Gets or Sets Tracking Number
		/// </summary>
		[JsonProperty("value")]
		public string TrackingNumber { get; set; }
		/// <summary>
		/// Gets or Sets Status
		/// </summary>
		[JsonProperty("fareye_status")]
		public string Status { get; set; }
		/// <summary>
		/// Gets or Sets Status Code e.g. reschedule
		/// </summary>
		[JsonProperty("fareye_status_code")]
		public string StatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Status Description
		/// </summary>
		[JsonProperty("fareye_status_description")]
		public string StatusDescription { get; set; }
		/// <summary>
		/// Gets or Sets Sub Status
		/// </summary>
		[JsonProperty("fareye_sub_status")]
		public string SubStatus { get; set; }
		/// <summary>
		/// Gets or Sets Sub Status Code
		/// </summary>
		[JsonProperty("fareye_sub_status_code")]
		public string SubStatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Sub Status Description
		/// </summary>
		[JsonProperty("fareye_sub_status_description")]
		public string SubStatusDescription { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Code
		/// </summary>
		[JsonProperty("carrier_code")]
		public string CarrierCode { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Status
		/// </summary>
		[JsonProperty("carrier_status")]
		public string CarrierStatus { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Status Code
		/// </summary>
		[JsonProperty("carrier_status_code")]
		public string CarrierStatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Status Description
		/// </summary>
		[JsonProperty("carrier_status_description")]
		public string CarrierStatusDescription { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Sub Status
		/// </summary>
		[JsonProperty("carrier_sub_status")]
		public string CarrierSubStatus { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Sub Status Code
		/// </summary>
		[JsonProperty("carrier_sub_status_code")]
		public string CarrierSubStatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Carrier Sub Status Description
		/// </summary>
		[JsonProperty("carrier_sub_status_description")]
		public string CarrierSubStatusDescription { get; set; }
		/// <summary>
		/// Gets or Sets Status Received Time
		/// </summary>
		[JsonProperty("status_received_at")]
		public string StatusReceivedTime { get; set; }
		/// <summary>
		/// Gets or Sets Location Code
		/// </summary>
		[JsonProperty("location_code")]
		public string LocationCode { get; set; }
		/// <summary>
		/// Gets or Sets Location Name
		/// </summary>
		[JsonProperty("location_name")]
		public string LocationName { get; set; }
		/// <summary>
		/// Gets or Sets Destination Location
		/// </summary>
		[JsonProperty("destination_location")]
		public string DestinationLocation { get; set; }
		/// <summary>
		/// Gets or Sets Latitude
		/// </summary>
		[JsonProperty("latitude")]
		public decimal Latitude { get; set; }
		/// <summary>
		/// Gets or Sets Longitude
		/// </summary>
		[JsonProperty("longitude")]
		public decimal Longitude { get; set; }
		/// <summary>
		/// Gets or Sets Previous Status
		/// </summary>
		[JsonProperty("previous_status")]
		public string PreviousStatus { get; set; }
		/// <summary>
		/// Gets or Sets Previous Status Time
		/// </summary>
		[JsonProperty("previous_status_time")]
		public string PreviousStatusTime { get; set; }
		/// <summary>
		/// Gets or Sets Last Updated Time
		/// </summary>
		[JsonProperty("last_updated_at")]
		public string LastUpdateTime { get; set; }
		/// <summary>
		/// Gets or Sets Status Id
		/// </summary>
		[JsonProperty("status_identifier_value")]
		public string StatusIdentifier { get; set; }
		/// <summary>
		/// Gets or Sets Shioment Mode
		/// </summary>
		[JsonProperty("shipment_mode")]
		public string ShipmentMode { get; set; }
		/// <summary>
		/// Gets or Sets Extra Information
		/// </summary>
		[JsonProperty("extra_info")]
		public ExtraInfo ExtraInfo { get; set; }
		/// <summary>
		/// Gets or Sets Information
		/// </summary>
		[JsonProperty("info")]
		public Info Information { get; set; }
	}
}
