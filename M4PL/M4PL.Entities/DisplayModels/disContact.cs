using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class disContact
    {
        public Contact contact { get; set; }
        public List<Contact> lstContacts { get; set; }

        public disContact()
        {
            this.contact = new Contact();
            this.lstContacts = new List<Contact>();
        }

        public disContact(Contact contact, List<Contact> lst)
        {
            this.contact = contact;
            this.lstContacts = lst;
        }
    }
}
