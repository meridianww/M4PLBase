/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              09/25/2018
Program Name:                                 CustDcLocationContact
Purpose:                                      Contains objects related to CustDcLocationContact
==========================================================================================================*/

namespace M4PL.Entities.Customer
{
    public class CustDcLocationContact : BaseModel
    {

        public long? ConPrimaryRecordId { get; set; }

        public int? ConItemNumber { get; set; }

        public long? ConCodeId { get; set; }

        public string ConCodeIdName { get; set; }

        public string ConFirstName { get; set; }

        public string ConMiddleName { get; set; }

        public string ConLastName { get; set; }

        public int? ConTypeId { get; set; }

        public long ConOrgId { get; set; }

        public string ConOrgIdName { get; set; }

        /// <summary>
        /// Gets or sets the contact's Organization Code.
        /// </summary>
        public string ConCompany { get; set; }

        public int? ConTitleId { get; set; }

        public string ConTitle { get; set; }

        /// <summary>
        /// Gets or sets the contact's Organization Code.
        /// </summary>
        public long? ContactMSTRID { get; set; }

        public string ContactMSTRIDName { get; set; }

        public int? ConTableTypeId { get; set; }

        /// <summary>
        /// Gets or sets the contact's email address.
        /// </summary>
        /// <value>
        /// The ConEmailAddress.
        /// </value>
        public string ConEmailAddress { get; set; }

        /// <summary>
        /// Gets or sets the contact's secondary email address.
        /// </summary>
        /// <value>
        /// The ConEmailAddress2.
        /// </value>
        public string ConEmailAddress2 { get; set; }

        public string CustomerType { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's mobile number.
        /// </summary>
        /// <value>
        /// The ConMobilePhone.
        /// </value>
        public string ConMobilePhone { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's business phone number.
        /// </summary>
        /// <value>
        /// The ConBusinessPhone.
        /// </value>
        public string ConBusinessPhone { get; set; }

        /// <summary>
        /// Gets or sets the extension number, when the business phone number is provided.
        /// </summary>
        /// <value>
        /// The ConBusinessPhoneExt.
        /// </value>
        public string ConBusinessPhoneExt { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's job title.
        /// </summary>
        /// <value>
        /// The ConJobTitle.
        /// </value>
        public string ConJobTitle { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's business address.
        /// </summary>
        /// <value>
        /// The ConBusinessAddress1.
        /// </value>
        public string ConBusinessAddress1 { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's secondary business adddress.
        /// </summary>
        /// <value>
        /// The ConBusinessAddress2.
        /// </value>
        public string ConBusinessAddress2 { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's business city.
        /// </summary>
        /// <value>
        /// The ConBusinessCity.
        /// </value>
        public string ConBusinessCity { get; set; }
       
        /// <summary>
        /// Gets or sets the contact's buiness state province.
        /// </summary>
        /// <value>
        /// The ConBusinessStateProvince.
        /// </value>

        public int? ConBusinessStateId { get; set; }

        public string ConBusinessStateIdName { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's business zip postal.
        /// </summary>
        /// <value>
        /// The ConBusinessZipPostal.
        /// </value>
        public string ConBusinessZipPostal { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's business conuntry region.
        /// </summary>
        /// <value>
        /// The ConBusinessCountryRegion.
        /// </value>

        public int? ConBusinessCountryId { get; set; }

        public string ConBusinessCountryIdName { get; set; }

        public string BusinessAddress { get; set; }
        
        /// <summary>
        /// Gets or sets the contact's fullname.
        /// </summary>
        /// <value>
        /// The ConFullName.
        /// </value>

        public string ConFullName { get; set; }

		public long? ConCompanyId { get; set; }
	}
}
