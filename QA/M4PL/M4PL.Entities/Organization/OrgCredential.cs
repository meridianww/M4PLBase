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
// Program Name:                                 OrgCredential
// Purpose:                                      Contains objects related to OrgCredential
//==========================================================================================================

using System;

namespace M4PL.Entities.Organization
{
	/// <summary>
	/// Organization Credential Class to create and maintain Credential details withing the Organization
	/// Includes templates, business charters, insurance, policies and procedures
	/// </summary>
	public class OrgCredential : BaseModel
	{
		/// <summary>
		/// Gets or Sets Org ID
		/// </summary>
		public long? OrgID { get; set; }
		/// <summary>
		/// Gets or Sets Org Identifier's Name
		/// </summary>
		public string OrgIDName { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? CreItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets Credential Code e.g. CRED03
		/// </summary>
		public string CreCode { get; set; }
		/// <summary>
		/// Gets or Sets Credential Title e.g. Credentials Details
		/// </summary>

		public string CreTitle { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public byte[] CreDescription { get; set; }
		/// <summary>
		/// Gets or Sets Credentials Expiry Date
		/// </summary>
		public DateTime? CreExpDate { get; set; }

		/// <summary>
		/// To get the attachment count for current entity
		/// </summary>
		public int? AttachmentCount { get; set; }
	}
}