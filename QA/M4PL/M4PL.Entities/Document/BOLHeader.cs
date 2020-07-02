#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;

namespace M4PL.Entities.Document
{
	public class BOLHeader
	{
		public string BOLNumber { get; set; }
		public string VendorLocation { get; set; }
		public string ContractNumber { get; set; }
		public string ManifestNo { get; set; }
		public string PlantCode { get; set; }
		public string TrailerNo { get; set; }
		public string OrderedDate { get; set; }
		public string ShipmentDate { get; set; }
		public string ArrivalPlannedDate { get; set; }
		public string DeliveryPlannedDate { get; set; }
		public string OriginSiteName { get; set; }
		public string OriginAddress { get; set; }
		public string OriginAddress1 { get; set; }
		public string OriginAddress2 { get; set; }
		public string OriginAddress3 { get; set; }
		public string OriginCity { get; set; }
		public string OriginStateCode { get; set; }
		public string OriginPostalCode { get; set; }
		public string OriginCountry { get; set; }
		public string OriginContactName { get; set; }
		public string OriginPhoneNumber { get; set; }
		public string OriginEmail { get; set; }
		public string OriginWindow { get; set; }
		public string OriginTimeZone { get; set; }
		public string DestinationSiteName { get; set; }
		public string DestinationAddress { get; set; }
		public string DestinationAddress1 { get; set; }
		public string DestinationAddress2 { get; set; }
		public string DestinationAddress3 { get; set; }
		public string DestinationCity { get; set; }
		public string DestinationStateCode { get; set; }
		public string DestinationPostalCode { get; set; }
		public string DestinationCountry { get; set; }
		public string DestinationContactName { get; set; }
		public string DestinationPhoneNumber { get; set; }
		public string DestinationEmail { get; set; }
		public string DestinationWindow { get; set; }
		public string DestinationTimeZone { get; set; }
		public string OrderType { get; set; }
		public decimal TotalWeight { get; set; }
		public string ShipmentType { get; set; }
		public decimal? TotalCube { get; set; }
		public string DriverAlert { get; set; }
	}
}
