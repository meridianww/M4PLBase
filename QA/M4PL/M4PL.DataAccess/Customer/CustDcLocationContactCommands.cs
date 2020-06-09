/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustDcLocationContactCommands
Purpose:                                      Contains commands to perform CRUD on CustDcLocationContact
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustDcLocationContactCommands : BaseCommands<CustDcLocationContact>
    {
        /// <summary>
        /// Gets list of Customer Dc Location Contact records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustDcLocationContact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustDcLocationContactView, EntitiesAlias.CustDcLocationContact);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static CustDcLocationContact Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustDcLocationContact);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public static CustDcLocationContact Get(ActiveUser activeUser, long id, long? parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<CustDcLocationContact>(StoredProceduresConstant.GetCustDcLocationContact, parameters.ToArray(), storedProcedure: true);
            return result ?? new CustDcLocationContact();
        }

        /// <summary>
        /// Creates a new Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDcLocationContact"></param>
        /// <returns></returns>
        public static CustDcLocationContact Post(ActiveUser activeUser, CustDcLocationContact custDcLocationContact)
        {
            var parameters = GetParameters(custDcLocationContact);
            parameters.AddRange(activeUser.PostDefaultParams(custDcLocationContact));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustDcLocationContact);
        }

        /// <summary>
        /// Updates the existing Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDcLocationContact"></param>
        /// <returns></returns>
        public static CustDcLocationContact Put(ActiveUser activeUser, CustDcLocationContact custDcLocationContact)
        {
            List<Parameter> parameters = null;
            string spName = string.Empty;
            if (custDcLocationContact.IsFormView)
            {
                parameters = GetParameters(custDcLocationContact);
                spName = StoredProceduresConstant.UpdateCustDcLocationContact;
            }
            else
            {
                parameters = GetParameterForBatchEdit(custDcLocationContact);
                spName = StoredProceduresConstant.BatchUpdateCustDcLocationContact;
            }

            parameters.AddRange(activeUser.PutDefaultParams(custDcLocationContact.Id, custDcLocationContact));
            return Put(activeUser, parameters, spName);
        }

        /// <summary>
        /// Deletes a specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomerDcLocationContact);
            return 0;
        }

        /// <summary>
        /// Deletes list of Customer DcLocation Contact records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustDcLocationContact, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer DcLocation Contact Module
        /// </summary>
        /// <param name="custDcLocationContact"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(CustDcLocationContact custDcLocationContact)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conCustDcLocationId", custDcLocationContact.ConPrimaryRecordId),
               new Parameter("@conItemNumber", custDcLocationContact.ConItemNumber),
               new Parameter("@conContactTitle", custDcLocationContact.ConTitle),
               new Parameter("@conContactMSTRID", custDcLocationContact.ContactMSTRID),
               new Parameter("@statusId", custDcLocationContact.StatusId),
               new Parameter("@conOrgId", 1),
               new Parameter("@conCodeId", custDcLocationContact.ConCodeId)
           };

            return parameters;
        }

        /// <summary>
        /// Gets list of parameters required for the Customer DcLocation Contact Module
        /// </summary>
        /// <param name="custDcLocationContact"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameterForBatchEdit(CustDcLocationContact custDcLocationContact)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conCustDcLocationId", custDcLocationContact.ConPrimaryRecordId),
               new Parameter("@conItemNumber", custDcLocationContact.ConItemNumber),
               new Parameter("@conContactTitle", custDcLocationContact.ConTitle),
               new Parameter("@conContactMSTRID", custDcLocationContact.ContactMSTRID),
               new Parameter("@statusId", custDcLocationContact.StatusId),

               //Related to Contact
               new Parameter("@conTitleId", custDcLocationContact.ConTitleId),
               new Parameter("@conLastName", custDcLocationContact.ConLastName),
               new Parameter("@conFirstName", custDcLocationContact.ConFirstName),
               new Parameter("@conMiddleName", custDcLocationContact.ConMiddleName),
               new Parameter("@conJobTitle", custDcLocationContact.ConJobTitle),
               new Parameter("@conOrgId", custDcLocationContact.ConOrgId),
               new Parameter("@conTypeId", custDcLocationContact.ConTypeId),
               new Parameter("@conCodeId", custDcLocationContact.ConCodeId),
               new Parameter("@conEmailAddress", custDcLocationContact.ConEmailAddress),
               new Parameter("@conEmailAddress2", custDcLocationContact.ConEmailAddress2),
               new Parameter("@conBusinessPhone", custDcLocationContact.ConBusinessPhone),
               new Parameter("@conBusinessPhoneExt", custDcLocationContact.ConBusinessPhoneExt),
               new Parameter("@conMobilePhone", custDcLocationContact.ConMobilePhone),
               new Parameter("@conCompanyId", custDcLocationContact.ConCompanyId),
           };
            return parameters;
        }
    }
}
