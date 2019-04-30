/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Customer
Purpose:                                      Contains objects related to Customer
==========================================================================================================*/

namespace M4PL.Entities.Customer
{
    /// <summary>
    /// Customer Class will store the related information and list of all the customer's associated with particular Organization
    /// </summary>
    public class Customer : BaseModel
    {
        /// <summary>
        /// Gets or sets the Customer's ERP identifier(Entrprise Planning Resource).
        /// </summary>
        /// <value>
        /// The CustERPID.
        /// </value>
        public string CustERPID { get; set; }

        /// <summary>
        /// Gets or sets the customer's identifier associted to the organization.
        /// </summary>
        /// <value>
        /// The CustOrgId.
        /// </value>

        public long? CustOrgId { get; set; }
        public string CustOrgIdName { get; set; }

        /// <summary>
        /// Gets or sets the Customer's sorting order.
        /// </summary>
        /// <value>
        /// The CustItemNumber.
        /// </value>

        public int? CustItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the type of the customer.
        /// </summary>
        /// <value>
        /// The CustCode.
        /// </value>

        public string CustCode { get; set; }

        /// <summary>
        /// Gets or sets the Customer title.
        /// </summary>
        /// <value>
        /// The CustTitle.
        /// </value>

        public string CustTitle { get; set; }

        /// <summary>
        /// Gets or sets the Customer's description.
        /// </summary>
        /// <value>
        /// The CustDescription.
        /// </value>

        public byte[] CustDescription { get; set; }

        /// <summary>
        /// Gets or sets the Customer's work address identifier.
        /// </summary>
        /// <value>
        /// The CustWorkAddressId.
        /// </value>

        public long? CustWorkAddressId { get; set; }
        public string CustWorkAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the Customer's business address identifier.
        /// </summary>
        /// <value>
        /// The CustBusinessAddressId.
        /// </value>

        public long? CustBusinessAddressId { get; set; }
        public string CustBusinessAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the Cusotmer's corporate address identifier.
        /// </summary>
        /// <value>
        /// The CustCorporateAddressId.
        /// </value>

        public long? CustCorporateAddressId { get; set; }
        public string CustCorporateAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the customer's contacts.
        /// </summary>
        /// <value>
        /// The CustContacts.
        /// </value>

        public int? CustContacts { get; set; }

        /// <summary>
        /// Gets or sets the customer logo.
        /// </summary>
        /// <value>
        /// The CustLogo.
        /// </value>

        public byte[] CustLogo { get; set; }

        /// <summary>
        /// Gets or sets the customer notes.
        /// </summary>
        /// <value>
        /// The CustNotes.
        /// </value>

        public byte[] CustNotes { get; set; }

        /// <summary>
        /// Gets or sets the customer type identifier.
        /// </summary>
        /// <value>
        /// The CustTypeId.
        /// </value>

        public int? CustTypeId { get; set; }
        public string CustTypeCode { get; set; }

        /// <summary>
        /// Gets or sets the customer's web page.
        /// </summary>
        /// <value>
        /// The CustWebPage.
        /// </value>
        public string CustWebPage { get; set; }
    }
}