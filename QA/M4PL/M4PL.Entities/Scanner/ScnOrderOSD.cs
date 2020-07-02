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
// Program Name:                                 ScnOrderOSD
// Purpose:                                      Contains objects related to ScnOrderOSD
//==========================================================================================================

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
