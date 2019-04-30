/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustDocReferenceCommands
Purpose:                                      Contains commands to perform CRUD on CustDocReference
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustDocReferenceCommands : BaseCommands<CustDocReference>
    {
        /// <summary>
        /// Gets list of Customer Document Reference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustDocReference> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustDocReferenceView, EntitiesAlias.CustDocReference);
        }

        /// <summary>
        /// Gets the specific Customer Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static CustDocReference Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustDocReference);
        }

        /// <summary>
        /// Creates a new Customer Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDocReference"></param>
        /// <returns></returns>

        public static CustDocReference Post(ActiveUser activeUser, CustDocReference custDocReference)
        {
            var parameters = GetParameters(custDocReference);
            parameters.AddRange(activeUser.PostDefaultParams(custDocReference));

            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustDocReference);
        }

        /// <summary>
        /// Updates the existing Customer Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDocReference"></param>
        /// <returns></returns>

        public static CustDocReference Put(ActiveUser activeUser, CustDocReference custDocReference)
        {
            var parameters = GetParameters(custDocReference);
            parameters.AddRange(activeUser.PutDefaultParams(custDocReference.Id, custDocReference));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustDocReference);
        }

        /// <summary>
        /// Deletes a specific Customer Document Reference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomerDocumentReference);
            return 0;
        }

        /// <summary>
        /// Deletes list of Customer Document Reference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustDocReference, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the  Customer Document Reference Module
        /// </summary>
        /// <param name="custDocReference"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(CustDocReference custDocReference)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@cdrOrgId", custDocReference.OrganizationId),
               new Parameter("@cdrCustomerId", custDocReference.CdrCustomerID),
               new Parameter("@cdrItemNumber", custDocReference.CdrItemNumber),
               new Parameter("@cdrCode", custDocReference.CdrCode),
               new Parameter("@cdrTitle", custDocReference.CdrTitle),
               new Parameter("@docRefTypeId", custDocReference.DocRefTypeId),
               new Parameter("@docCategoryTypeId", custDocReference.DocCategoryTypeId),
               new Parameter("@cdrAttachment", custDocReference.CdrAttachment),
               new Parameter("@cdrDateStart", custDocReference.CdrDateStart),
               new Parameter("@cdrDateEnd", custDocReference.CdrDateEnd),
               new Parameter("@cdrRenewal", custDocReference.CdrRenewal),
               new Parameter("@statusId", custDocReference.StatusId),
           };
            return parameters;
        }
    }
}