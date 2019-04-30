/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustBusinessTermCommands
Purpose:                                      Contains commands to perform CRUD on CustBusinessTerm
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustBusinessTermCommands : BaseCommands<CustBusinessTerm>
    {
        /// <summary>
        /// Gets list of Customer Businessterms
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustBusinessTerm> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustBusinessTermView, EntitiesAlias.CustBusinessTerm, langCode: true);
        }

        /// <summary>
        /// Gets the specific Customer Businessterms
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static CustBusinessTerm Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustBusinessTerm, langCode: true);
        }

        /// <summary>
        /// Creates a new Customer Businessterms
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custBusinessTerm"></param>
        /// <returns></returns>

        public static CustBusinessTerm Post(ActiveUser activeUser, CustBusinessTerm custBusinessTerm)
        {
            var parameters = GetParameters(custBusinessTerm);
            parameters.AddRange(activeUser.PostDefaultParams(custBusinessTerm));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustBusinessTerm);
        }

        /// <summary>
        /// Updates the existing Customer Businessterms
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custBusinessTerm"></param>
        /// <returns></returns>

        public static CustBusinessTerm Put(ActiveUser activeUser, CustBusinessTerm custBusinessTerm)
        {
            var parameters = GetParameters(custBusinessTerm);
            parameters.AddRange(activeUser.PutDefaultParams(custBusinessTerm.Id, custBusinessTerm));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustBusinessTerm);
        }

        /// <summary>
        /// Deletes a specific Customer Businessterms
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomerBusinessTerm);
            return 0;
        }

        /// <summary>
        /// Deletes list of Customer Businessterms records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustBusinessTerm, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer Businessterms Module
        /// </summary>
        /// <param name="custBusinessTerm"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(CustBusinessTerm custBusinessTerm)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@langCode", custBusinessTerm.LangCode),
               new Parameter("@cbtOrgId", custBusinessTerm.OrganizationId),
               new Parameter("@cbtCustomerId", custBusinessTerm.CbtCustomerId),
               new Parameter("@cbtItemNumber", custBusinessTerm.CbtItemNumber),
               new Parameter("@cbtCode", custBusinessTerm.CbtCode),
               new Parameter("@cbtTitle", custBusinessTerm.CbtTitle),
               new Parameter("@businessTermTypeId", custBusinessTerm.BusinessTermTypeId),
               new Parameter("@cbtActiveDate", custBusinessTerm.CbtActiveDate),
               new Parameter("@cbtValue", custBusinessTerm.CbtValue),
               new Parameter("@cbtHiThreshold", custBusinessTerm.CbtHiThreshold),
               new Parameter("@cbtLoThreshold", custBusinessTerm.CbtLoThreshold),
               new Parameter("@cbtAttachment", custBusinessTerm.CbtAttachment),
               new Parameter("@statusId", custBusinessTerm.StatusId),
           };
            return parameters;
        }
    }
}