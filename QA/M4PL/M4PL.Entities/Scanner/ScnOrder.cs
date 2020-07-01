/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrder
Purpose:                                      Contains objects related to ScnOrder
==========================================================================================================*/

using System;

namespace M4PL.Entities.Scanner
{
    public class ScnOrder : BaseModel
    {
        public long JobID { get; set; }
        public long? ProgramID { get; set; }
        public int? RouteID { get; set; }
        public long? DriverID { get; set; }
        public string JobDeviceID { get; set; }
        public int JobStop { get; set; }
        public string JobOrderID { get; set; }
        public string JobManifestID { get; set; }
        public string JobCarrierID { get; set; }
        public int? JobReturnReasonID { get; set; }
        public string JobStatusCD { get; set; }
        public string JobOriginSiteCode { get; set; }
        public string JobOriginSiteName { get; set; }
        public string JobDeliverySitePOC { get; set; }
        public string JobDeliverySitePOC2 { get; set; }
        public string JobDeliveryStreetAddress { get; set; }
        public string JobDeliveryStreetAddress2 { get; set; }
        public string JobDeliveryCity { get; set; }
        public string JobDeliveryStateProvince { get; set; }
        public string JobDeliveryPostalCode { get; set; }
        public string JobDeliveryCountry { get; set; }
        public string JobDeliverySitePOCPhone { get; set; }
        public string JobDeliverySitePOCPhone2 { get; set; }
        public string JobDeliveryPhoneHm { get; set; }
        public string JobDeliverySitePOCEmail { get; set; }
        public string JobDeliverySitePOCEmail2 { get; set; }
        public string JobOriginStreetAddress { get; set; }
        public string JobOriginCity { get; set; }
        public string JobOriginStateProvince { get; set; }
        public string JobOriginPostalCode { get; set; }
        public string JobOriginCountry { get; set; }
        public string JobLongitude { get; set; }
        public string JobLatitude { get; set; }
        public string JobSignLongitude { get; set; }
        public string JobSignLatitude { get; set; }
        public string JobSignText { get; set; }
        public byte[] JobSignCapture { get; set; }
        public DateTime? JobScheduledDate { get; set; }
        public DateTime? JobScheduledTime { get; set; }
        public DateTime? JobEstimatedDate { get; set; }
        public DateTime? JobEstimatedTime { get; set; }
        public DateTime? JobActualDate { get; set; }
        public DateTime? JobActualTime { get; set; }
        public int? ColorCD { get; set; }
        public string JobFor { get; set; }
        public string JobFrom { get; set; }
        public DateTime? WindowStartTime { get; set; }
        public DateTime? WindowEndTime { get; set; }
        public string JobFlag01 { get; set; }
        public string JobFlag02 { get; set; }
        public string JobFlag03 { get; set; }
        public string JobFlag04 { get; set; }
        public string JobFlag05 { get; set; }
        public string JobFlag06 { get; set; }
        public string JobFlag07 { get; set; }
        public string JobFlag08 { get; set; }
        public string JobFlag09 { get; set; }
        public string JobFlag10 { get; set; }
        public string JobFlag11 { get; set; }
        public string JobFlag12 { get; set; }
        public string JobFlag13 { get; set; }
        public string JobFlag14 { get; set; }
        public string JobFlag15 { get; set; }
        public string JobFlag16 { get; set; }
        public string JobFlag17 { get; set; }
        public string JobFlag18 { get; set; }
        public string JobFlag19 { get; set; }
        public string JobFlag20 { get; set; }
        public int? JobFlag21 { get; set; }
        public long? JobFlag22 { get; set; }
        public int? JobFlag23 { get; set; }
    }
}
