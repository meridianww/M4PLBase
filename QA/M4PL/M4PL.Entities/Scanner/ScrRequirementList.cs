/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrRequirementList
Purpose:                                      Contains objects related to ScrRequirementList
==========================================================================================================*/
namespace M4PL.Entities.Scanner
{
    public class ScrRequirementList : BaseModel
    {
        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }
        public int? RequirementLineItem { get; set; }
        public string RequirementCode { get; set; }
        public string RequirementTitle { get; set; }
        public byte[] RequirementDesc { get; set; }
    }
}