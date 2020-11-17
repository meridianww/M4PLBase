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
// Program Name:                                 VendContact
// Purpose:                                      Contains objects related to VendContact
//==========================================================================================================

namespace M4PL.Entities.Vendor
{
    /// <summary>
    ///  VendContact Class to store the information related to Vendors's Contacts
    /// </summary>
    public class VendContact : BaseModel
    {
        /// <summary>
        /// Gets or sets the vendor's contact identifier.
        /// </summary>
        /// <value>
        /// The VendVendorID.
        /// </value>
        public long? ConPrimaryRecordId { get; set; }
        /// <summary>
        /// Gets or Sets Vendor Contact Name
        /// </summary>
        public string ConPrimaryRecordIdName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The VendItemNumber.
        /// </value>
        public int? ConItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the type of vendor's contact.
        /// </summary>
        /// <value>
        /// The VendContactCode.
        /// </value>
        public long? ConCodeId { get; set; }
        /// <summary>
        /// Gets or Sets Vendor contact Type Name e.g. Employee
        /// </summary>
        public string ConCodeIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendors's contact title.
        /// </summary>
        /// <value>
        /// The VendContactTitle.
        /// </value>
        public string ConTitle { get; set; }

        /// <summary>
        /// Gets or sets the Vendors's master contact identifier.
        /// </summary>
        /// <value>
        /// The VendContactMSTRID.
        /// </value>
        public long? ContactMSTRID { get; set; }
        /// <summary>
        /// Gets or Sets Vendor's Master Contact Name
        /// </summary>
        public string ContactMSTRIDName { get; set; }
        /// <summary>
        /// Gets or Sets Job Title of Vendor Contact
        /// </summary>
        public string ConJobTitle { get; set; }
        /// <summary>
        /// Gets or Sets Email Address of Vendor's Contact
        /// </summary>
        public string ConEmailAddress { get; set; }
        /// <summary>
        /// Gets or Sets Mobile Number of Vendor Contact
        /// </summary>
        public string ConMobilePhone { get; set; }
        /// <summary>
        /// Gets or Sets Business Phone of Vendor Contact
        /// </summary>
        public string ConBusinessPhone { get; set; }
        /// <summary>
        /// Gets or Sets Business Address of a Vendor Contact
        /// </summary>
        public string ConBusinessAddress1 { get; set; }
        /// <summary>
        /// Gets or Sets Business Address of a Vendor Contact
        /// </summary>
        public string ConBusinessAddress2 { get; set; }
        /// <summary>
        /// Gets or Sets Business City of a Vendor Contact
        /// </summary>
        public string ConBusinessCity { get; set; }
        /// <summary>
        /// Gets or Sets Business Status Name of a Vendor Contact
        /// </summary>
        public string ConBusinessStateIdName { get; set; }
        /// <summary>
        /// Gets or Sets Business ZipCode of a Vendor Contact
        /// </summary>
        public string ConBusinessZipPostal { get; set; }
        /// <summary>
        /// Gets or Sets Business Country Name of a Vendor Contact
        /// </summary>
        public string ConBusinessCountryIdName { get; set; }
        /// <summary>
        /// Gets or Sets Business Full Address of a Vendor Contact
        /// </summary>
        public string ConBusinessFullAddress { get; set; }
    }
}