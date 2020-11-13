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
// Program Name:                                 VendDcLocationContact
// Purpose:                                      Contains objects related to VendDcLocationContact
//==========================================================================================================

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// Gets or Sets input/output model for Vendor DC locations
    /// </summary>
    public class VendDcLocationContact : BaseModel
    {
        /// <summary>
        /// Gets or Sets Org Id for the contact
        /// </summary>
        public long ConOrgId { get; set; }
        /// <summary>
        /// Gets or Sets Organization of a contact
        /// </summary>
        public string ConOrgIdName { get; set; }
        /// <summary>
        /// Gets or Sets Vendor DC Location ID
        /// </summary>
        public long? ConPrimaryRecordId { get; set; }
        /// <summary>
        /// Gets or Sets Item Number of contact
        /// </summary>
        public int? ConItemNumber { get; set; }
        /// <summary>
        /// Gets or Sets Code Id of a contact
        /// </summary>
        public long? ConCodeId { get; set; }
        /// <summary>
        /// Gets or Sets Code Name of a contact
        /// </summary>
        public string ConCodeIdName { get; set; }
        /// <summary>
        /// Gets or Sets Contact Title 
        /// </summary>
        public string ConTitle { get; set; }
        /// <summary>
        /// Gets or Sets Contact Type ID e.g. 62 for Employee
        /// </summary>

        public int? ConTypeId { get; set; }
        /// <summary>
        /// Gets or Sets Contact Id
        /// </summary>
        public long? ContactMSTRID { get; set; }
        /// <summary>
        /// Gets or Sets COntact Name
        /// </summary>
        public string ContactMSTRIDName { get; set; }
        /// <summary>
        /// Gets or Sets Contact table Type ID
        /// </summary>
        public int? ConTableTypeId { get; set; }



        /// <summary>
        /// Gets or sets the contact title.
        /// </summary>
        /// <value>
        /// The ConTitle identifier.
        /// </value>
        public int? ConTitleId { get; set; }

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
        /// </value>
        //public string ConJobTitle { get; set; }

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
        /// Gets or sets the contact's business Mobile Phone.
        /// </summary>
        /// <value>
        /// The ConBusinessCity.
        /// </value>
        public string ConMobilePhone { get; set; }
        /// <summary>
        /// Gets or Sets Contact's business City
        /// </summary>
        public string ConBusinessCity { get; set; }

        /// <summary>
        /// Gets or sets the contact's business state Id
        /// </summary>
        /// <value>
        /// The ConBusinessZipPostal.
        /// </value>

        public int? ConBusinessStateId { get; set; }
        /// <summary>
        /// Gets or Sets Contact's Business State Name
        /// </summary>
        public string ConBusinessStateIdName { get; set; }
        /// <summary>
        /// Gets or sets the contact's business zip postal.
        /// </summary>
        public string ConBusinessZipPostal { get; set; }

        /// <summary>
        /// Gets or sets the contact's business conuntry region.
        /// </summary>
        /// <value>
        /// The ConBusinessCountryRegion.
        /// </value>

        public int? ConBusinessCountryId { get; set; }
        /// <summary>
        /// Gets or sets the contact's business conuntry Name.
        /// </summary>
        public string ConBusinessCountryIdName { get; set; }
        /// <summary>
        /// Gets or sets the type of contact identifier.
        /// </summary>
        /// <value>
        /// The ConType identifier.
        /// </value>


        public string BusinessAddress { get; set; }


        /// <summary>
        /// Gets or sets the contact's fullname.
        /// </summary>
        /// <value>
        /// The ConFullName.
        /// </value>

        public string ConFullName { get; set; }
        /// <summary>
        /// Gets or Sets Contact's Company Id
        /// </summary>
        public long? ConCompanyId { get; set; }
        /// <summary>
        /// Gets or Sets Sets Contact's Company Name
        /// </summary>
        public string ConCompanyIdName { get; set; }
    }
}
