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
// Program Name:                                 CustDocReference
// Purpose:                                      Contains objects related to CustDocReference
//==========================================================================================================

using System;

namespace M4PL.Entities.Customer
{
    /// <summary>
    /// Customer Document Reference class will store details related to Customer's background documentation and contact's related information
    /// </summary>
    public class CustDocReference : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization indentifier to which
        /// the document referece has been associated.
        /// </summary>
        /// <value>
        /// The CdrOrgID.
        /// </value>
        public long? CdrOrgID { get; set; }

        public string CdrOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the customer identifier to which
        /// the document refernce has been associated.
        /// </summary>
        /// <value>
        /// The CdrCustomerID.
        /// </value>
        public long? CdrCustomerID { get; set; }

        public string CdrCustomerIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order for the document reference.
        /// </summary>
        /// <value>
        /// The CdrItemNumber.
        /// </value>
        public int? CdrItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the code for document reference.
        /// </summary>
        /// <value>
        /// The CdrCode.
        /// </value>
        public string CdrCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The CdrTitle.
        /// </value>
        public string CdrTitle { get; set; }

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
        /// The CdrDescription.
        /// </value>

        public byte[] CdrDescription { get; set; }

        /// <summary>
        /// Gets or sets the counts of attachements.
        /// </summary>
        /// <value>
        /// The CdrAttachment.
        /// </value>
        public int? CdrAttachment { get; set; }

        /// <summary>
        /// Gets or sets the start date.
        /// </summary>
        /// <value>
        /// The CdrDateStart.
        /// </value>
        public DateTime? CdrDateStart { get; set; }

        /// <summary>
        /// Gets or sets the end date.
        /// </summary>
        /// <value>
        /// The CdrDateEnd.
        /// </value>
        public DateTime? CdrDateEnd { get; set; }

        /// <summary>
        /// Gets or sets the assignment  as renewable.
        /// </summary>
        /// <value>
        /// The CdrRenewal.
        /// </value>
        public bool CdrRenewal { get; set; }
    }
}