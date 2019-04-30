/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              10/10/2017
Program Name:                                 ProgramRole
Purpose:                                      Contains objects related to ProgramRole
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class ProgramRole : BaseModel
    {
        public long ProgramID { get; set; }
        public string PrgRoleCode { get; set; }
        public string PrgRoleTitle { get; set; }
    }
}