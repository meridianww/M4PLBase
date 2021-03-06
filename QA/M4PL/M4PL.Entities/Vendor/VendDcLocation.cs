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
// Program Name:                                 VendDcLocation
// Purpose:                                      Contains objects related to VendDcLocation
//==========================================================================================================

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
        /// <summary>
        /// Gets or Sets Vendor Name
        /// </summary>
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