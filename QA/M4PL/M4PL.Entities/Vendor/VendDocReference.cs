/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendDocReference
Purpose:                                      Contains objects related to VendDocReference
==========================================================================================================*/

using System;

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// Vendor Document Reference class will store details related to Vendors's background documentation and contact's related information
    /// </summary>
    public class VendDocReference : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization indentifier to which
        /// the document referece has been associated.
        /// </summary>
        /// <value>
        /// The VdrOrgID.
        /// </value>
        public long? VdrOrgID { get; set; }

        public string VdrOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier to which
        /// the document refernce has been associated.
        /// </summary>
        /// <value>
        /// The VdrVendorID.
        /// </value>
        public long? VdrVendorID { get; set; }

        public string VdrVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting oder.
        /// </summary>
        /// <value>
        /// The VdrVendorID.
        /// </value>
        public int? VdrItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the code for document reference.
        /// </summary>
        /// <value>
        /// The VdrCode.
        /// </value>
        public string VdrCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The VdrTitle.
        /// </value>
        public string VdrTitle { get; set; }

        /// <summary>
        /// Gets or sets the document type identifier.
        /// </summary>
        /// <value>
        /// The DocRefTypeId.
        /// </value>
        public int? DocRefTypeId { get; set; }

        /// <summary>
        /// Gets or sets the document category identifier.
        /// </summary>
        /// <value>
        /// The DocCategoryTypeId.
        /// </value>
        public int? DocCategoryTypeId { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The VdrDescription.
        /// </value>
        public byte[] VdrDescription { get; set; }

        /// <summary>
        /// Gets or sets the counts of attachements.
        /// </summary>
        /// <value>
        /// The VdrAttachment.
        /// </value>
        public int? VdrAttachment { get; set; }

        /// <summary>
        /// Gets or sets the start date.
        /// </summary>
        /// <value>
        /// The VdrDateStart.
        /// </value>
        public DateTime? VdrDateStart { get; set; }

        /// <summary>
        /// Gets or sets the end date.
        /// </summary>
        /// <value>
        /// The VdrDateEnd.
        /// </value>
        public DateTime? VdrDateEnd { get; set; }

        /// <summary>
        /// Gets or sets the assignment  as renewable.
        /// </summary>
        /// <value>
        /// The VdrRenewal.
        /// </value>
        public bool VdrRenewal { get; set; }
    }
}