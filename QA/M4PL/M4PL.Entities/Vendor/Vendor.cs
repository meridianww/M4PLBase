/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Vendor
Purpose:                                      Contains objects related to Vendor
==========================================================================================================*/

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// Vendor Class to store the related information and list of all the Vendor's associated with particular Organization
    /// </summary>
    public class Vendor : BaseModel
    {
        /// <summary>
        /// Gets or sets the vendors's ERP identifier(Entrprise Planning Resource).
        /// </summary>
        /// <value>
        /// The VendERPID.
        /// </value>
        public string VendERPID { get; set; }

        /// <summary>
        /// Gets or sets the vendor's identifier associted to the organization.
        /// </summary>
        /// <value>
        /// The VendOrgId.
        /// </value>
        public long? VendOrgID { get; set; }

        public string VendOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's sorting order.
        /// </summary>
        /// <value>
        /// The VendItemNumber.
        /// </value>
        public int? VendItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the  type of the vendor.
        /// </summary>
        /// <value>
        /// The VendCode.
        /// </value>
        public string VendCode { get; set; }

        /// <summary>
        /// Gets or sets the vendor title.
        /// </summary>
        /// <value>
        /// The VendTitle.
        /// </value>
        public string VendTitle { get; set; }

        /// <summary>
        /// Gets or sets the vendor's description.
        /// </summary>
        /// <value>
        /// The VendDescription.
        /// </value>
        public byte[] VendDescription { get; set; }

        /// <summary>
        /// Gets or sets the vendor's work address identifier.
        /// </summary>
        /// <value>
        /// The VendWorkAddressId.
        /// </value>
        public long? VendWorkAddressId { get; set; }

        public string VendWorkAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendors's business address identifier.
        /// </summary>
        /// <value>
        /// The VendBusinessAddressId.
        /// </value>
        public long? VendBusinessAddressId { get; set; }

        public string VendBusinessAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's corporate address identifier.
        /// </summary>
        /// <value>
        /// The VendCorporateAddressId.
        /// </value>
        public long? VendCorporateAddressId { get; set; }

        public string VendCorporateAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's contacts.
        /// </summary>
        /// <value>
        /// The VendContacts.
        /// </value>
        public int? VendContacts { get; set; }

        /// <summary>
        /// Gets or sets the vendor logo.
        /// </summary>
        /// <value>
        /// The VendLogo.
        /// </value>
        public byte[] VendLogo { get; set; }

        /// <summary>
        /// Gets or sets the vendor notes.
        /// </summary>
        /// <value>
        /// The VendNotes.
        /// </value>
        public byte[] VendNotes { get; set; }

        /// <summary>
        /// Gets or sets the vendor type identifier.
        /// </summary>
        /// <value>
        /// The VendTypeId.
        /// </value>

        public int? VendTypeId { get; set; }
        public string VendTypeCode { get; set; }

        /// <summary>
        /// Gets or sets the vendor's web page.
        /// </summary>
        /// <value>
        /// The VendWebPage.
        /// </value>
        public string VendWebPage { get; set; }
    }
}