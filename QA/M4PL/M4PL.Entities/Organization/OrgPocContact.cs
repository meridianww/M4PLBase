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
// Program Name:                                 OrgPocContact
// Purpose:                                      Contains objects related to OrgPocContact
//==========================================================================================================

namespace M4PL.Entities.Organization
{
	/// <summary>
	/// Model Class for Org POC Contact
	/// </summary>
	public class OrgPocContact : BaseModel
	{
		/// <summary>
		/// Gets or Sets OrgId of Contact
		/// </summary>
		public long ConOrgId { get; set; }
		/// <summary>
		/// Gets or Sets Org Name of ContactID
		/// </summary>
		public string ConOrgIdName { get; set; }

		/// <summary>
		/// Contact Master ID (Can create POC contact without any associated contact)
		/// </summary>
		public long? ContactMSTRID { get; set; }
		/// <summary>
		/// Gets or Sets Contact Master Id's Name
		/// </summary>
		public string ContactMSTRIDName { get; set; }
		/// <summary>
		/// Gets or Sets Contact Code Id
		/// </summary>
		public long? ConCodeId { get; set; }
		/// <summary>
		/// Gets or Sets Contact's Code Id's Name
		/// </summary>
		public string ConCodeIdName { get; set; }
		/// <summary>
		/// Gets or Sets Contact Title
		/// </summary>
		public string ConTitle { get; set; }
		/// <summary>
		/// Gets or Sets Contact Table Type Identifier
		/// </summary>
		public int? ConTableTypeId { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public long? Description { get; set; }
		/// <summary>
		/// Gets or Sets Instructions
		/// </summary>
		public long? Instructions { get; set; }
		/// <summary>
		/// Gets or Sets If the contact is default
		/// </summary>
		public bool ConIsDefault { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? ConItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets Contact's Company ID
		/// </summary>
		public long ConCompanyId { get; set; }
	}
}