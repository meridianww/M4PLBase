/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdReasonList
Purpose:                                      Contains objects related to ScrOsdReasonList
==========================================================================================================*/
namespace M4PL.Entities.Scanner
{
    public class ScrOsdReasonList : BaseModel
    {
        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }
        public int? ReasonItemNumber { get; set; }
        public string ReasonIDCode { get; set; }
        public string ReasonTitle { get; set; }
        public byte[] ReasonDesc { get; set; }
    }
}