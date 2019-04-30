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
        public string JobOriginCity { get; set; }
        public string JobOriginState { get; set; }
        public string JobOriginCountry { get; set; }
        public string JobOriginPostalCode { get; set; }
        public DateTime? JobOriginDateTimePlanned { get; set; }

        public DateTime? JobOriginDateTimeActual { get; set; }

        public DateTime? JobOriginDateTimeBaseline { get; set; }

        public string JobOriginTimeZone { get; set; }
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
        public string JobDeliveryCity { get; set; }
        public string JobDeliveryState { get; set; }
        public string JobDeliveryCountry { get; set; }
        public string JobDeliveryPostalCode { get; set; }
        public DateTime? JobDeliveryDateTimePlanned { get; set; }

        public DateTime? JobDeliveryDateTimeActual { get; set; }

        public DateTime? JobDeliveryDateTimeBaseline { get; set; }

        public string JobDeliveryTimeZone { get; set; }
        public string ControlNameSuffix { get; set; }

        public DateTime? WindowDelStartTime { get; set; }
        public DateTime? WindowDelEndTime { get; set; }
        public DateTime? WindowPckStartTime { get; set; }
        public DateTime? WindowPckEndTime { get; set; }

        public string JobSignText { get; set; }
        public string JobSignLatitude { get; set; }
        public string JobSignLongitude { get; set; }


        public decimal? PckEarliest { get; set; }
        public decimal? PckLatest { get; set; }
        public bool PckDay { get; set; }
        public decimal? DelEarliest { get; set; }
        public decimal? DelLatest { get; set; }
        public bool DelDay { get; set; }

        public DateTime? ProgramPickupDefault { get; set; }
        public DateTime? ProgramDeliveryDefault { get; set; }


    }
}