/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendContact
Purpose:                                      Contains objects related to VendContact
==========================================================================================================*/

using System;

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

        public string ContactMSTRIDName { get; set; }

        public string ConJobTitle { get; set; }

        public string ConEmailAddress { get; set; }

        public string ConMobilePhone { get; set; }

        public string ConBusinessPhone { get; set; }

        public string ConBusinessAddress1 { get; set; }

        public string ConBusinessAddress2 { get; set; }

        public string ConBusinessCity { get; set; }

        public string ConBusinessStateIdName { get; set; }

        public string ConBusinessZipPostal { get; set; }

        public string ConBusinessCountryIdName { get; set; }
        public string ConBusinessFullAddress { get; set; }
	}
}