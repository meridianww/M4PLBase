/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobMapRoute
Purpose:                                      Contains objects related to JobMapRoute
==========================================================================================================*/
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

		public string DeliveryFullAddress { get; set; }

	}
}