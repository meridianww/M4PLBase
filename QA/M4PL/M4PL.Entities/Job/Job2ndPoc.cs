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
// Program Name:                                 Job2ndPoc
// Purpose:                                      Contains objects related to Job 2nd Poc
//==========================================================================================================

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job second POC
	/// </summary>
	public class Job2ndPoc : BaseModel
	{
		/// <summary>
		/// Gets or Sets flag if JobCompleted
		/// </summary>
		public bool JobCompleted { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOC2
		/// </summary>
		public string JobDeliverySitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCPhone2
		/// </summary>
		public string JobDeliverySitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCEmail2
		/// </summary>
		public string JobDeliverySitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOC2
		/// </summary>
		public string JobOriginSitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOCPhone2
		/// </summary>
		public string JobOriginSitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOCEmail2
		/// </summary>
		public string JobOriginSitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSiteName
		/// </summary>
		public string JobOriginSiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress
		/// </summary>
		public string JobOriginStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress2
		/// </summary>
		public string JobOriginStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress3
		/// </summary>
		public string JobOriginStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress4
		/// </summary>
		public string JobOriginStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginCity
		/// </summary>
		public string JobOriginCity { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginState
		/// </summary>
		public string JobOriginState { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginCountry
		/// </summary>
		public string JobOriginCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginPostalCode
		/// </summary>
		public string JobOriginPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginDateTimePlanned
		/// </summary>
		public DateTime? JobOriginDateTimePlanned { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginDateTimeActual
		/// </summary>
		public DateTime? JobOriginDateTimeActual { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginDateTimeBaseline
		/// </summary>
		public DateTime? JobOriginDateTimeBaseline { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginTimeZone
		/// </summary>
		public string JobOriginTimeZone { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySiteName
		/// </summary>
		public string JobDeliverySiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress
		/// </summary>
		public string JobDeliveryStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress2
		/// </summary>
		public string JobDeliveryStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress3
		/// </summary>
		public string JobDeliveryStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress4
		/// </summary>
		public string JobDeliveryStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryCity
		/// </summary>
		public string JobDeliveryCity { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryState
		/// </summary>
		public string JobDeliveryState { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryCountry
		/// </summary>
		public string JobDeliveryCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryPostalCode
		/// </summary>
		public string JobDeliveryPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryDateTimePlanned
		/// </summary>
		public DateTime? JobDeliveryDateTimePlanned { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryDateTimeActual
		/// </summary>
		public DateTime? JobDeliveryDateTimeActual { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryDateTimeBaseline
		/// </summary>
		public DateTime? JobDeliveryDateTimeBaseline { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryTimeZone
		/// </summary>
		public string JobDeliveryTimeZone { get; set; }

	}
}