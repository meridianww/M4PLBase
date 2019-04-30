﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 UserColumnSettings
Purpose:                                      Contains objects related to UserColumnSettings
==========================================================================================================*/

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