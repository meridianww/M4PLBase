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

    public class VendDcLocationContact : BaseModel
    {

        public long ConOrgId { get; set; }
        public string ConOrgIdName { get; set; }
        public long? ConPrimaryRecordId { get; set; }
        public int? ConItemNumber { get; set; }
        public long? ConCodeId { get; set; }
        public string ConCodeIdName { get; set; }
        public string ConTitle { get; set; }

        public int? ConTypeId { get; set; }
        public long? ContactMSTRID { get; set; }
        public string ContactMSTRIDName { get; set; }

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
        /// Gets or sets the contact's business city.
        /// </summary>
        /// <value>
        /// The ConBusinessCity.
        /// </value>
        public string ConMobilePhone { get; set; }
        public string ConBusinessCity { get; set; }

        /// <summary>
        /// Gets or sets the contact's business zip postal.
        /// </summary>
        /// <value>
        /// The ConBusinessZipPostal.
        /// </value>

        public int? ConBusinessStateId { get; set; }
        public string ConBusinessStateIdName { get; set; }
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
        public long? ConCompanyId { get; set; }

        public string ConCompanyIdName { get; set; }
    }
}
