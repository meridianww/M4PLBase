/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Organization
Purpose:                                      Contains objects related to Organization
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    ///  Organization Class to create and maintain Organization Data
    /// </summary>
    public class Organization : BaseModel
    {
        public string OrgCode { get; set; }

        public string OrgTitle { get; set; }

        public int? OrgGroupId { get; set; }

        public int? OrgSortOrder { get; set; }

        public byte[] OrgDescription { get; set; }

        //public long? OrgContactId { get; set; }

        public byte[] OrgImage { get; set; }

        /// <summary>
        /// Gets or sets the vendor's work address identifier.
        /// </summary>
        /// <value>
        /// The OrgWorkAddressId.
        /// </value>
        public long? OrgWorkAddressId { get; set; }

        public string OrgWorkAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the Org's business address identifier.
        /// </summary>
        /// <value>
        /// The OrgBusinessAddressId.
        /// </value>
        public long? OrgBusinessAddressId { get; set; }

        public string OrgBusinessAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the Org's corporate address identifier.
        /// </summary>
        /// <value>
        /// The OrgCorporateAddressId.
        /// </value>
        public long? OrgCorporateAddressId { get; set; }

        public string OrgCorporateAddressIdName { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessAddress1
        /// </summary>
        public string BusinessAddress1 { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessAddress2
        /// </summary>
        public string BusinessAddress2 { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessCity
        /// </summary>
        public string BusinessCity { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessZipPostal
        /// </summary>
        public string BusinessZipPostal { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessStateId
        /// </summary>
        public int? BusinessStateId { get; set; }

        public string BusinessStateIdName { get; set; }

        /// <summary>
        /// Gets Or Sets BusinessCountryId
        /// </summary>
        public int? BusinessCountryId { get; set; }
        public string BusinessCountryIdName { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateAddress1
        /// </summary>
        public string CorporateAddress1 { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateAddress2
        /// </summary>
        public string CorporateAddress2 { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateCity
        /// </summary>
        public string CorporateCity { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateZipPostal
        /// </summary>
        public string CorporateZipPostal { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateStateId
        /// </summary>
        public int? CorporateStateId { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateStateIdName
        /// </summary>
        public string CorporateStateIdName { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateCountryId
        /// </summary>
        public int CorporateCountryId { get; set; }

        /// <summary>
        /// Gets Or Sets CorporateCountryId
        /// </summary>
        public string CorporateCountryIdName { get; set; }

        /// <summary>
        /// Gets Or Sets WorkAddress1
        /// </summary>
        public string WorkAddress1 { get; set; }

        /// <summary>
        /// Gets Or Sets WorkAddress2
        /// </summary>
        public string WorkAddress2 { get; set; }

        /// <summary>
        /// Gets Or Sets WorkCity
        /// </summary>
        public string WorkCity { get; set; }

        /// <summary>
        /// Gets Or Sets WorkZipPostal
        /// </summary>
        public string WorkZipPostal { get; set; }

        /// <summary>
        /// Gets Or Sets WorkStateId
        /// </summary>
        public int? WorkStateId { get; set; }

        /// <summary>
        /// Gets Or Sets WorkStateIdName
        /// </summary>
        public string WorkStateIdName { get; set; }

        /// <summary>
        /// Gets Or Sets WorkCountryId
        /// </summary>
        public int WorkCountryId { get; set; }

        public string WorkCountryIdName { get; set; }
    }
}