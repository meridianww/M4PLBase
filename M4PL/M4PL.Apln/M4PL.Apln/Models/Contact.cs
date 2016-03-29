using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4PL_Apln.Models
{
    public class Contact
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Company { get; set; }

        public string JobTitle { get; set; }

        public string Address { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public string Country { get; set; }

        public string PostalCode { get; set; }

        //public int Attachment { get; set; }

        public string BusinessPhone { get; set; }

        public string MobilePhone { get; set; }

        public string HomePhone { get; set; }

        public string Fax { get; set; }

        public string Email { get; set; }

        public string Notes { get; set; }
    }
}