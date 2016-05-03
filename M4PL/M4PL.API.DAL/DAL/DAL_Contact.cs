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
				new Parameter("@Attachments",contact.Attachments),
				new Parameter("@BusinessAddress1",contact.BusinessAddress1),
				new Parameter("@BusinessAddress2",contact.BusinessAddress2),
				new Parameter("@BusinessCity",contact.BusinessCity),
				new Parameter("@BusinessCountryRegion",contact.BusinessCountryRegion),
				new Parameter("@BusinessPhone",contact.BusinessPhone),
				new Parameter("@BusinessPhoneExt",contact.BusinessPhoneExt),
				new Parameter("@BusinessStateProvince",contact.BusinessStateProvince),
				new Parameter("@BusinessZIPPostal",contact.BusinessZIPPostal),
				new Parameter("@Company",contact.Company),
				new Parameter("@EmailAddress",contact.EmailAddress),
				new Parameter("@EmailAddress2",contact.EmailAddress2),
				new Parameter("@ERPID",contact.ERPID),
				new Parameter("@FaxNumber",contact.FaxNumber),
				new Parameter("@FileAs",contact.FileAs),
				new Parameter("@FirstName",contact.FirstName),
				new Parameter("@FullName",contact.FullName),
				new Parameter("@HomeAddress1",contact.HomeAddress1),
				new Parameter("@HomeAddress2",contact.HomeAddress2),
				new Parameter("@HomeCity",contact.HomeCity),
				new Parameter("@HomeCountryRegion",contact.HomeCountryRegion),
				new Parameter("@HomePhone",contact.HomePhone),
				new Parameter("@HomeStateProvince",contact.HomeStateProvince),
				new Parameter("@HomeZIPPostal",contact.HomeZIPPostal),
				new Parameter("@Image",contact.Image),
				new Parameter("@JobTitle",contact.JobTitle),
				new Parameter("@LastName",contact.LastName),
				new Parameter("@MiddleName",contact.MiddleName),
				new Parameter("@MobilePhone",contact.MobilePhone),
				new Parameter("@Notes",contact.Notes),
				new Parameter("@OutlookID",contact.OutlookID),
				new Parameter("@Status",contact.Status),
				new Parameter("@Title",contact.Title),
				new Parameter("@Type",contact.Type),
				new Parameter("@WebPage",contact.WebPage),
				new Parameter("@DateEnteredBy",contact.DateEnteredBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.InsertContact, parameters, true);
        }

        public static int UpdateContactDetails(Contact contact)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",contact.ContactID),
				new Parameter("@Attachments",contact.Attachments),
				new Parameter("@BusinessAddress1",contact.BusinessAddress1),
				new Parameter("@BusinessAddress2",contact.BusinessAddress2),
				new Parameter("@BusinessCity",contact.BusinessCity),
				new Parameter("@BusinessCountryRegion",contact.BusinessCountryRegion),
				new Parameter("@BusinessPhone",contact.BusinessPhone),
				new Parameter("@BusinessPhoneExt",contact.BusinessPhoneExt),
				new Parameter("@BusinessStateProvince",contact.BusinessStateProvince),
				new Parameter("@BusinessZIPPostal",contact.BusinessZIPPostal),
				new Parameter("@Company",contact.Company),
				new Parameter("@EmailAddress",contact.EmailAddress),
				new Parameter("@EmailAddress2",contact.EmailAddress2),
				new Parameter("@ERPID",contact.ERPID),
				new Parameter("@FaxNumber",contact.FaxNumber),
				new Parameter("@FileAs",contact.FileAs),
				new Parameter("@FirstName",contact.FirstName),
				new Parameter("@FullName",contact.FullName),
				new Parameter("@HomeAddress1",contact.HomeAddress1),
				new Parameter("@HomeAddress2",contact.HomeAddress2),
				new Parameter("@HomeCity",contact.HomeCity),
				new Parameter("@HomeCountryRegion",contact.HomeCountryRegion),
				new Parameter("@HomePhone",contact.HomePhone),
				new Parameter("@HomeStateProvince",contact.HomeStateProvince),
				new Parameter("@HomeZIPPostal",contact.HomeZIPPostal),
				new Parameter("@Image",contact.Image),
				new Parameter("@JobTitle",contact.JobTitle),
				new Parameter("@LastName",contact.LastName),
				new Parameter("@MiddleName",contact.MiddleName),
				new Parameter("@MobilePhone",contact.MobilePhone),
				new Parameter("@Notes",contact.Notes),
				new Parameter("@OutlookID",contact.OutlookID),
				new Parameter("@Status",contact.Status),
				new Parameter("@Title",contact.Title),
				new Parameter("@Type",contact.Type),
				new Parameter("@WebPage",contact.WebPage),
				new Parameter("@DateChangedBy",contact.DateChangedBy)
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
