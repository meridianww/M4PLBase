/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustomerCommands
Purpose:                                      Contains commands to perform CRUD on Customer
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustomerCommands : BaseCommands<Entities.Customer.Customer>
    {
        /// <summary>
        /// Gets list of Customer records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Customer.Customer> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustomerView, EntitiesAlias.Customer);
        }

        /// <summary>
        /// Gets the specific Customer record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Customer.Customer Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustomer);
        }

        /// <summary>
        /// Creates a new Customer record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="customer"></param>
        /// <returns></returns>

        public static Entities.Customer.Customer Post(ActiveUser activeUser, Entities.Customer.Customer customer)
        {
            var parameters = GetParameters(customer);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(customer));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustomer);
        }

        /// <summary>
        /// Updates the existing Customer record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="customer"></param>
        /// <returns></returns>

        public static Entities.Customer.Customer Put(ActiveUser activeUser, Entities.Customer.Customer customer)
        {
            var parameters = GetParameters(customer);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(customer.Id, customer));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustomer);
        }

        /// <summary>
        /// Deletes a specific Customer record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomer);
        }

        /// <summary>
        /// Deletes list of Customer records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Customer, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer Module
        /// </summary>
        /// <param name="customer"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Customer.Customer customer)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@custERPId", customer.CustERPID),
               new Parameter("@custOrgId", customer.OrganizationId),
               new Parameter("@custItemNumber", customer.CustItemNumber),
               new Parameter("@custCode", customer.CustCode),
               new Parameter("@custTitle", customer.CustTitle),
               new Parameter("@custWorkAddressId", customer.CustWorkAddressId),
               new Parameter("@custBusinessAddressId", customer.CustBusinessAddressId),
               new Parameter("@custCorporateAddressId", customer.CustCorporateAddressId),
               new Parameter("@custContacts", customer.CustContacts),
               new Parameter("@custTypeId", customer.CustTypeId),
               new Parameter("@custTypeCode", customer.CustTypeCode),
               new Parameter("@custWebPage", customer.CustWebPage),
               new Parameter("@statusId", customer.StatusId),
           };
            return parameters;
        }
    }
}