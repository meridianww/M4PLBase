using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Organization
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


        public DateTime DateEntered { get; set; }

        public DateTime DateChanged { get; set; }

        public string EnteredBy { get; set; }

        public string ChangedBy { get; set; }

    }

    public class OrgContact
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
        
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string BusinessPhone { get; set; }
        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string MobilePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string HomePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string Fax { get; set; }

    }
}