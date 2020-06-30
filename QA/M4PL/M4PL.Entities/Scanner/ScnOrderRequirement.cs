/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderRequirement
Purpose:                                      Contains objects related to ScnOrderRequirement
==========================================================================================================*/

namespace M4PL.Entities.Scanner
{
    public class ScnOrderRequirement : BaseModel
    {
        public long? RequirementID { get; set; }
        public string RequirementCode { get; set; }
        public long? JobID { get; set; }
        public string Notes { get; set; }
        public string Complete { get; set; }
    }
}
