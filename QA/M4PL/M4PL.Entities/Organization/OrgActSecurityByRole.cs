/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSecurityByRole
Purpose:                                      Contains objects related to OrgActSecurityByRole
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    /// Entities for OrgActSecurityByRole will contain objects related to OrgActSecurityByRole
    /// </summary>
    public class OrgActSecurityByRole : BaseModel
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
        public long OrgActRoleId { get; set; }
        public string OrgActRoleIdName { get; set; }

        /// <summary>
        /// Sets the RoleCode on insert and Update of the Security by Role
        /// </summary>
        /// <value>
        /// The ActRole Code identifier.
        /// </value>
        public long ContactId { get; set; }
        public string ContactIdName { get; set; }
    }
}