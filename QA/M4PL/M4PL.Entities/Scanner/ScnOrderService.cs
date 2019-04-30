/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderService
Purpose:                                      Contains objects related to ScnOrderService
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScnOrderService : BaseModel
    {
        public long? ServicesID { get; set; }
        public string ServicesCode { get; set; }
        public long? JobID { get; set; }
        public string Notes { get; set; }
        public string Complete { get; set; }
    }
}
