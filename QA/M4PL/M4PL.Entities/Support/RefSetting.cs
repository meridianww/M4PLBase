#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model class for User level Settings
    /// </summary>
    public class RefSetting
    {
        /// <summary>
        /// Gets or Sets Entity type as Enum e.g. 2 for Contact
        /// </summary>
        public EntitiesAlias Entity { get; set; }
        /// <summary>
        /// Gets or Sets Entity Name e.g. Contact
        /// </summary>
        public string EntityName { get; set; }
        /// <summary>
        /// Gets or Sets Name of Setting e.g. SysPageSize for Page Size
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// Gets or Sets Value of Setting e.g. 50 for SysPageSize
        /// </summary>
        public string Value { get; set; }
        /// <summary>
        /// Gets or Sets Type of value e.g. string
        /// </summary>
        public string ValueType { get; set; }
        /// <summary>
        /// Gets or Sets flag if the setting can be overWritten
        /// </summary>
        public bool IsOverWritable { get; set; }
        /// <summary>
        /// Gets or Sets if the User is System Admin
        /// </summary>
        public bool IsSysAdmin { get; set; }

    }
}
