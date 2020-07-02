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
    public class Job2ndPoc : BaseModel
    {
        public bool JobCompleted { get; set; }
        public string JobDeliverySitePOC2 { get; set; }
        public string JobDeliverySitePOCPhone2 { get; set; }
        public string JobDeliverySitePOCEmail2 { get; set; }
        public string JobOriginSitePOC2 { get; set; }
        public string JobOriginSitePOCPhone2 { get; set; }
        public string JobOriginSitePOCEmail2 { get; set; }

        // origin dupliactes from Job deleivery
        public string JobOriginSiteName { get; set; }

        public string JobOriginStreetAddress { get; set; }
        public string JobOriginStreetAddress2 { get; set; }
        public string JobOriginStreetAddress3 { get; set; }
        public string JobOriginStreetAddress4 { get; set; }
        public string JobOriginCity { get; set; }
        public string JobOriginState { get; set; }
        public string JobOriginCountry { get; set; }
        public string JobOriginPostalCode { get; set; }
        public DateTime? JobOriginDateTimePlanned { get; set; }
        public DateTime? JobOriginDateTimeActual { get; set; }
        public DateTime? JobOriginDateTimeBaseline { get; set; }
        public string JobOriginTimeZone { get; set; }

        // origin dupliactes from Job deleivery

        public string JobDeliverySiteName { get; set; }
        public string JobDeliveryStreetAddress { get; set; }
        public string JobDeliveryStreetAddress2 { get; set; }
        public string JobDeliveryStreetAddress3 { get; set; }
        public string JobDeliveryStreetAddress4 { get; set; }
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