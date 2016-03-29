using M4PL.DataAccess.Serializer;
using M4PL_API_CommonUtils.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess
{
	public class ContactSqlCommand
	{
		public ContactSqlCommand()
		{
		}
		public bool InsertContactDetails(Contact contact)
		{
			var parameters = new Parameter[]
				{
					new Parameter("@FirstName",contact.FirstName),
					new Parameter("@LastName",contact.LastName),
					new Parameter("@Company",contact.Company),
					new Parameter("@JobTitle",contact.JobTitle),
					new Parameter("@Address",contact.Address),
					new Parameter("@City",contact.City),
					new Parameter("@State",contact.State),
					new Parameter("@Country",contact.Country),
					new Parameter("@PostalCode",contact.PostalCode)
				};

			var result = SqlSerializer.Default.DeserializeSingleRecord("dbo.spInsertContact", parameters, false, true);
			return true;
		}
	}
}
