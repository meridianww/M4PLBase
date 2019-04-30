/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobSeller
Purpose:                                      Contains objects related to Job Seller
==========================================================================================================*/

using System;

namespace M4PL.Entities.Job
{
    public class JobSeller : BaseModel
    {
        public bool JobCompleted { get; set; }
        public string JobSellerCode { get; set; }
        public string JobSellerSitePOC { get; set; }
        public string JobSellerSitePOCPhone { get; set; }
        public string JobSellerSitePOCEmail { get; set; }
        public string JobSellerSitePOC2 { get; set; }
        public string JobSellerSitePOCPhone2 { get; set; }
        public string JobSellerSitePOCEmail2 { get; set; }
        public string JobSellerSiteName { get; set; }
        public string JobSellerStreetAddress { get; set; }
        public string JobSellerStreetAddress2 { get; set; }
        public string JobSellerCity { get; set; }
        public string JobSellerState { get; set; }
        public string JobSellerPostalCode { get; set; }
        public string JobSellerCountry { get; set; }

        public string JobDeliverySiteName { get; set; }
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
    }
}