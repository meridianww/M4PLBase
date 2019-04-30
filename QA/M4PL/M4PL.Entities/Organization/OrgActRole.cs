/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgActRole
Purpose:                                      Contains objects related to OrgActRole
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    ///  Organization ActRole sets the roles and responsibilities for the specfic role of an organization
    /// </summary>
    public class OrgActRole : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier.
        /// </summary>
        /// <value>
        /// The Organization identifier.
        /// </value>
        public long? OrgID { get; set; }

        public string OrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the Sorting order.
        /// </summary>
        /// <value>
        /// The OrgRoleSortOrder.
        /// </value>
        public int? OrgRoleSortOrder { get; set; }

        /// <summary>
        /// Gets or sets the type of role.
        /// </summary>
        /// <value>
        /// The RoleId.
        /// </value>
        public long? OrgRefRoleId { get; set; }

        /// <summary>
        /// Gets or sets the Active Role for specified Role Code  on grid data display
        /// </summary>
        /// <value>
        /// The RoleIdName.
        /// </value>
        public string OrgRefRoleIdName { get; set; }

        /// <summary>
        /// Gets or sets the role as default.
        /// </summary>
        /// <value>
        /// The OrgRoleDefault.
        /// </value>
        public bool OrgRoleDefault { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The OrgRoleTitle.
        /// </value>
        public string OrgRoleTitle { get; set; }

        /// <summary>
        /// Gets or sets the contact Identifier.
        /// </summary>
        /// <value>
        /// The OrgRoleContactID.
        /// </value>
        public long? OrgRoleContactID { get; set; }

        public string OrgRoleContactIDName { get; set; }

        /// <summary>
        /// Gets or sets the type of role.
        /// </summary>
        /// <value>
        /// The RoleTypeId.
        /// </value>
        public int? RoleTypeId { get; set; }

        /// <summary>
        /// Gets or sets the role description.
        /// </summary>
        /// <value>
        /// The OrgRoleDescription.
        /// </value>
        public byte[] OrgRoleDescription { get; set; }

        /// <summary>
        /// Gets or sets the comments.
        /// </summary>
        /// <value>
        /// The OrgComments.
        /// </value>
        public byte[] OrgComments { get; set; }

       
        /// <summary>
        /// Gets or sets the project job default analyst.
        /// </summary>
        /// <value>
        /// The PrxJobDefaultAnalyst.
        /// </value>
        public bool PrxJobDefaultAnalyst { get; set; }

        public bool PrxJobDefaultResponsible { get; set; }

        /// <summary>
        /// Gets or sets the job default analyst.
        /// </summary>
        /// <value>
        /// The PrxJobGWDefaultAnalyst.
        /// </value>
        public bool PrxJobGWDefaultAnalyst { get; set; }

        /// <summary>
        /// Gets or sets the Default reponsible.
        /// </summary>
        /// <value>
        /// The PrxJobGWDefaultResponsible.
        /// </value>
        public bool PrxJobGWDefaultResponsible { get; set; }

        public int? PreviousStatusId { get; set; }
    }
}