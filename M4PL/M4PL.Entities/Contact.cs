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

        [Required(ErrorMessage = "Please enter Last Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string LastName { get; set; }

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

        [MaxLength(255)]
        public string Address { get; set; }
        [MaxLength(25)]
        public string City { get; set; }
        [MaxLength(25)]
        public string State { get; set; }
        [MaxLength(25)]
        public string Country { get; set; }
        [MaxLength(20)]
        public string PostalCode { get; set; }

        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string BusinessPhone { get; set; }
        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string MobilePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string HomePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string Fax { get; set; }

        public string Notes { get; set; }
        [MaxLength(50)]
        public string FullName { get; set; }
        [MaxLength(50)]
        public string File { get; set; }
    }
}
