/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrReturnReasonList
Purpose:                                      Contains objects related to ScrReturnReasonList
==========================================================================================================*/
namespace M4PL.Entities.Scanner
{
    public class ScrReturnReasonList : BaseModel
    {
        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }
        public int? ReturnReasonLineItem { get; set; }
        public string ReturnReasonCode { get; set; }
        public string ReturnReasonTitle { get; set; }
        public byte[] ReturnReasonDesc { get; set; }
    }
}