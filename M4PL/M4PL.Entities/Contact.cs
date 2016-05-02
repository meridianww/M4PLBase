using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Contact
    {
    
        public Contact()
        {
            this.Title = "Contact ID";
        }

        [Required]
        public int ContactID { get; set; }

        [Required(ErrorMessage = "Please enter Company", AllowEmptyStrings = false)]
        [MaxLength(100)]
        public string Company { get; set; }

        [Required(ErrorMessage = "Please enter Title", AllowEmptyStrings = false)]
        [MaxLength(5)]
        public string Title { get; set; }

        [Required(ErrorMessage = "Please enter First Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "Please enter Middle Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string MiddleName { get; set; }

        [Required(ErrorMessage = "Please enter Last Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string LastName { get; set; }

        [Required(ErrorMessage = "Please enter ERP ID", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string ERPID { get; set; }


        [Required(ErrorMessage = "Please enter Email Address 1", AllowEmptyStrings = false)]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string Email { get; set; }

        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string Email2 { get; set; }

        [Required(ErrorMessage = "Please enter Job Title", AllowEmptyStrings = false)]
        [MaxLength(50)]
        public string JobTitle { get; set; }

        [MaxLength(150)]
        public string Address { get; set; }
        [MaxLength(150)]
        public string Address2 { get; set; }
        [MaxLength(25)]
        public string City { get; set; }
        [MaxLength(25)]
        public string State { get; set; }
        [MaxLength(25)]
        public string Country { get; set; }
        [MaxLength(10)]
        public string PostalCode { get; set; }


        [MaxLength(150)]
        public string Address3 { get; set; }
        [MaxLength(150)]
        public string Address21 { get; set; }
        [MaxLength(25)]
        public string City1 { get; set; }
        [MaxLength(25)]
        public string State1 { get; set; }
        [MaxLength(25)]
        public string Country1 { get; set; }
        [MaxLength(10)]
        public string PostalCode1 { get; set; }



        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string BusinessPhone { get; set; }

        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string Ext { get; set; }

        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string MobilePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string HomePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string Fax { get; set; }

        public string WebURL { get; set; }

        public string Fullname { get; set; }

        public string OutlookID { get; set; }

        public string FileAs { get; set; }

        public string Notes { get; set; }

        public string DateEntered { get; set; }

        public string DateChanged { get; set; }

        public string EnteredBy { get; set; }

        public string ChangedBy { get; set; }
        [MaxLength(50)]
        public string FullName { get; set; }
        [MaxLength(50)]
        public string File { get; set; }

        public byte[] Image { get; set; }
        public List<byte> LstImages { get; set; }

    
    }
}
