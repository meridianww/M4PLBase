#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ScrOsdList
// Purpose:                                      Contains objects related to ScrOsdList
//==========================================================================================================

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