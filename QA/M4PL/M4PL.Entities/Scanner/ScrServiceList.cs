/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrServiceList
Purpose:                                      Contains objects related to ScrServiceList
==========================================================================================================*/
namespace M4PL.Entities.Scanner
{
    public class ScrServiceList : BaseModel
    {
        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }
        public int? ServiceLineItem { get; set; }
        public string ServiceCode { get; set; }
        public string ServiceTitle { get; set; }
        public byte[] ServiceDescription { get; set; }
    }
}