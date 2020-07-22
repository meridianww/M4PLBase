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
// Program Name:                                 AppMenu
// Purpose:                                      Contains objects related to AppMenu
//==========================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// App Menu class provides the additional information related to Menu driver
    /// </summary>
    public class RibbonMenu
    {
        public RibbonMenu()
        {
            Children = new List<RibbonMenu>();
        }

        public long Id { get; set; }

        /// <summary>
        /// Gets or sets the MnuModuleId
        /// </summary>
        /// <value>
        /// The MnuModuleId.
        /// </value>
        public int MnuModuleId { get; set; }

        /// <summary>
        /// Gets or sets the referred table name.
        /// </summary>
        /// <value>
        /// The MnuTableName.
        /// </value>
        public string MnuTableName { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The Title.
        /// </value>
        public string MnuTitle { get; set; }

        /// <summary>
        /// Gets or sets the menu position.
        /// </summary>
        /// <value>
        /// The BreakDownStructure.
        /// </value>
        public string MnuBreakDownStructure { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public string MnuTabOver { get; set; }

        /// <summary>
        /// Gets or sets the icon -very small.
        /// </summary>
        /// <value>
        /// The VerySmallIcon.
        /// </value>
        public byte[] MnuIconVerySmall { get; set; }

        /// <summary>
        /// Gets or sets the icon-medium.
        /// </summary>
        /// <value>
        /// The MediumIcon.
        /// </value>
        public byte[] MnuIconMedium { get; set; }

        /// <summary>
        /// Gets or sets the type of program.
        /// </summary>
        /// <value>
        /// The ExecuteProgram.
        /// </value>
        public string MnuExecuteProgram { get; set; }

        /// <summary>
        /// Gets or sets the menu access level identifier.
        /// </summary>
        /// <value>
        /// The MnuAccessLevelId.
        /// </value>
        public int MnuAccessLevelId { get; set; }

        /// <summary>
        /// Gets or sets the menu option level identifier.
        /// </summary>
        /// <value>
        /// The MnuOptionLevelId.
        /// </value>
        public int MnuOptionLevelId { get; set; }

        public int StatusId { get; set; }

        public IList<RibbonMenu> Children { get; set; }

        public MvcRoute Route { get; set; }
    }
}