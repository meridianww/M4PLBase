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
// Program Name:                                 PrgRole
// Purpose:                                      Contains objects related to PrgRole
//==========================================================================================================

namespace M4PL.Entities.Program
{
	/// <summary>
	///
	/// </summary>
	public class PrgRole : BaseModel
	{
		/// <summary>
		/// Gets or sets the organization identifier.
		/// </summary>
		/// <value>
		/// The organization identifier.
		/// </value>
		public long? OrgID { get; set; }
		/// <summary>
		/// Gets or Sets Organization Identifier's Name
		/// </summary>
		public string OrgIDName { get; set; }

		/// <summary>
		/// Gets or sets the program identifier.
		/// </summary>
		/// <value>
		/// The program identifier.
		/// </value>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or sets the program identifier's Name
		/// </summary>
		public string ProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the sorting order.
		/// </summary>
		/// <value>
		/// The PrgRoleSortOrder.
		/// </value>
		public int? PrgRoleSortOrder { get; set; }

		/// <summary>
		/// Gets or sets the type of role.
		/// </summary>
		/// <value>
		/// The OrgRoleId.
		/// </value>
		public long? OrgRefRoleId { get; set; }

		/// <summary>
		/// Gets or sets the type of role Code for Griddata display.
		/// </summary>
		/// <value>
		/// The OrgRoleIdName.
		/// </value>
		public string OrgRefRoleIdName { get; set; }

		/// <summary>
		/// Gets or sets the role of program.
		/// </summary>
		/// <value>
		/// The PrgRoleId.
		/// </value>
		public long? PrgRoleId { get; set; }

		/// <summary>
		/// Gets or sets the role code of program for grid data Display.
		/// </summary>
		/// <value>
		/// The PrgRoleIdName.
		/// </value>
		public string PrgRoleIdName { get; set; }

		/// <summary>
		/// Gets or sets the title.
		/// </summary>
		/// <value>
		/// The PrgRoleTitle.
		/// </value>
		public string PrgRoleTitle { get; set; }

		/// <summary>
		/// Gets or sets the contact identifier.
		/// </summary>
		/// <value>
		/// The PrgRoleContactID.
		/// </value>
		public long? PrgRoleContactID { get; set; }
		/// <summary>
		/// Gets or Sets Contact Idenfier's Name
		/// </summary>
		public string PrgRoleContactIDName { get; set; }

		/// <summary>
		/// Gets or sets the role type identifier.
		/// </summary>
		/// <value>
		/// The RoleTypeId.
		/// </value>
		public int? RoleTypeId { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The PrgRoleDescription.
		/// </value>
		public byte[] PrgRoleDescription { get; set; }

		/// <summary>
		/// Gets or sets the comment.
		/// </summary>
		/// <value>
		/// The PrgComments.
		/// </value>
		public byte[] PrgComments { get; set; }

		public string ProgramRoleCode { get; set; }
		/// <summary>
		/// Gets or Sets Flag if the role is Job Default Analyst
		/// </summary>
		public bool PrxJobDefaultAnalyst { get; set; }
		/// <summary>
		/// Gets or Sets Flag if the role is Job Default Responsible 
		/// </summary>
		public bool PrxJobDefaultResponsible { get; set; }
		/// <summary>
		/// Gets or Sets Flag if the role is Job Gateway Default Analyst
		/// </summary>
		public bool PrxJobGWDefaultAnalyst { get; set; }
		/// <summary>
		/// Gets or Sets Flag if the role is Job Gateway Default Responsible
		/// </summary>
		public bool PrxJobGWDefaultResponsible { get; set; }
	}
}