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
            this.Title = "Mr.";
        }

        [Required]
        public int ContactID { get; set; }
        public string ERPID { get; set; }

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

        [Required(ErrorMessage = "Please enter Email Address 1", AllowEmptyStrings = false)]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string EmailAddress { get; set; }

        [EmailAddress(ErrorMessage = "Invalid email format")]
        [MaxLength(100)]
        public string EmailAddress2 { get; set; }
        public byte[] Image { get; set; }
        public List<byte> LstImages { get; set; }

        [Required(ErrorMessage = "Please enter Job Title", AllowEmptyStrings = false)]
        [MaxLength(50)]
        public string JobTitle { get; set; }
        
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string BusinessPhone { get; set; }
        [RegularExpression(@"^[0-9]{2,5}$", ErrorMessage = "Please enter numeric values only")]
        [MaxLength(5)]
        public string BusinessPhoneExt { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string HomePhone { get; set; }
        [RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        public string MobilePhone { get; set; }
        [RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        public string FaxNumber { get; set; }

        [MaxLength(150)]
        public string BusinessAddress1 { get; set; }
        [MaxLength(150)]
        public string BusinessAddress2 { get; set; }
        [MaxLength(25)]
        public string BusinessCity { get; set; }
        [MaxLength(25)]
        public string BusinessStateProvince { get; set; }
        [MaxLength(10)]
        public string BusinessZIPPostal { get; set; }
        [MaxLength(25)]
        public string BusinessCountryRegion { get; set; }
        [MaxLength(150)]
        public string HomeAddress1 { get; set; }
        [MaxLength(150)]
        public string HomeAddress2 { get; set; }
        [MaxLength(25)]
        public string HomeCity { get; set; }
        [MaxLength(25)]
        public string HomeStateProvince { get; set; }
        [MaxLength(10)]
        public string HomeZIPPostal { get; set; }
        [MaxLength(25)]
        public string HomeCountryRegion { get; set; }

        public int Attachments { get; set; }

        [MaxLength(100)]
        public string WebPage { get; set; }
        public string Notes { get; set; }
        [MaxLength(20)]
        public string Status { get; set; }
        [MaxLength(20)]
        public string Type { get; set; }
        [MaxLength(50)]
        public string FullName { get; set; }
        [MaxLength(50)]
        public string FileAs { get; set; }
        [MaxLength(50)]
        public string OutlookID { get; set; }

        public DateTime DateEntered { get; set; }
        public string DateEnteredBy { get; set; }
        public DateTime DateChanged { get; set; }
        public string DateChangedBy { get; set; }

        

        //[Required(ErrorMessage = "Please enter Email Address 1", AllowEmptyStrings = false)]
        //[EmailAddress(ErrorMessage = "Invalid email format")]
        //[MaxLength(100)]
        //public string Email { get; set; }

        //[EmailAddress(ErrorMessage = "Invalid email format")]
        //[MaxLength(100)]
        //public string Email2 { get; set; }

        //[Required(ErrorMessage = "Please enter Job Title", AllowEmptyStrings = false)]
        //[MaxLength(50)]
        //public string JobTitle { get; set; }

        //[MaxLength(150)]
        //public string BusinessAddress1 { get; set; }
        //[MaxLength(150)]
        //public string BusinessAddress2 { get; set; }
        //[MaxLength(25)]
        //public string BusinessCity { get; set; }
        //[MaxLength(25)]
        //public string BusinessStateProvince { get; set; }
        //[MaxLength(25)]
        //public string BusinessCountryRegion { get; set; }
        //[MaxLength(10)]
        //public string BusinessZIPPostal { get; set; }

        //[RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        //public string BusinessPhone { get; set; }
        //[RegularExpression(@"^[0-9]{8,25}$", ErrorMessage = "Please enter numeric values only")]
        //public string MobilePhone { get; set; }
        //[RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        //public string HomePhone { get; set; }
        //[RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        //public string Fax { get; set; }

        //public string Notes { get; set; }
        //[MaxLength(50)]
        //public string FullName { get; set; }
        //[MaxLength(50)]
        //public string File { get; set; }

        //public byte[] Image { get; set; }
        //public List<byte> LstImages { get; set; }


        //[Required(ErrorMessage = "Please enter ERP ID", AllowEmptyStrings = false)]
        //[MaxLength(25)]
        //public string ERPID { get; set; }

        //[MaxLength(150)]
        //public string Address3 { get; set; }
        //[MaxLength(150)]
        //public string Address21 { get; set; }
        //[MaxLength(25)]
        //public string City1 { get; set; }
        //[MaxLength(25)]
        //public string State1 { get; set; }
        //[MaxLength(25)]
        //public string Country1 { get; set; }
        //[MaxLength(10)]
        //public string PostalCode1 { get; set; }

        //[RegularExpression(@"^[0-9]{6,25}$", ErrorMessage = "Please enter numeric values only")]
        //public string Ext { get; set; }

        //public string WebURL { get; set; }

        //public string OutlookID { get; set; }

        //public string FileAs { get; set; }

        //public DateTime DateEntered { get; set; }

        //public DateTime DateChanged { get; set; }

        //public string EnteredBy { get; set; }

        //public string ChangedBy { get; set; }

    }
}
