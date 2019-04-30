/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderOSD
Purpose:                                      Contains objects related to ScnOrderOSD
==========================================================================================================*/

using System;

namespace M4PL.Entities.Scanner
{
    public class ScnOrderOSD : BaseModel
    {
        public long CargoOSDID { get; set; }
        public long? OSDID { get; set; }
        public DateTime? DateTime { get; set; }
        public long? CargoDetailID { get; set; }
        public long? CargoID { get; set; }
        public string CgoSerialNumber { get; set; }
        public long? OSDReasonID { get; set; }
        public decimal OSDQty { get; set; }
        public string Notes { get; set; }
        public string EditCD { get; set; }
        public string StatusID { get; set; }
        public string CgoSeverityCode { get; set; }
    }
}
