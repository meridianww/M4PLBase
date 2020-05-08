/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobDestination
Purpose:                                      Contains objects related to Job Delivery
==========================================================================================================*/

using System;

namespace M4PL.Entities.Job
{
    public class JobDestination : BaseModel
    {
        public bool JobCompleted { get; set; }
        public string JobOriginSiteName { get; set; }
        public string JobOriginSitePOC { get; set; }
        public string JobOriginSitePOCPhone { get; set; }
        public string JobOriginSitePOCEmail { get; set; }
        public string JobOriginStreetAddress { get; set; }
        public string JobOriginStreetAddress2 { get; set; }
        public string JobOriginStreetAddress3 { get; set; }
        public string JobOriginStreetAddress4 { get; set; }
        public string JobOriginCity { get; set; }
        public string JobOriginState { get; set; }
        public string JobOriginCountry { get; set; }
        public string JobOriginPostalCode { get; set; }
        public string JobDeliverySiteName { get; set; }

        /// <summary>
        /// Gets or sets the job delivery site poc for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliverySitePOC.
        /// </value>
        public string JobDeliverySitePOC { get; set; }

        public string JobDeliverySitePOCPhone { get; set; }
        public string JobDeliverySitePOCEmail { get; set; }
        public string JobDeliveryStreetAddress { get; set; }
        public string JobDeliveryStreetAddress2 { get; set; }
        public string JobDeliveryStreetAddress3 { get; set; }
        public string JobDeliveryStreetAddress4 { get; set; }
        public string JobDeliveryCity { get; set; }
        public string JobDeliveryState { get; set; }
        public string JobDeliveryCountry { get; set; }
        public string JobDeliveryPostalCode { get; set; }

        public string ControlNameSuffix { get; set; }

        public string JobSignText { get; set; }
        public string JobSignLatitude { get; set; }
        public string JobSignLongitude { get; set; }
        public string JobOriginSitePOC2 { get; set; }
        public string JobOriginSitePOCPhone2 { get; set; }
        public string JobOriginSitePOCEmail2 { get; set; }

        public string JobDeliverySitePOC2 { get; set; }
        public string JobDeliverySitePOCPhone2 { get; set; }
        public string JobDeliverySitePOCEmail2 { get; set; }
        public int? JobPreferredMethod { get; set; }
        public string JobPreferredMethodName { get; set; }

        public bool IsJobVocSurvey { get; set; }
    }
}