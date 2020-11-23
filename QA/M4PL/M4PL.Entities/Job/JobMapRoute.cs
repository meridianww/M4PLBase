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
// Program Name:                                 JobMapRoute
// Purpose:                                      Contains objects related to JobMapRoute
//==========================================================================================================
namespace M4PL.Entities.Job
{
	public class JobMapRoute : BaseModel
	{
		/// <summary>
		/// Gets or sets the latitude.
		/// </summary>
		/// <value>
		/// The JobLatitude.
		/// </value>
		public string JobLatitude { get; set; }

		/// <summary>
		/// Gets or sets the longitude.
		/// </summary>
		/// <value>
		/// The JobLongitude.
		/// </value>
		public string JobLongitude { get; set; }

		/// <summary>
		/// Gets or sets the longitude.
		/// </summary>
		/// <value>
		/// The JobLongitude.
		/// </value>
		public decimal JobMileage { get; set; }
		/// <summary>
		/// Gets or Sets Delivery Full Address
		/// </summary>
		public string DeliveryFullAddress { get; set; }
		/// <summary>
		/// Gets or Sets Origin Full Address
		/// </summary>
		public string OriginFullAddress { get; set; }
		/// <summary>
		/// Gets or Sets flag if Address Updated
		/// </summary>
		public bool isAddressUpdated { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsOnlyCountryCodeExistsForDeliveryAddress
		/// </summary>
		public bool IsOnlyCountryCodeExistsForDeliveryAddress { get; set; }
	}
}