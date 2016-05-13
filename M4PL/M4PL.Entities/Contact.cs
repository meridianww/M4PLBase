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
            this.ConTitle = "Mr.";
        }

        [Required]
        public int ContactID { get; set; }
        public string ConERPID { get; set; }

        [Required(ErrorMessage = "Please enter Company", AllowEmptyStrings = false)]
        [MaxLength(100)]
        public string ConCompany { get; set; }

        [Required(ErrorMessage = "Please enter Title", AllowEmptyStrings = false)]
        [MaxLength(5)]
        public string ConTitle { get; set; }

        [Required(ErrorMessage = "Please enter First Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string ConFirstName { get; set; }

        [Required(ErrorMessage = "Please enter Middle Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string ConMiddleName { get; set; }

        [Required(ErrorMessage = "Please enter Last Name", AllowEmptyStrings = false)]
        [MaxLength(25)]
        public string ConLastName { get; set; }

        [Required(ErrorMessage = "Please enter Email Address 1", AllowEmptyStrings = false)]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string ConEmailAddress { get; set; }

        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string ConEmailAddress2 { get; set; }
        public byte[] ConImage { get; set; }
        public List<byte> LstImages { get; set; }

        [Required(ErrorMessage = "Please enter Job Title", AllowEmptyStrings = false)]
        [MaxLength(50)]
        public string ConJobTitle { get; set; }
        
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string ConBusinessPhone { get; set; }
        [RegularExpression(@"^[0-9]{2,5}$", ErrorMessage = "Please enter numeric values only")]
        [MaxLength(5)]
        public string ConBusinessPhoneExt { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string ConHomePhone { get; set; }
        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string ConMobilePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string ConFaxNumber { get; set; }

        [MaxLength(150)]
        public string ConBusinessAddress1 { get; set; }
        [MaxLength(150)]
        public string ConBusinessAddress2 { get; set; }
        [MaxLength(25)]
        public string ConBusinessCity { get; set; }
        [MaxLength(25)]
        public string ConBusinessStateProvince { get; set; }
        [MaxLength(10)]
        public string ConBusinessZIPPostal { get; set; }
        [MaxLength(25)]
        public string ConBusinessCountryRegion { get; set; }
        [MaxLength(150)]
        public string ConHomeAddress1 { get; set; }
        [MaxLength(150)]
        public string ConHomeAddress2 { get; set; }
        [MaxLength(25)]
        public string ConHomeCity { get; set; }
        [MaxLength(25)]
        public string ConHomeStateProvince { get; set; }
        [MaxLength(10)]
        public string ConHomeZIPPostal { get; set; }
        [MaxLength(25)]
        public string ConHomeCountryRegion { get; set; }

        public int ConAttachments { get; set; }

        [MaxLength(100)]
        public string ConWebPage { get; set; }
        public string ConNotes { get; set; }
        [MaxLength(20)]
        public string ConStatus { get; set; }
        [MaxLength(20)]
        public string ConType { get; set; }
        [MaxLength(50)]
        public string ConFullName { get; set; }
        [MaxLength(50)]
        public string ConFileAs { get; set; }
        [MaxLength(50)]
        public string ConOutlookID { get; set; }

        public DateTime ConDateEntered { get; set; }
        public string ConDateEnteredBy { get; set; }
        public DateTime ConDateChanged { get; set; }
        public string ConDateChangedBy { get; set; }
    }
}
