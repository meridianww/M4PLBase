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
// Program Name:                                 SubSecurityByRole
// Purpose:                                      Contains objects related to SubSecurityByRole
//==========================================================================================================

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