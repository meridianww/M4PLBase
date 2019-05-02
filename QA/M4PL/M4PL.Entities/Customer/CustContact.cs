﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustContact
Purpose:                                      Contains objects related to CustContact
==========================================================================================================*/

using System;

namespace M4PL.Entities.Customer
{
    /// <summary>
    /// Cust Contact class to store the business related contacts
    /// </summary>
    public class CustContact : BaseModel
    {
        /// <summary>
        /// Gets or sets the cusotmer's contact identifier.
        /// </summary>
        /// <value>
        /// The CustCustomerID.
        /// </value>
        public long? ConPrimaryRecordId { get; set; }

        public string ConPrimaryRecordIdName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The CustItemNumber.
        /// </value>
        public int? ConItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the type of customer's contact.
        /// </summary>
        /// <value>
        /// The CustContactCode.
        /// </value>
        public long? ConCodeId { get; set; }

        public string ConCodeIdName { get; set; }

        /// <summary>
        /// Gets or sets the customer's contact title.
        /// </summary>
        /// <value>
        /// The CustContactTitle.
        /// </value>
        public string ConTitle { get; set; }


        /// <summary>
        /// Gets or sets the Customer's master contact identifier.
        /// </summary>
        /// <value>
        /// The CustContactMSTRID.
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