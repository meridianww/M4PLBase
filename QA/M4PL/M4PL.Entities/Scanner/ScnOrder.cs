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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ScnOrder
// Purpose:                                      Contains objects related to ScnOrder
//==========================================================================================================

using System;

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Order
	/// </summary>
	public class ScnOrder : BaseModel
	{
		/// <summary>
		/// Gets or Sets JobID
		/// </summary>
		public long JobID { get; set; }
		/// <summary>
		/// Gets or Sets ProgramID
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets RouteID
		/// </summary>
		public int? RouteID { get; set; }
		/// <summary>
		/// Gets or Sets DriverID
		/// </summary>
		public long? DriverID { get; set; }
		/// <summary>
		/// Gets or Sets JobDeviceID
		/// </summary>
		public string JobDeviceID { get; set; }
		/// <summary>
		/// Gets or Sets JobStop
		/// </summary>
		public int JobStop { get; set; }
		/// <summary>
		/// Gets or Sets JobOrderID
		/// </summary>
		public string JobOrderID { get; set; }
		/// <summary>
		/// Gets or Sets JobManifestID
		/// </summary>
		public string JobManifestID { get; set; }
		/// <summary>
		/// Gets or Sets JobCarrierID
		/// </summary>
		public string JobCarrierID { get; set; }
		/// <summary>
		/// Gets or Sets JobReturnReasonID
		/// </summary>
		public int? JobReturnReasonID { get; set; }
		/// <summary>
		/// Gets or Sets JobStatusCD
		/// </summary>
		public string JobStatusCD { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSiteCode
		/// </summary>
		public string JobOriginSiteCode { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSiteName
		/// </summary>
		public string JobOriginSiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOC
		/// </summary>
		public string JobDeliverySitePOC { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOC2
		/// </summary>
		public string JobDeliverySitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress
		/// </summary>
		public string JobDeliveryStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress2
		/// </summary>
		public string JobDeliveryStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryCity
		/// </summary>
		public string JobDeliveryCity { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStateProvince
		/// </summary>
		public string JobDeliveryStateProvince { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryPostalCode
		/// </summary>
		public string JobDeliveryPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryCountry
		/// </summary>
		public string JobDeliveryCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCPhone
		/// </summary>
		public string JobDeliverySitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCPhone2
		/// </summary>
		public string JobDeliverySitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryPhoneHm
		/// </summary>
		public string JobDeliveryPhoneHm { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCEmail
		/// </summary>
		public string JobDeliverySitePOCEmail { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCEmail2
		/// </summary>
		public string JobDeliverySitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress
		/// </summary>
		public string JobOriginStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginCity
		/// </summary>
		public string JobOriginCity { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStateProvince
		/// </summary>
		public string JobOriginStateProvince { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginPostalCode
		/// </summary>
		public string JobOriginPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginCountry
		/// </summary>
		public string JobOriginCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobLongitude
		/// </summary>
		public string JobLongitude { get; set; }
		/// <summary>
		/// Gets or Sets JobLatitude
		/// </summary>
		public string JobLatitude { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLongitude
		/// </summary>
		public string JobSignLongitude { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLatitude
		/// </summary>
		public string JobSignLatitude { get; set; }
		/// <summary>
		/// Gets or Sets JobSignText
		/// </summary>
		public string JobSignText { get; set; }
		/// <summary>
		/// Gets or Sets JobSignCapture
		/// </summary>
		public byte[] JobSignCapture { get; set; }
		/// <summary>
		/// Gets or Sets JobScheduledDate
		/// </summary>
		public DateTime? JobScheduledDate { get; set; }
		/// <summary>
		/// Gets or Sets JobScheduledTime
		/// </summary>
		public DateTime? JobScheduledTime { get; set; }
		/// <summary>
		/// Gets or Sets JobEstimatedDate
		/// </summary>
		public DateTime? JobEstimatedDate { get; set; }
		/// <summary>
		/// Gets or Sets JobEstimatedTime
		/// </summary>
		public DateTime? JobEstimatedTime { get; set; }
		/// <summary>
		/// Gets or Sets JobActualDate
		/// </summary>
		public DateTime? JobActualDate { get; set; }
		/// <summary>
		/// Gets or Sets JobActualTime
		/// </summary>
		public DateTime? JobActualTime { get; set; }
		/// <summary>
		/// Gets or Sets ColorCD
		/// </summary>
		public int? ColorCD { get; set; }
		/// <summary>
		/// Gets or Sets JobFor
		/// </summary>
		public string JobFor { get; set; }
		/// <summary>
		/// Gets or Sets JobFrom
		/// </summary>
		public string JobFrom { get; set; }
		/// <summary>
		/// Gets or Sets WindowStartTime
		/// </summary>
		public DateTime? WindowStartTime { get; set; }
		/// <summary>
		/// Gets or Sets WindowEndTime
		/// </summary>
		public DateTime? WindowEndTime { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag01
		/// </summary>
		public string JobFlag01 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag02
		/// </summary>
		public string JobFlag02 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag03
		/// </summary>
		public string JobFlag03 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag04
		/// </summary>
		public string JobFlag04 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag05
		/// </summary>
		public string JobFlag05 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag06
		/// </summary>
		public string JobFlag06 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag07
		/// </summary>
		public string JobFlag07 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag08
		/// </summary>
		public string JobFlag08 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag09
		/// </summary>
		public string JobFlag09 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag10
		/// </summary>
		public string JobFlag10 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag11
		/// </summary>
		public string JobFlag11 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag12
		/// </summary>
		public string JobFlag12 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag13
		/// </summary>
		public string JobFlag13 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag14
		/// </summary>
		public string JobFlag14 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag15
		/// </summary>
		public string JobFlag15 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag16
		/// </summary>
		public string JobFlag16 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag17
		/// </summary>
		public string JobFlag17 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag18
		/// </summary>
		public string JobFlag18 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag19
		/// </summary>
		public string JobFlag19 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag20
		/// </summary>
		public string JobFlag20 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag21
		/// </summary>
		public int? JobFlag21 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag22
		/// </summary>
		public long? JobFlag22 { get; set; }
		/// <summary>
		/// Gets or Sets JobFlag23
		/// </summary>
		public int? JobFlag23 { get; set; }

	}
}