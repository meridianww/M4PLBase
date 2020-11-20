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
    /// Model for UserColumnSettings
    /// </summary>
    public class UserColumnSettings
    {
        /// <summary>
        /// Constructor of UserColumnSettings
        /// </summary>
        public UserColumnSettings()
        {
            ColSortOrder = string.Empty;
            ColNotVisible = string.Empty;
            ColIsFreezed = string.Empty;
            ColIsDefault = string.Empty;
            ColGroupBy = string.Empty;
            ColGridLayout = string.Empty;
        }
        /// <summary>
        /// Get or Set for column user Id
        /// </summary>
        public long? ColUserId { get; set; }
        /// <summary>
        /// Get or Set for column user table
        /// </summary>
        public string ColTableName { get; set; }
        /// <summary>
        /// Get or Set for column sort order
        /// </summary>
        public string ColSortOrder { get; set; }
        /// <summary>
        /// Get or Set for column is visible or not
        /// </summary>
        public string ColNotVisible { get; set; }
        /// <summary>
        /// Get or Set for column is frezed or not
        /// </summary>
        public string ColIsFreezed { get; set; }
        /// <summary>
        /// Get or Set for column is default or not
        /// </summary>
        public string ColIsDefault { get; set; }
        /// <summary>
        /// Get or Set for column group by
        /// </summary>
        public string ColGroupBy { get; set; }
        /// <summary>
        /// Get or Set for column gr id layout
        /// </summary>
        public string ColGridLayout { get; set; }
    }
}