/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SecurityByRole
Purpose:                                      Contains objects related to SecurityByRole
==========================================================================================================*/

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Entities for SecurityByRole will contain objects related to SecurityByRole
    /// </summary>
    public class SecurityByRole : BaseModel
    {
        /// <summary>
        /// Gets or sets the Organization identifier.
        /// </summary>
        /// <value>
        /// The Org identifier.
        /// </value>
        public long? OrgId { get; set; }

        public string OrgIdName { get; set; }

        public int? SecLineOrder { get; set; }

        /// <summary>
        /// Gets or sets the main module identifier.
        /// </summary>
        /// <value>
        /// The MainModule identifier.
        /// </value>
        public int? SecMainModuleId { get; set; }

        /// <summary>
        /// Gets or sets the MenuOptionLevel identifier.
        /// </summary>
        /// <value>
        /// The MenuOptionLevel identifier.
        /// </value>
        public int? SecMenuOptionLevelId { get; set; }

        /// <summary>
        /// Gets or sets the MenuAccessLevel identifier.
        /// </summary>
        /// <value>
        /// The MenuAccessLevel identifier.
        /// </value>
        public int? SecMenuAccessLevelId { get; set; }

        /// <summary>
        /// Sets the RoleCode on insert and Update of the Security by Role
        /// </summary>
        /// <value>
        /// The ActRole Code identifier.
        /// </value>
        public long OrgRefRoleId { get; set; }
        public string OrgRefRoleIdName { get; set; }
    }
}