﻿#region Copyright

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
// Program Name:                                 Organization
// Purpose:                                      Contains objects related to Organization
//==========================================================================================================

namespace M4PL.Entities.Organization
{
	/// <summary>
	///  Organization Class to create and maintain Organization Data
	/// </summary>
	public class Organization : BaseModel
	{
		/// <summary>
		/// Gets or Sets Organization Code e.g. MWWTG
		/// </summary>
		public string OrgCode { get; set; }
		/// <summary>
		/// Gets or Sets Org Title e.g. Meridian Worldwide Transportation Group
		/// </summary>
		public string OrgTitle { get; set; }
		/// <summary>
		/// Gets or Sets Organization group Id e.g. 68 for Home Delivery
		/// </summary>
		public int? OrgGroupId { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? OrgSortOrder { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public byte[] OrgDescription { get; set; }

		//public long? OrgContactId { get; set; }
		/// <summary>
		/// Gets or Sets Organization image/icon in varbinary format
		/// </summary>
		public byte[] OrgImage { get; set; }

		/// <summary>
		/// Gets or sets the Org's work address identifier.
		/// </summary>
		/// <value>
		/// The OrgWorkAddressId.
		/// </value>
		public long? OrgWorkAddressId { get; set; }
		/// <summary>
		/// Gets or Sets  Org's work address identifier's Name
		/// </summary>
		public string OrgWorkAddressIdName { get; set; }

		/// <summary>
		/// Gets or sets the Org's business address identifier.
		/// </summary>
		/// <value>
		/// The OrgBusinessAddressId.
		/// </value>
		public long? OrgBusinessAddressId { get; set; }
		/// <summary>
		/// Gets or sets the Org's business address identifier's Name
		/// </summary>
		public string OrgBusinessAddressIdName { get; set; }

		/// <summary>
		/// Gets or sets the Org's corporate address identifier.
		/// </summary>
		/// <value>
		/// The OrgCorporateAddressId.
		/// </value>
		public long? OrgCorporateAddressId { get; set; }
		/// <summary>
		/// Gets or sets the Org's corporate address identifier's Name
		/// </summary>
		public string OrgCorporateAddressIdName { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessAddress1
		/// </summary>
		public string BusinessAddress1 { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessAddress2
		/// </summary>
		public string BusinessAddress2 { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessCity
		/// </summary>
		public string BusinessCity { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessZipPostal
		/// </summary>
		public string BusinessZipPostal { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessStateId
		/// </summary>
		public int? BusinessStateId { get; set; }
		/// <summary>
		/// Gets or Sets BusinessStateId's Name
		/// </summary>
		public string BusinessStateIdName { get; set; }

		/// <summary>
		/// Gets Or Sets BusinessCountryId
		/// </summary>
		public int? BusinessCountryId { get; set; }
		/// <summary>
		/// Gets or Sets BusinessCountryId's Name
		/// </summary>
		public string BusinessCountryIdName { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateAddress1
		/// </summary>
		public string CorporateAddress1 { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateAddress2
		/// </summary>
		public string CorporateAddress2 { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateCity
		/// </summary>
		public string CorporateCity { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateZipPostal
		/// </summary>
		public string CorporateZipPostal { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateStateId
		/// </summary>
		public int? CorporateStateId { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateStateIdName
		/// </summary>
		public string CorporateStateIdName { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateCountryId
		/// </summary>
		public int CorporateCountryId { get; set; }

		/// <summary>
		/// Gets Or Sets CorporateCountryId
		/// </summary>
		public string CorporateCountryIdName { get; set; }

		/// <summary>
		/// Gets Or Sets WorkAddress1
		/// </summary>
		public string WorkAddress1 { get; set; }

		/// <summary>
		/// Gets Or Sets WorkAddress2
		/// </summary>
		public string WorkAddress2 { get; set; }

		/// <summary>
		/// Gets Or Sets WorkCity
		/// </summary>
		public string WorkCity { get; set; }

		/// <summary>
		/// Gets Or Sets WorkZipPostal
		/// </summary>
		public string WorkZipPostal { get; set; }

		/// <summary>
		/// Gets Or Sets WorkStateId
		/// </summary>
		public int? WorkStateId { get; set; }

		/// <summary>
		/// Gets Or Sets WorkStateIdName
		/// </summary>
		public string WorkStateIdName { get; set; }

		/// <summary>
		/// Gets Or Sets WorkCountryId
		/// </summary>
		public int WorkCountryId { get; set; }
		/// <summary>
		/// Gets Or Sets WorkCountryId's Name
		/// </summary>
		public string WorkCountryIdName { get; set; }
	}
}