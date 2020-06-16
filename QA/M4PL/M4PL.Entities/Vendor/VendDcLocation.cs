/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendDcLocation
Purpose:                                      Contains objects related to VendDcLocation
==========================================================================================================*/

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// Vendors DcLocation class to store the several Vendor's origin sites from which Products
    /// can be accessed from the distribution centers or warehouses
    /// </summary>
    public class VendDcLocation : BaseModel
    {
        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The VdcVendorID.
        /// </value>
        public long? VdcVendorID { get; set; }

        public string VdcVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting oder.
        /// </summary>
        /// <value>
        /// The VdcItemNumber.
        /// </value>
        public int? VdcItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the type of DC location.
        /// </summary>
        /// <value>
        /// The VdcLocationCode.
        /// </value>
        public string VdcLocationCode { get; set; }

        /// <summary>
        /// Gets or sets the Customer Code.
        /// </summary>
        /// <value>
        /// The Customer Cod.
        /// </value>
        public string VdcCustomerCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The VdcLocationTitle.
        /// </value>
        public string VdcLocationTitle { get; set; }

        /// <summary>
        /// Gets or sets the contact's master table identifier.
        /// </summary>
        /// <value>
        /// The VdcContactMSTRID.
        /// </value>
        public long? VdcContactMSTRID { get; set; }

        public string VdcContactMSTRIDName { get; set; }

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