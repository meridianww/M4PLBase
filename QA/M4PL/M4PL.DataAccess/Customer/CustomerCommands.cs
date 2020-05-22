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

		public static IList<Entities.Customer.Customer> Get(ActiveUser activeUser)
		{
			return Get(activeUser, StoredProceduresConstant.GetCustomers);
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
		/// Updates the existing Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="customer"></param>
		/// <returns></returns>

		public static Entities.Customer.Customer Patch(ActiveUser activeUser, Entities.Customer.Customer customer)
		{
			var parameters = GetPartialParameters(customer);
			parameters.AddRange(activeUser.PutDefaultParams(customer.Id, customer));
			return Patch(activeUser, parameters, StoredProceduresConstant.UpdatePartialCustomer);
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
			   new Parameter("@custWorkAddressId", customer.CustWorkAddressId.HasValue &&  customer.CustWorkAddressId > 0 ? customer.CustWorkAddressId : null),
			   new Parameter("@custBusinessAddressId", customer.CustBusinessAddressId.HasValue &&  customer.CustBusinessAddressId > 0 ? customer.CustBusinessAddressId : null),
			   new Parameter("@custCorporateAddressId", customer.CustCorporateAddressId.HasValue &&  customer.CustCorporateAddressId > 0 ? customer.CustCorporateAddressId : null),
			   new Parameter("@custContacts", customer.CustContacts),
			   new Parameter("@custTypeId", customer.CustTypeId),
			   new Parameter("@custTypeCode", customer.CustTypeCode),
			   new Parameter("@custWebPage", customer.CustWebPage),
			   new Parameter("@statusId", customer.StatusId),
			   new Parameter("@BusinessAddress1", customer.BusinessAddress1),
			   new Parameter("@BusinessAddress2", customer.BusinessAddress2),
			   new Parameter("@BusinessCity", customer.BusinessCity),
			   new Parameter("@BusinessZipPostal", customer.BusinessZipPostal),
			   new Parameter("@BusinessStateId", customer.BusinessStateId),
			   new Parameter("@BusinessCountryId", customer.BusinessCountryId),
			   new Parameter("@CorporateAddress1", customer.CorporateAddress1),
			   new Parameter("@CorporateAddress2", customer.CorporateAddress2),
			   new Parameter("@CorporateCity", customer.CorporateCity),
			   new Parameter("@CorporateZipPostal", customer.CorporateZipPostal),
			   new Parameter("@CorporateStateId", customer.CorporateStateId),
			   new Parameter("@CorporateCountryId", customer.CorporateCountryId),
			   new Parameter("@WorkAddress1", customer.WorkAddress1),
			   new Parameter("@WorkAddress2", customer.WorkAddress2),
			   new Parameter("@WorkCity", customer.WorkCity),
			   new Parameter("@WorkZipPostal", customer.WorkZipPostal),
			   new Parameter("@WorkStateId", customer.WorkStateId),
			   new Parameter("@WorkCountryId", customer.WorkCountryId),
			};
			return parameters;
		}

		private static List<Parameter> GetPartialParameters(Entities.Customer.Customer customer)
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

        public static List<Entities.Customer.Customer> GetActiveCutomers()
        {
            var parameters = new List<Parameter>
           {
             
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<Entities.Customer.Customer>(StoredProceduresConstant.GetActiveCustomers, parameters.ToArray(), storedProcedure: true);
            return result;
        }
    }
}