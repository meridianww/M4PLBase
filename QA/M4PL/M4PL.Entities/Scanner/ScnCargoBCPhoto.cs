/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              07/26/2018
Program Name:                                 ScnCargoBCPhoto
Purpose:                                      Contains objects related to ScnCargoBCPhoto
==========================================================================================================*/


namespace M4PL.Entities.Scanner
{
    public class ScnCargoBCPhoto : BaseModel
    {
        public long CargoID { get; set; }
        public byte[] Photo { get; set; }
        public string Step { get; set; }
    }
}
