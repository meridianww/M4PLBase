using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample.Models
{
    public class Vendor
    {
        public long Id { get; set; }
        public long ArbRecordId { get; set; }
        public string LangCode { get; set; }
        public int SysRefId { get; set; }
        public string SysRefName { get; set; }
        public long ParentId { get; set; }
        public long OrganizationId { get; set; }
        public string RoleCode { get; set; }
        public bool IsFormView { get; set; }

        public int? StatusId { get; set; }

        public DateTime DateEntered { get; set; }

        public DateTime? DateChanged { get; set; }

        public string EnteredBy { get; set; }

        public string ChangedBy { get; set; }

        public int ItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the vendors's ERP identifier(Entrprise Planning Resource).
        /// </summary>
        /// <value>
        /// The VendERPID.
        /// </value>
        public string VendERPID { get; set; }

        /// <summary>
        /// Gets or sets the vendor's identifier associted to the organization.
        /// </summary>
        /// <value>
        /// The VendOrgId.
        /// </value>
        public long? VendOrgID { get; set; }

        public string VendOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's sorting order.
        /// </summary>
        /// <value>
        /// The VendItemNumber.
        /// </value>
        public int VendItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the  type of the vendor.
        /// </summary>
        /// <value>
        /// The VendCode.
        /// </value>
        public string VendCode { get; set; }

        /// <summary>
        /// Gets or sets the vendor title.
        /// </summary>
        /// <value>
        /// The VendTitle.
        /// </value>
        public string VendTitle { get; set; }

        /// <summary>
        /// Gets or sets the vendor's description.
        /// </summary>
        /// <value>
        /// The VendDescription.
        /// </value>
        public byte[] VendDescription { get; set; }

        /// <summary>
        /// Gets or sets the vendor's work address identifier.
        /// </summary>
        /// <value>
        /// The VendWorkAddressId.
        /// </value>
        public long? VendWorkAddressId { get; set; }

        public string VendWorkAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendors's business address identifier.
        /// </summary>
        /// <value>
        /// The VendBusinessAddressId.
        /// </value>
        public long? VendBusinessAddressId { get; set; }

        public string VendBusinessAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's corporate address identifier.
        /// </summary>
        /// <value>
        /// The VendCorporateAddressId.
        /// </value>
        public long? VendCorporateAddressId { get; set; }

        public string VendCorporateAddressIdName { get; set; }

        /// <summary>
        /// Gets or sets the vendor's contacts.
        /// </summary>
        /// <value>
        /// The VendContacts.
        /// </value>
        public int? VendContacts { get; set; }

        /// <summary>
        /// Gets or sets the vendor logo.
        /// </summary>
        /// <value>
        /// The VendLogo.
        /// </value>
        public byte[] VendLogo { get; set; }

        /// <summary>
        /// Gets or sets the vendor notes.
        /// </summary>
        /// <value>
        /// The VendNotes.
        /// </value>
        public byte[] VendNotes { get; set; }

        /// <summary>
        /// Gets or sets the vendor type identifier.
        /// </summary>
        /// <value>
        /// The VendTypeId.
        /// </value>

        public int? VendTypeId { get; set; }
        public string VendTypeCode { get; set; }

        /// <summary>
        /// Gets or sets the vendor's web page.
        /// </summary>
        /// <value>
        /// The VendWebPage.
        /// </value>
        public string VendWebPage { get; set; }
    }
}