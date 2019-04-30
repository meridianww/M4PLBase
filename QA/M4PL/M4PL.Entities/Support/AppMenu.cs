/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 AppMenu
Purpose:                                      Contains objects related to AppMenu
==========================================================================================================*/

using System;
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// App Menu class provides the additional information related to Menu driver
    /// </summary>
    public class AppMenu : SysRefModel
    {
        public AppMenu()
        {
            Children = new List<AppMenu>();
        }

        /// <summary>
        /// Gets or sets the lang name.
        /// </summary>
        /// <value>
        /// The LangName.
        /// </value>
        public string LangName { get; set; }

        /// <summary>
        /// Gets or sets the menu position.
        /// </summary>
        /// <value>
        /// The BreakDownStructure.
        /// </value>
        public string BreakDownStructure { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The Title.
        /// </value>
        public string Title { get; set; }

        /// <summary>
        /// Gets or sets the referred table name.
        /// </summary>
        /// <value>
        /// The SysRefTableName.
        /// </value>
        public string SysRefTableName { get; set; }

        /// <summary>
        /// Gets or sets the icon -very small.
        /// </summary>
        /// <value>
        /// The VerySmallIcon.
        /// </value>
        public byte[] VerySmallIcon { get; set; }

        /// <summary>
        /// Gets or sets the icon-small.
        /// </summary>
        /// <value>
        /// The SmallIcon.
        /// </value>
        public byte[] SmallIcon { get; set; }

        /// <summary>
        /// Gets or sets the icon-medium.
        /// </summary>
        /// <value>
        /// The MediumIcon.
        /// </value>
        public byte[] MediumIcon { get; set; }

        /// <summary>
        /// Gets or sets the type of program.
        /// </summary>
        /// <value>
        /// The ExecuteProgram.
        /// </value>
        public string ExecuteProgram { get; set; }

        /// <summary>
        /// Gets or sets the menu option level identifier.
        /// </summary>
        /// <value>
        /// The MenuOptionLevelId.
        /// </value>
        public int MenuOptionLevelId { get; set; }

        /// <summary>
        /// Gets or sets the menu access level identifier.
        /// </summary>
        /// <value>
        /// The MenuAccessLevelId.
        /// </value>
        public int MenuAccessLevelId { get; set; }

        /// <summary>
        /// Gets or sets the menu program type identifier.
        /// </summary>
        /// <value>
        /// The MenuProgramTypeId.
        /// </value>
        public int MenuProgramTypeId { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public string MenuTabOver { get; set; }

        public MvcRoute Route
        {
            get
            {
                var route = new MvcRoute { Action = ExecuteProgram, Area = SysRefName };
                if (!string.IsNullOrEmpty(SysRefTableName) && Enum.IsDefined(typeof(EntitiesAlias), SysRefTableName))
                    route.Entity = (EntitiesAlias)Enum.Parse(typeof(EntitiesAlias), SysRefTableName);
                return route;
            }

            set
            {
                ExecuteProgram = value.Action;
                SysRefTableName = value.Entity.ToString();
                SysRefName = value.Area;
            }
        }

        public bool IsEnabled { get; set; }
        public IList<AppMenu> Children { get; set; }
    }
}