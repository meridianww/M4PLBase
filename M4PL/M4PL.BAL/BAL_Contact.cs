using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL.DataAccess.DAL;

namespace M4PL_BAL
{
	public class BAL_Contact
	{
		public static int InsertContactDetails(Contact contact)
		{
            return DAL_Contact.InsertContactDetails(contact);
		}

		public static int UpdateContactDetails(Contact contact)
		{
			return DAL_Contact.UpdateContactDetails(contact);
		}

		public static int RemoveContact(int ContactID)
		{
			return DAL_Contact.RemoveContact(ContactID);
		}

		public static Contact GetContactDetails(int ContactID)
		{
			return DAL_Contact.GetContactDetails(ContactID);
		}

		public static List<Contact> GetAllContacts()
		{
			return DAL_Contact.GetAllContacts();
		}
	}
}
