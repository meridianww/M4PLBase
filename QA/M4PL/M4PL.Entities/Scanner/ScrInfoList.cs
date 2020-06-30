/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrInfoList
Purpose:                                      Contains objects related to ScrInfoList
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScrInfoList : BaseModel
    {
        public long InfoListID { get; set; }
        public string InfoListDesc { get; set; }
        public byte InfoListPhoto { get; set; }
        public object CatalogTitle { get; set; }
    }
}
