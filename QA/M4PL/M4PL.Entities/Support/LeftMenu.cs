/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 LeftMenu
Purpose:                                      Contains objects related to LeftMenu
==========================================================================================================*/
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class LeftMenu
    {
        public LeftMenu()
        {
            Children = new List<LeftMenu>();
        }

        public long Id { get; set; }

        /// <summary>
        /// Gets or sets the lang name.
        /// </summary>
        /// <value>
        /// The LangName.
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
        /// Gets or sets the menu option level identifier.
        /// </summary>
        /// <value>
        /// The MnuOptionLevelId.
        /// </value>
        public int MnuOptionLevelId { get; set; }

        /// <summary>
        /// Gets or sets the menu access level identifier.
        /// </summary>
        /// <value>
        /// The MnuAccessLevelId.
        /// </value>
        public int MnuAccessLevelId { get; set; }

        /// <summary>
        /// Gets or sets the menu program type identifier.
        /// </summary>
        /// <value>
        /// The MnuProgramTypeId.
        /// </value>
        public int MnuProgramTypeId { get; set; }

        public string MnuHelpBookMark { get; set; }

        public int MnuHelpPageNumber { get; set; }

        public int StatusId { get; set; }

        public IList<LeftMenu> Children { get; set; }

        public MvcRoute Route { get; set; }
    }
}