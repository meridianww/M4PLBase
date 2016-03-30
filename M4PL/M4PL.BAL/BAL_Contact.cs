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
		public static int InsertContact(Contact contact)
		{
            return DAL_Contact.InsertContactDetails(contact);
		}
	}
}
