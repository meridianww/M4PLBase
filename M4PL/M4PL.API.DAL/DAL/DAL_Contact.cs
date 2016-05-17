//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              11/4/2016
//Program Name:                                 Contact
//Purpose:                                      Create, access, and review data from database for Contact 
//
//==================================================================================================================================================== 

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
        /// <summary>
        /// Function to Save contact details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int InsertContactDetails(Contact contact)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@Attachments",contact.ConAttachments),
				new Parameter("@BusinessAddress1",contact.ConBusinessAddress1),
				new Parameter("@BusinessAddress2",contact.ConBusinessAddress2),
				new Parameter("@BusinessCity",contact.ConBusinessCity),
				new Parameter("@BusinessCountryRegion",contact.ConBusinessCountryRegion),
				new Parameter("@BusinessPhone",contact.ConBusinessPhone),
				new Parameter("@BusinessPhoneExt",contact.ConBusinessPhoneExt),
				new Parameter("@BusinessStateProvince",contact.ConBusinessStateProvince),
				new Parameter("@BusinessZIPPostal",contact.ConBusinessZIPPostal),
				new Parameter("@Company",contact.ConCompany),
				new Parameter("@EmailAddress",contact.ConEmailAddress),
				new Parameter("@EmailAddress2",contact.ConEmailAddress2),
				new Parameter("@ERPID",contact.ConERPID),
				new Parameter("@FaxNumber",contact.ConFaxNumber),
				new Parameter("@FileAs",contact.ConFileAs),
				new Parameter("@FirstName",contact.ConFirstName),
				new Parameter("@FullName",contact.ConFullName),
				new Parameter("@HomeAddress1",contact.ConHomeAddress1),
				new Parameter("@HomeAddress2",contact.ConHomeAddress2),
				new Parameter("@HomeCity",contact.ConHomeCity),
				new Parameter("@HomeCountryRegion",contact.ConHomeCountryRegion),
				new Parameter("@HomePhone",contact.ConHomePhone),
				new Parameter("@HomeStateProvince",contact.ConHomeStateProvince),
				new Parameter("@HomeZIPPostal",contact.ConHomeZIPPostal),
				new Parameter("@Image",contact.ConImage),
				new Parameter("@JobTitle",contact.ConJobTitle),
				new Parameter("@LastName",contact.ConLastName),
				new Parameter("@MiddleName",contact.ConMiddleName),
				new Parameter("@MobilePhone",contact.ConMobilePhone),
				new Parameter("@Notes",contact.ConNotes),
				new Parameter("@OutlookID",contact.ConOutlookID),
				new Parameter("@Status",contact.ConStatus),
				new Parameter("@Title",contact.ConTitle),
				new Parameter("@Type",contact.ConType),
				new Parameter("@WebPage",contact.ConWebPage),
				new Parameter("@DateEnteredBy",contact.ConDateEnteredBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.InsertContact, parameters, true);
        }

        /// <summary>
        /// Function to Update contact details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int UpdateContactDetails(Contact contact)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",contact.ContactID),
				new Parameter("@Attachments",contact.ConAttachments),
				new Parameter("@BusinessAddress1",contact.ConBusinessAddress1),
				new Parameter("@BusinessAddress2",contact.ConBusinessAddress2),
				new Parameter("@BusinessCity",contact.ConBusinessCity),
				new Parameter("@BusinessCountryRegion",contact.ConBusinessCountryRegion),
				new Parameter("@BusinessPhone",contact.ConBusinessPhone),
				new Parameter("@BusinessPhoneExt",contact.ConBusinessPhoneExt),
				new Parameter("@BusinessStateProvince",contact.ConBusinessStateProvince),
				new Parameter("@BusinessZIPPostal",contact.ConBusinessZIPPostal),
				new Parameter("@Company",contact.ConCompany),
				new Parameter("@EmailAddress",contact.ConEmailAddress),
				new Parameter("@EmailAddress2",contact.ConEmailAddress2),
				new Parameter("@ERPID",contact.ConERPID),
				new Parameter("@FaxNumber",contact.ConFaxNumber),
				new Parameter("@FileAs",contact.ConFileAs),
				new Parameter("@FirstName",contact.ConFirstName),
				new Parameter("@FullName",contact.ConFullName),
				new Parameter("@HomeAddress1",contact.ConHomeAddress1),
				new Parameter("@HomeAddress2",contact.ConHomeAddress2),
				new Parameter("@HomeCity",contact.ConHomeCity),
				new Parameter("@HomeCountryRegion",contact.ConHomeCountryRegion),
				new Parameter("@HomePhone",contact.ConHomePhone),
				new Parameter("@HomeStateProvince",contact.ConHomeStateProvince),
				new Parameter("@HomeZIPPostal",contact.ConHomeZIPPostal),
				new Parameter("@Image",contact.ConImage),
				new Parameter("@JobTitle",contact.ConJobTitle),
				new Parameter("@LastName",contact.ConLastName),
				new Parameter("@MiddleName",contact.ConMiddleName),
				new Parameter("@MobilePhone",contact.ConMobilePhone),
				new Parameter("@Notes",contact.ConNotes),
				new Parameter("@OutlookID",contact.ConOutlookID),
				new Parameter("@Status",contact.ConStatus),
				new Parameter("@Title",contact.ConTitle),
				new Parameter("@Type",contact.ConType),
				new Parameter("@WebPage",contact.ConWebPage),
				new Parameter("@DateChangedBy",contact.ConDateChangedBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.UpdateContact, parameters, true);
        }

        /// <summary>
        /// Function to Delete contact details
        /// </summary>
        /// <param name="ContactID"></param>
        /// <returns></returns>
        public static int RemoveContact(int ContactID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",ContactID)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveContact, parameters, true);
        }

        /// <summary>
        /// Function to get the details of selected contact
        /// </summary>
        /// <param name="ContactID"></param>
        /// <returns></returns>
        public static Contact GetContactDetails(int ContactID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@ContactID",ContactID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<Contact>(StoredProcedureNames.GetContactDetails, parameters, false, true);
        }

        /// <summary>
        /// Function to get the list of all contacts
        /// </summary>
        /// <returns></returns>
        public static List<Contact> GetAllContacts(int UserId = 0)
        {
            return SqlSerializer.Default.DeserializeMultiRecords<Contact>(StoredProcedureNames.GetAllContacts, new Parameter("@ColUserId", UserId), false, true);
        }

    }
}
