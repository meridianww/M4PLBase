/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              10/10/2017
Program Name:                                 OrgRole
Purpose:                                      Contains objects related to OrgRole
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class OrgRole : BaseModel
    {
        public long OrgID { get; set; }
        public string OrgRoleCode { get; set; }
        public string OrgRoleTitle { get; set; }
        public bool OrgRoleDefault { get; set; }
    }
}