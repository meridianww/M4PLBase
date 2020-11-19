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
// Program Name:                                 OrgRefRole
// Purpose:                                      Contains objects related to OrgRefRole
//==========================================================================================================

namespace M4PL.Entities.Organization
{
	/// <summary>
	/// Organization RefRole class to create default roles present within the organization
	/// Allows to create and maintain certain defined roles
	/// </summary>
	public class OrgRefRole : BaseModel
	{
		/// <summary>
		/// Gets or Sets Organization ID
		/// </summary>
		public long? OrgID { get; set; }
		/// <summary>
		/// Gets or Sets OrgID's Name
		/// </summary>
		public string OrgIDName { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? OrgRoleSortOrder { get; set; }
		/// <summary>
		/// Gets or Sets Org Role Code e.g. SYSADMN
		/// </summary>
		public string OrgRoleCode { get; set; }
		/// <summary>
		/// Gets or Sets if default role or not
		/// </summary>
		public bool OrgRoleDefault { get; set; }
		/// <summary>
		/// Gets or Sets Role Title e.g. System Administrator
		/// </summary>
		public string OrgRoleTitle { get; set; }

		//public long? OrgRoleContactID { get; set; }
		//public string OrgRoleContactIDName { get; set; }
		/// <summary>
		/// Gets or Sets Role Type ID (From SYSTM000Ref_Options)
		/// </summary>
		public int? RoleTypeId { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public byte[] OrgRoleDescription { get; set; }
		/// <summary>
		/// Gets or Sets Org Comments
		/// </summary>
		public byte[] OrgComments { get; set; }
		/// <summary>
		/// Gets or Sets Flag for Job Default Analyst
		/// </summary>
		public bool PrxJobDefaultAnalyst { get; set; }
		/// <summary>
		/// Gets or Sets Flag for Job Default Responsible
		/// </summary>
		public bool PrxJobDefaultResponsible { get; set; }
		/// <summary>
		/// Gets or Sets Flag for Job Gateway Default Analyst
		/// </summary>
		public bool PrxJobGWDefaultAnalyst { get; set; }
		/// <summary>
		/// Gets or Sets Flag for Job Gateway Default Responsible
		/// </summary>
		public bool PrxJobGWDefaultResponsible { get; set; }
	}
}