/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ContactCommands
Purpose:                                      Contains commands to perform CRUD on Contact
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Contact
{
    public class ContactCommands : BaseCommands<Entities.Contact.Contact>
    {
        /// <summary>
        /// Gets list of Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Contact.Contact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetContactView, EntitiesAlias.Contact);
        }

        /// <summary>
        /// Gets the specific Contact
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Contact.Contact Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetContact);
        }

        /// <summary>
        /// Creates a new Contact
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="contact"></param>
        /// <returns></returns>

        public static Entities.Contact.Contact Post(ActiveUser activeUser, Entities.Contact.Contact contact)
        {
            var parameters = GetParameters(contact,activeUser.OrganizationId.ToString());
            parameters.AddRange(activeUser.PostDefaultParams(contact));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertContact);
        }

        /// <summary>
        /// Updates the existing Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="contact"></param>
        /// <returns></returns>

        public static Entities.Contact.Contact Put(ActiveUser activeUser, Entities.Contact.Contact contact)
        {
            var parameters = GetParameters(contact, activeUser.OrganizationId.ToString());
            parameters.AddRange(activeUser.PutDefaultParams(contact.Id, contact));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateContact);
        }

        /// <summary>
        /// Deletes a specific Contact
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteContact);
            return 0;
        }

        /// <summary>
        /// Deletes list of Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Contact, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Updates the existing Contact card record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="contact"></param>
        /// <returns></returns>

        public static Entities.Contact.Contact PutContactCard(ActiveUser activeUser, Entities.Contact.Contact contact)
        {
            var parameters = GetContactCardUpdateParameters(contact, activeUser.OrganizationId.ToString());
            parameters.AddRange(activeUser.PutDefaultParams(contact.Id, contact));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateContactCard);
        }

        /// <summary>
        /// Check contact is loggedIn or not
        /// </summary>
        /// <param name="contactId"></param>
        /// <returns></returns>

        public static bool CheckContactLoggedIn(long contactId)
        {
            var parameters = new[]
            {
                new Parameter("@id", contactId)
            };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CheckContactLoggedIn, parameters, storedProcedure: true);
        }

        /// <summary>
        /// Gets list of parameters required for the Contacts Module
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Contact.Contact contact,string conOrgId)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conERPId", contact.ConERPId),
               new Parameter("@conOrgId", conOrgId ),
               new Parameter("@conTitleId", contact.ConTitleId),
               new Parameter("@conCompanyName", contact.ConCompanyName),
               new Parameter("@conLastName", contact.ConLastName),
               new Parameter("@conFirstName", contact.ConFirstName),
               new Parameter("@conMiddleName", contact.ConMiddleName),
               new Parameter("@conEmailAddress", contact.ConEmailAddress),
               new Parameter("@conEmailAddress2", contact.ConEmailAddress2),
               new Parameter("@conJobTitle", contact.ConJobTitle),
               new Parameter("@conBusinessPhone", contact.ConBusinessPhone),
               new Parameter("@conBusinessPhoneExt", contact.ConBusinessPhoneExt),
               new Parameter("@conHomePhone", contact.ConHomePhone),
               new Parameter("@conMobilePhone", contact.ConMobilePhone),
               new Parameter("@conFaxNumber", contact.ConFaxNumber),
               new Parameter("@conBusinessAddress1", contact.ConBusinessAddress1),
               new Parameter("@conBusinessAddress2", contact.ConBusinessAddress2),
               new Parameter("@conBusinessCity", contact.ConBusinessCity),
               new Parameter("@conBusinessStateId", contact.ConBusinessStateId),
               new Parameter("@conBusinessZipPostal", contact.ConBusinessZipPostal),
               new Parameter("@conBusinessCountryId", contact.ConBusinessCountryId),
               new Parameter("@conHomeAddress1", contact.ConHomeAddress1),
               new Parameter("@conHomeAddress2", contact.ConHomeAddress2),
               new Parameter("@conHomeCity", contact.ConHomeCity),
               new Parameter("@conHomeStateId", contact.ConHomeStateId),
               new Parameter("@conHomeZipPostal", contact.ConHomeZipPostal),
               new Parameter("@conHomeCountryId", contact.ConHomeCountryId),
               new Parameter("@conAttachments", contact.ConAttachments),
               new Parameter("@conWebPage", contact.ConWebPage),
               new Parameter("@conNotes", contact.ConNotes),
               new Parameter("@statusId", contact.StatusId),
               new Parameter("@conTypeId", contact.ConTypeId),
               new Parameter("@conOutlookId", contact.ConOutlookId),
               new Parameter("@conUDF01", contact.ConUDF01),
               new Parameter("@conCompanyId", contact.ConCompanyId),
               new Parameter("@jobSiteCode", contact.JobSiteCode),
               new Parameter("@parentId", contact.ParentId)

           };
            return parameters;
        }

        private static List<Parameter> GetContactCardUpdateParameters(Entities.Contact.Contact contact, string conOrgId)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conTitleId", contact.ConTitleId),
               new Parameter("@conFirstName", contact.ConFirstName),
               new Parameter("@conMiddleName", contact.ConMiddleName),
               new Parameter("@conLastName", contact.ConLastName),
               new Parameter("@conJobTitle", contact.ConJobTitle),
               new Parameter("@conOrgId", conOrgId ),
               new Parameter("@conTypeId", contact.ConTypeId),
               new Parameter("@conBusinessPhone", contact.ConBusinessPhone),
               new Parameter("@conBusinessPhoneExt", contact.ConBusinessPhoneExt),
               new Parameter("@conMobilePhone", contact.ConMobilePhone),
               new Parameter("@conEmailAddress", contact.ConEmailAddress),
               new Parameter("@conEmailAddress2", contact.ConEmailAddress2),
               new Parameter("@conBusinessAddress1", contact.ConBusinessAddress1),
               new Parameter("@conBusinessAddress2", contact.ConBusinessAddress2),
               new Parameter("@conBusinessCity", contact.ConBusinessCity),
               new Parameter("@conBusinessStateId", contact.ConBusinessStateId),
               new Parameter("@conBusinessZipPostal", contact.ConBusinessZipPostal),
               new Parameter("@conBusinessCountryId", contact.ConBusinessCountryId),
           };
            return parameters;
        }
    }
}