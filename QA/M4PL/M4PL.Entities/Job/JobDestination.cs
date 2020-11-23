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
// Program Name:                                 JobDestination
// Purpose:                                      Contains objects related to Job Delivery
//==========================================================================================================

namespace M4PL.Entities.Job
{
	public class JobDestination : BaseModel
	{
		/// <summary>
		/// Gets or Sets flag if JobCompleted
		/// </summary>
		public bool JobCompleted { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSiteName
		/// </summary>
		public string JobOriginSiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOC
		/// </summary>
		public string JobOriginSitePOC { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOCPhone
		/// </summary>
		public string JobOriginSitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginSitePOCEmail
		/// </summary>
		public string JobOriginSitePOCEmail { get; set; }
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
		/// Gets or Sets JobDeliverySiteName
		/// </summary>
		public string JobDeliverySiteName { get; set; }


		/// <summary>
		/// Gets or sets the job delivery site poc for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliverySitePOC.
		/// </value>
		public string JobDeliverySitePOC { get; set; }

		/// <summary>
		/// Gets or Sets JobDeliverySitePOCPhone
		/// </summary>
		public string JobDeliverySitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliverySitePOCEmail
		/// </summary>
		public string JobDeliverySitePOCEmail { get; set; }
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
		/// Gets or Sets ControlNameSuffix
		/// </summary>
		public string ControlNameSuffix { get; set; }
		/// <summary>
		/// Gets or Sets JobSignText
		/// </summary>
		public string JobSignText { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLatitude
		/// </summary>
		public string JobSignLatitude { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLongitude
		/// </summary>
		public string JobSignLongitude { get; set; }
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
		/// Gets or Sets JobPreferredMethod
		/// </summary>
		public int? JobPreferredMethod { get; set; }
		/// <summary>
		/// Gets or Sets JobPreferredMethodName
		/// </summary>
		public string JobPreferredMethodName { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsJobVocSurvey
		/// </summary>
		public bool IsJobVocSurvey { get; set; }
		/// <summary>
		/// Gets or Sets flag if JobIsDirtyDestination
		/// </summary>
		public bool JobIsDirtyDestination { get; set; }

	}
}