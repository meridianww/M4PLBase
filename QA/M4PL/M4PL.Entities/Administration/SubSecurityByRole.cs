/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SubSecurityByRole
Purpose:                                      Contains objects related to SubSecurityByRole
==========================================================================================================*/

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Entities for SubSecurityByRole will contain objects related to SubSecurityByRole
    /// </summary>
    public class SubSecurityByRole : BaseModel
    {
        public long? SecByRoleId { get; set; }
        public string RefTableName { get; set; }
        public int SubsMenuOptionLevelId { get; set; }
        public int SubsMenuAccessLevelId { get; set; }
    }
}