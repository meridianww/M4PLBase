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
// Date Programmed:                              09/25/2018
// Program Name:                                 CustDcLocationContact
// Purpose:                                      Contains objects related to CustDcLocationContact
//==========================================================================================================

namespace M4PL.Entities.Customer
{
	/// <summary>
	/// Model class for Customer DC Location Contacts
	/// </summary>
	public class CustDcLocationContact : BaseModel
	{
		/// <summary>
		/// Gets or Sets ConPrimary RecordId
		/// </summary>
		public long? ConPrimaryRecordId { get; set; }
		/// <summary>
		/// Gets or Sets ConItem Number/Sorting Order
		/// </summary>
		public int? ConItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets ConCode Id
		/// </summary>
		public long? ConCodeId { get; set; }
		/// <summary>
		/// Gets or Sets ConCodeId Name
		/// </summary>
		public string ConCodeIdName { get; set; }
		/// <summary>
		/// Gets or Sets ConFirst Name
		/// </summary>
		public string ConFirstName { get; set; }
		/// <summary>
		/// Gets or Sets ConMiddle Name
		/// </summary>
		public string ConMiddleName { get; set; }
		/// <summary>
		/// Gets or Sets ConLast Name
		/// </summary>
		public string ConLastName { get; set; }
		/// <summary>
		/// Gets or Sets ConType Id
		/// </summary>
		public int? ConTypeId { get; set; }
		/// <summary>
		/// Gets or Sets ConOrg Id
		/// </summary>
		public long ConOrgId { get; set; }
		/// <summary>
		/// Gets or Sets ConOrgI dName
		/// </summary>
		public string ConOrgIdName { get; set; }


		/// <summary>
		/// Gets or sets the contact's Organization Code.
		/// </summary>
		public string ConCompany { get; set; }
		/// <summary>
		/// Gets or Sets Contact Title Id
		/// </summary>
		public int? ConTitleId { get; set; }
		/// <summary>
		/// Gets or Sets Contact Title
		/// </summary>
		public string ConTitle { get; set; }

		/// <summary>
		/// Gets or sets the contact's Organization Code.
		/// </summary>
		public long? ContactMSTRID { get; set; }
		/// <summary>
		/// Gets or Sets Contact MSTRID Name
		/// </summary>
		public string ContactMSTRIDName { get; set; }
		/// <summary>
		/// Gets or Sets Contact Table Type Id
		/// </summary>
		public int? ConTableTypeId { get; set; }

		/// <summary>
		/// Gets or sets the contact's email address.
		/// </summary>
		/// <value>
		/// The ConEmailAddress.
		/// </value>
		public string ConEmailAddress { get; set; }

		/// <summary>
		/// Gets or sets the contact's secondary email address.
		/// </summary>
		/// <value>
		/// The ConEmailAddress2.
		/// </value>
		public string ConEmailAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets Customer Type
		/// </summary>
		public string CustomerType { get; set; }

		/// <summary>
		/// Gets or sets the contact's mobile number.
		/// </summary>
		/// <value>
		/// The ConMobilePhone.
		/// </value>
		public string ConMobilePhone { get; set; }

		/// <summary>
		/// Gets or sets the contact's business phone number.
		/// </summary>
		/// <value>
		/// The ConBusinessPhone.
		/// </value>
		public string ConBusinessPhone { get; set; }

		/// <summary>
		/// Gets or sets the extension number, when the business phone number is provided.
		/// </summary>
		/// <value>
		/// The ConBusinessPhoneExt.
		/// </value>
		public string ConBusinessPhoneExt { get; set; }

		/// <summary>
		/// Gets or sets the contact's job title.
		/// </summary>
		/// <value>
		/// The ConJobTitle.
		/// </value>
		public string ConJobTitle { get; set; }

		/// <summary>
		/// Gets or sets the contact's business address.
		/// </summary>
		/// <value>
		/// The ConBusinessAddress1.
		/// </value>
		public string ConBusinessAddress1 { get; set; }

		/// <summary>
		/// Gets or sets the contact's secondary business adddress.
		/// </summary>
		/// <value>
		/// The ConBusinessAddress2.
		/// </value>
		public string ConBusinessAddress2 { get; set; }

		/// <summary>
		/// Gets or sets the contact's business city.
		/// </summary>
		/// <value>
		/// The ConBusinessCity.
		/// </value>
		public string ConBusinessCity { get; set; }

		/// <summary>
		/// Gets or sets the contact's buiness state province.
		/// </summary>
		/// <value>
		/// The ConBusinessStateProvince.
		/// </value>

		public int? ConBusinessStateId { get; set; }
		/// <summary>
		/// Gets or Sets ConBusiness StateId Name
		/// </summary>
		public string ConBusinessStateIdName { get; set; }

		/// <summary>
		/// Gets or sets the contact's business zip postal.
		/// </summary>
		/// <value>
		/// The ConBusinessZipPostal.
		/// </value>
		public string ConBusinessZipPostal { get; set; }

		/// <summary>
		/// Gets or sets the contact's business conuntry region.
		/// </summary>
		/// <value>
		/// The ConBusinessCountryRegion.
		/// </value>

		public int? ConBusinessCountryId { get; set; }
		/// <summary>
		/// Gets or Sets ConBusiness CountryId Name
		/// </summary>
		public string ConBusinessCountryIdName { get; set; }
		/// <summary>
		/// Gets or Sets Business Address
		/// </summary>
		public string BusinessAddress { get; set; }

		/// <summary>
		/// Gets or sets the contact's fullname.
		/// </summary>
		/// <value>
		/// The ConFullName.
		/// </value>

		public string ConFullName { get; set; }
		/// <summary>
		/// Gets or Sets Contact Company Id
		/// </summary>
		public long? ConCompanyId { get; set; }
		/// <summary>
		/// Gets or Sets Contact Company Id Name
		/// </summary>
		public string ConCompanyIdName { get; set; }
	}
}