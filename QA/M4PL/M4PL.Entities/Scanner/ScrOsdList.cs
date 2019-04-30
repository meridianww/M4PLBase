/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdList
Purpose:                                      Contains objects related to ScrOsdList
==========================================================================================================*/
using System.Text;

namespace M4PL.Entities.Scanner
{
    public class ScrOsdList : BaseModel
    {
        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }
        public int? OSDItemNumber { get; set; }
        public string OSDCode { get; set; }
        public string OSDTitle { get; set; }
        public string OSDType { get; set; }
        public string OSDNote { get; set; }
    }
}