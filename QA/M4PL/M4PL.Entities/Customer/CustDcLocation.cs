/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustDcLocation
Purpose:                                      Contains objects related to CustDcLocation
==========================================================================================================*/

using System;

namespace M4PL.Entities.Customer
{
    /// <summary>
    /// Customer DcLocation class to store the several customer's origin sites from which Products
    /// can be accessed from the distribution centers or warehouses
    /// </summary>
    public class CustDcLocation : BaseModel
    {
        /// <summary>
        /// Gets or sets the customer identifier.
        /// </summary>
        /// <value>
        /// The CdcCustomerID.
        /// </value>
        public long? CdcCustomerID { get; set; }

        public string CdcCustomerIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting oder.
        /// </summary>
        /// <value>
        /// The CdcItemNumber.
        /// </value>
        public int? CdcItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the type of DC location.
        /// </summary>
        /// <value>
        /// The CdcLocationCode.
        /// </value>
        public string CdcLocationCode { get; set; }


        /// <summary>
        /// Gets or sets the Customer Code.
        /// </summary>
        /// <value>
        /// The Customer Cod.
        /// </value>
        public string CdcCustomerCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The CdcLocationTitle.
        /// </value>
        public string CdcLocationTitle { get; set; }

        /// <summary>
        /// Gets or sets the contact's master table identifier.
        /// </summary>
        /// <value>
        /// The CdcContactMSTRID.
        /// </value>
        public long? CdcContactMSTRID { get; set; }

        public string CdcContactMSTRIDName { get; set; }

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