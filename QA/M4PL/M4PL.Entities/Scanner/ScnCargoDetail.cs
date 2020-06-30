/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnCargoDetail
Purpose:                                      Contains objects related to ScnCargoDetail
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScnCargoDetail : BaseModel
    {
        public long CargoDetailID { get; set; }
        public long? CargoID { get; set; }
        public string DetSerialNumber { get; set; }
        public decimal DetQtyCounted { get; set; }
        public decimal DetQtyDamaged { get; set; }
        public decimal DetQtyShort { get; set; }
        public decimal DetQtyOver { get; set; }
        public string DetPickStatus { get; set; }
        public string DetLong { get; set; }
        public string DetLat { get; set; }
    }
}
