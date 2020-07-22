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
// Program Name:                                 UserColumnSettings
// Purpose:                                      Contains objects related to UserColumnSettings
//==========================================================================================================

namespace M4PL.Entities.Support
{
    /// <summary>
    ///
    /// </summary>
    public class UserColumnSettings
    {
        public UserColumnSettings()
        {
            ColSortOrder = string.Empty;
            ColNotVisible = string.Empty;
            ColIsFreezed = string.Empty;
            ColIsDefault = string.Empty;
            ColGroupBy = string.Empty;
            ColGridLayout = string.Empty;
        }

        public long? ColUserId { get; set; }
        public string ColTableName { get; set; }
        public string ColSortOrder { get; set; }
        public string ColNotVisible { get; set; }
        public string ColIsFreezed { get; set; }
        public string ColIsDefault { get; set; }
        public string ColGroupBy { get; set; }
        public string ColGridLayout { get; set; }
    }
}