/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendBusinessTerm
Purpose:                                      Contains objects related to VendBusinessTerm
==========================================================================================================*/

using System;

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// VendBusinessTerm class to the track for Vendor's Business
    /// </summary>
    public class VendBusinessTerm : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier to which the vendor is associated.
        /// </summary>
        /// <value>
        /// The Organization Identifier
        /// </value>
        public long? VbtOrgID { get; set; }

        public string VbtOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The vendor identifier.
        /// </value>

        public long? VbtVendorID { get; set; }
        public string VbtVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The VbtItemNumber.
        /// </value>
        public int? VbtItemNumber { get; set; }

        /// <summary>
        /// Gets or setsspecial code defined for the vendors.
        /// </summary>
        /// <value>
        /// The VbtCode.
        /// </value>
        public string VbtCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The VbtTitle.
        /// </value>
        public string VbtTitle { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The VbtDescription.
        /// </value>
        public byte[] VbtDescription { get; set; }

        /// <summary>
        /// Gets or sets the type of business.
        /// </summary>
        /// <value>
        /// The BusinessTermType identifier.
        /// </value>
        public int? BusinessTermTypeId { get; set; }

        /// <summary>
        /// Gets or sets the Active Date.
        /// </summary>
        /// <value>
        /// The VbtActiveDate.
        /// </value>
        public DateTime? VbtActiveDate { get; set; }

        /// <summary>
        /// Gets or sets the cost value of the business terms.
        /// </summary>
        /// <value>
        /// The VbtValue.
        /// </value>
        public decimal? VbtValue { get; set; }

        /// <summary>
        /// Gets or sets the high threshold for the cost value.
        /// </summary>
        /// <value>
        /// The VbtHiThreshold.
        /// </value>
        public decimal? VbtHiThreshold { get; set; }

        /// <summary>
        /// Gets or sets the low threshold for the cost value.
        /// </summary>
        /// <value>
        /// The VbtLoThreshold.
        /// </value>
        public decimal? VbtLoThreshold { get; set; }

        /// <summary>
        /// Gets or sets the count of attached documents.
        /// </summary>
        /// <value>
        /// The VbtAttachment.
        /// </value>
        public int VbtAttachment { get; set; }
    }
}