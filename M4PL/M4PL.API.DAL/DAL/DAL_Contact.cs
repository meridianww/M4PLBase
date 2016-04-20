using M4PL.DataAccess.Serializer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;
using M4PL_API_CommonUtils;

namespace M4PL.DataAccess.DAL
{
    public class DAL_Contact
    {
        public static int InsertContactDetails(Contact contact)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@Title",contact.Title),
				new Parameter("@FirstName",contact.FirstName),
				new Parameter("@LastName",contact.LastName),
				new Parameter("@Company",contact.Company),
				new Parameter("@JobTitle",contact.JobTitle),
				new Parameter("@Address",contact.Address),
				new Parameter("@City",contact.City),
				new Parameter("@State",contact.State),
				new Parameter("@Country",contact.Country),
				new Parameter("@PostalCode",contact.PostalCode),
				new Parameter("@BusinessPhone",contact.BusinessPhone),
				new Parameter("@MobilePhone",contact.MobilePhone),
				new Parameter("@Email",contact.Email),
				new Parameter("@HomePhone",contact.HomePhone),
				new Parameter("@Fax",contact.Fax),
				new Parameter("@Image",contact.Image),
				new Parameter("@Notes",contact.Notes)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.InsertContact, parameters, true);
        }

        public static int UpdateContactDetails(Contact contact)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",contact.ContactID),
				new Parameter("@Title",contact.Title),
				new Parameter("@FirstName",contact.FirstName),
				new Parameter("@LastName",contact.LastName),
				new Parameter("@Company",contact.Company),
				new Parameter("@JobTitle",contact.JobTitle),
				new Parameter("@Address",contact.Address),
				new Parameter("@City",contact.City),
				new Parameter("@State",contact.State),
				new Parameter("@Country",contact.Country),
				new Parameter("@PostalCode",contact.PostalCode),
				new Parameter("@BusinessPhone",contact.BusinessPhone),
				new Parameter("@MobilePhone",contact.MobilePhone),
				new Parameter("@Email",contact.Email),
				new Parameter("@HomePhone",contact.HomePhone),
				new Parameter("@Fax",contact.Fax),
				new Parameter("@Image",contact.Image),
				new Parameter("@Notes",contact.Notes)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.UpdateContact, parameters, true);
        }

        public static int RemoveContact(int ContactID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",ContactID)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveContact, parameters, true);
        }

        public static Contact GetContactDetails(int ContactID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",ContactID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<Contact>(StoredProcedureNames.GetContactDetails, parameters, false, true);
        }

        public static List<Contact> GetAllContacts()
        {
            return SqlSerializer.Default.DeserializeMultiRecords<Contact>(StoredProcedureNames.GetAllContacts, new Parameter[] { }, false, true);
        }

    }
}
