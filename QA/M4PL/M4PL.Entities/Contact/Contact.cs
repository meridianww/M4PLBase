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
// Program Name:                                 Contact
// Purpose:                                      Contains objects related to Contact
//==========================================================================================================

namespace M4PL.Entities.Contact
{
    /// <summary>
    /// Contact class to add, edit and store the contacts for the system entities
    /// </summary>
    public class Contact : BaseModel
    {
        /// <summary>
        /// Gets or sets the  ERP(Entreprise resource planning)identifier.
        /// </summary>
        /// <value>
        /// The ERP identifier.
        /// </value>
        public string ConERPId { get; set; }


        /// <summary>
        /// Gets or sets contact Organization Id to which the contact has to be associated.
        /// </summary>
        /// <value>
        /// The ConOrgId.
        /// </value>
        public long ConOrgId { get; set; }

        ///// <summary>
        ///// Gets or sets contact name to which the contact has to be associated.
        ///// </summary>
        ///// <value>
        ///// The ConOrgIdName.
        ///// </value>
        public string ConOrgIdName { get; set; }
        public long? JobId { get; set; }
        /// <summary>
        /// Gets or sets the contact title.
        /// </summary>
        /// <value>
        /// The ConTitle identifier.
        /// </value>
        public int? ConTitleId { get; set; }


        /// <summary>
        /// Gets or sets the contact title.
        /// </summary>
        /// <value>
        /// The ConCompanyName identifier.
        /// </value>
        public string ConCompanyName { get; set; }


        /// <summary>
        /// Gets or sets the contact's firstname.
        /// </summary>
        /// <value>
        /// The ConFirstName.
        /// </value>
        public string ConFirstName { get; set; }

        /// <summary>
        /// Gets or sets the contact's middle name.
        /// </summary>
        /// <value>
        /// The ConMiddleName.
        /// </value>
        public string ConMiddleName { get; set; }

        /// <summary>
        /// Gets or sets the contact's lastname.
        /// </summary>
        /// <value>
        /// The ConLastName.
        /// </value>
        public string ConLastName { get; set; }

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
        /// Gets or sets the contact image.
        /// </summary>
        /// <value>
        /// The ConImage.
        /// </value>
        public byte[] ConImage { get; set; }

        /// <summary>
        /// Gets or sets the contact's job title.
        /// </summary>
        /// <value>
        /// The ConJobTitle.
        /// </value>
        public string ConJobTitle { get; set; }

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
        /// Gets or sets the contact's home phone number.
        /// </summary>
        /// <value>
        /// The ConHomePhone.
        /// </value>
        public string ConHomePhone { get; set; }

        /// <summary>
        /// Gets or sets the contact's mobile number.
        /// </summary>
        /// <value>
        /// The ConMobilePhone.
        /// </value>
        public string ConMobilePhone { get; set; }

        /// <summary>
        /// Gets or sets the contact's fax number.
        /// </summary>
        /// <value>
        /// The ConFaxNumber.
        /// </value>
        public string ConFaxNumber { get; set; }

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
        public string ConBusinessCountryIdName { get; set; }

        /// <summary>
        /// Gets or sets the contact's home address.
        /// </summary>
        /// <value>
        /// The ConHomeAddress1.
        /// </value>

        public string ConHomeAddress1 { get; set; }

        /// <summary>
        /// Gets or sets the contact's secondary home address.
        /// </summary>
        /// <value>
        /// The ConHomeAddress2.
        /// </value>

        public string ConHomeAddress2 { get; set; }

        /// <summary>
        /// Gets or sets the contact's home city.
        /// </summary>
        /// <value>
        /// The ConHomeCity.
        /// </value>

        public string ConHomeCity { get; set; }

        /// <summary>
        /// Gets or sets the contact's home state province.
        /// </summary>
        /// <value>
        /// The ConHomeStateProvince.
        /// </value>

        public int? ConHomeStateId { get; set; }
        public string ConHomeStateIdName { get; set; }

        /// <summary>
        /// Gets or sets the contact's home zip postal.
        /// </summary>
        /// <value>
        /// The ConHomeZipPostal.
        /// </value>

        public string ConHomeZipPostal { get; set; }

        /// <summary>
        /// Gets or sets the contact's home country region.
        /// </summary>
        /// <value>
        /// The ConHomeCountryRegion.
        /// </value>

        public int? ConHomeCountryId { get; set; }

        /// <summary>
        /// Gets or sets the count of documents assocaited to the contact.
        /// </summary>
        /// <value>
        /// The ConAttachments.
        /// </value>

        public int? ConAttachments { get; set; }
        /// <summary>
        /// Gets or sets the contact's web page.
        /// </summary>
        /// <value>
        /// The ConWebPage.
        /// </value>

        public string ConWebPage { get; set; }

        /// <summary>
        /// Gets or sets the contact's notes.
        /// </summary>
        /// <value>
        /// The ConNotes.
        /// </value>

        public string ConNotes { get; set; }

        /// <summary>
        /// Gets or sets the type of contact identifier.
        /// </summary>
        /// <value>
        /// The ConType identifier.
        /// </value>

        public int? ConTypeId { get; set; }

        /// <summary>
        /// Gets or sets the type of contact identifier.
        /// </summary>
        /// <value>
        /// The ConTypeIdName identifier.
        /// </value>

        public string ConTypeIdName { get; set; }

        /// <summary>
        /// Gets or sets the contact's fullname.
        /// </summary>
        /// <value>
        /// The ConFullName.
        /// </value>

        public string ConFullName { get; set; }

        /// <summary>
        /// Gets or sets the contact's display name.
        /// </summary>
        /// <value>
        /// The ConFileAs.
        /// </value>

        public string ConFileAs { get; set; }

        /// <summary>
        /// Gets or sets the contact's outlook identifier.
        /// </summary>
        /// <value>
        /// The ConOutlookId.
        /// </value>

        public string ConOutlookId { get; set; }

        public string BusinessAddress { get; set; }

        public int? ConUDF01 { get; set; }

        /// <summary>
        /// Gets Or Sets ConCompanyId
        /// </summary>
        public long? ConCompanyId { get; set; }

        /// <summary>
        /// Gets Or Sets ConCompanyIdName
        /// </summary>
        public string ConCompanyIdName { get; set; }

        /// <summary>
        /// Gets Or Sets CompanyType
        /// </summary>
        public string CompanyType { get; set; }

        public string JobSiteCode { get; set; }

    }
}