﻿//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              28/4/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Organisation 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Organization : OrgLabels
    {
        public Organization()
        {
            this.OrgSortOrder = 1;
            this.OrgStatus = "Active";
            this.OrgContact = new OrgContact();
            this.OrgContact.ContactID = null;
        }
        public int OrganizationID { get; set; }

        [Required(ErrorMessage = "Organization Code is required")]
        [MaxLength(25)]
        public string OrgCode { get; set; }

        [Required(ErrorMessage = "Organization Title is required")]
        [MaxLength(50)]
        public string OrgTitle { get; set; }

        [Required(ErrorMessage = "Organization Group is required")]
        [MaxLength(25)]
        public string OrgGroup { get; set; }

        [Required(ErrorMessage = "Sort Order is required")]
        [Range(1, int.MaxValue)]
        public int? OrgSortOrder { get; set; }

        public string OrgDesc { get; set; }

        [Required(ErrorMessage = "Status is required")]
        [MaxLength(20)]
        public string OrgStatus { get; set; }

        //public DateTime OrgDateEntered { get; set; }
        [MaxLength(50)]
        public string OrgEnteredBy { get; set; }
        //public DateTime OrgDateChanged { get; set; }
        [MaxLength(50)]
        public string OrgDateChangedBy { get; set; }

        public OrgContact OrgContact { get; set; }

        public DateTime OrgDateEntered { get; set; }

        public DateTime OrgDateChanged { get; set; }

    }

    public class OrgContact : ContactLabels
    {
        public OrgContact()
        {
            this.Title = "Mr.";
        }

        public int? ContactID { get; set; }

        [MaxLength(5)]
        public string Title { get; set; }

        [MaxLength(25)]
        public string FirstName { get; set; }

        [MaxLength(25)]
        public string MiddleName { get; set; }

        [MaxLength(25)]
        public string LastName { get; set; }

        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string Email { get; set; }

        [MaxLength(100)]
        public string Email2 { get; set; }

        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please enter numeric values only")]
        public string BusinessPhone { get; set; }
        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string MobilePhone { get; set; }
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please enter numeric values only")]
        public string HomePhone { get; set; }
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please enter numeric values only")]
        public string Fax { get; set; }

    }

    public class OrgLabels
    {
        public string LblOrganizationID { get; set; }
        public string LblOrgCode { get; set; }
        public string LblOrgTitle { get; set; }
        public string LblOrgGroup { get; set; }
        public string LblOrgSortOrder { get; set; }
        public string LblOrgDesc { get; set; }
        public string LblOrgStatus { get; set; }
        public string LblOrgEnteredBy { get; set; }
        public string LblOrgDateChangedBy { get; set; }
        public string LblOrgDateEntered { get; set; }
        public string LblOrgDateChanged { get; set; }
    }
}