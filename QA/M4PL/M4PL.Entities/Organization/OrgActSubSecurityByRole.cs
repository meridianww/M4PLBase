/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSubSecurityByRole
Purpose:                                      Contains objects related to OrgActSubSecurityByRole
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    /// Entities for OrgActSubSecurityByRole will contain objects related to OrgActSubSecurityByRole
    /// </summary>
    public class OrgActSubSecurityByRole : BaseModel
    {
        public long? SecByRoleId { get; set; }
        public string RefTableName { get; set; }
        public int SubsMenuOptionLevelId { get; set; }
        public int SubsMenuAccessLevelId { get; set; }
    }
}