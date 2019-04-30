/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustContactCommands
Purpose:                                      Contains commands to perform CRUD on CustContact
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustContactCommands : BaseCommands<CustContact>
    {
        /// <summary>
        /// Gets list of Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustContact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustContactView, EntitiesAlias.CustContact);
        }

        /// <summary>
        /// Gets the specific Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static CustContact Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustContact);
        }

        /// <summary>
        /// Creates a new Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custContact"></param>
        /// <returns></returns>

        public static CustContact Post(ActiveUser activeUser, CustContact custContact)
        {
            var parameters = GetParameters(custContact, activeUser.OrganizationId.ToString());
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(custContact));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustContact);
        }

        /// <summary>
        /// Updates the existing Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custContact"></param>
        /// <returns></returns>

        public static CustContact Put(ActiveUser activeUser, CustContact custContact)
        {
            var parameters = GetParameters(custContact, activeUser.OrganizationId.ToString());
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(custContact.Id, custContact));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustContact);
        }

        /// <summary>
        /// Deletes a specific Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteCustContact);
        }

        /// <summary>
        /// Deletes list of Customer Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustContact, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer Contacts Module
        /// </summary>
        /// <param name="custContact"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(CustContact custContact, string orgId)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", orgId ),
               new Parameter("@custCustomerId", custContact.ConPrimaryRecordId),
               new Parameter("@custItemNumber", custContact.ConItemNumber),
               new Parameter("@custContactCode", custContact.ConCode),
               new Parameter("@custContactTitle", custContact.ConTitle),
               new Parameter("@custContactMSTRId", custContact.ContactMSTRID),
               new Parameter("@statusId", custContact.StatusId),
           };
            return parameters;
        }
    }
}