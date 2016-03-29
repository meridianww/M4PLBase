using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL_API_CommonUtils.Model;
using M4PL.DataAccess;

namespace M4PL_BAL.ServerCommand
{
	public class ContactServerCommand
	{
		public ContactServerCommand()
		{

		}

		public bool InsertContact(Contact contact)
		{
			ContactSqlCommand contactSqlCommand = new ContactSqlCommand();
			return contactSqlCommand.InsertContactDetails(contact);
		}
	}
}
