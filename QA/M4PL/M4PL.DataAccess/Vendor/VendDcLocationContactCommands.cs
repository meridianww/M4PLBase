/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendDcLocationContactCommands
Purpose:                                      Contains commands to perform CRUD on VendDcLocationContact
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendDcLocationContactCommands : BaseCommands<VendDcLocationContact>
    {
        /// <summary>
        /// Gets list of Customer Dc Location Contact records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<VendDcLocationContact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendDcLocationContactView, EntitiesAlias.VendDcLocationContact);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static VendDcLocationContact Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendDcLocationContact);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public static VendDcLocationContact Get(ActiveUser activeUser, long id, long? parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<VendDcLocationContact>(StoredProceduresConstant.GetVendDcLocationContact, parameters.ToArray(), storedProcedure: true);
            return result ?? new VendDcLocationContact();
        }

        /// <summary>
        /// Creates a new Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="vendDcLocationContact"></param>
        /// <returns></returns>
        public static VendDcLocationContact Post(ActiveUser activeUser, VendDcLocationContact vendDcLocationContact)
        {
            var parameters = GetParameters(vendDcLocationContact);

            parameters.AddRange(activeUser.PostDefaultParams(vendDcLocationContact));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendDcLocationContact);
        }

        /// <summary>
        /// Updates the existing Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="vendDcLocationContact"></param>
        /// <returns></returns>
        public static VendDcLocationContact Put(ActiveUser activeUser, VendDcLocationContact vendDcLocationContact)
        {
			List<Parameter> parameters = null;
			string spName = string.Empty;
			if (vendDcLocationContact.IsFormView)
			{
				parameters = GetParameters(vendDcLocationContact);
				spName = StoredProceduresConstant.UpdateVendDcLocationContact;
			}
			else
			{
				parameters = GetParameterForBatchEdit(vendDcLocationContact);
				spName = StoredProceduresConstant.BatchUpdateVendDcLocationContact;
			}

            parameters.AddRange(activeUser.PutDefaultParams(vendDcLocationContact.Id, vendDcLocationContact));
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
            return Delete(activeUser, ids, EntitiesAlias.VendDcLocationContact, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer DcLocation Contact Module
        /// </summary>
        /// <param name="vendDcLocationContact"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(VendDcLocationContact vendDcLocationContact)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conVendDcLocationId", vendDcLocationContact.ConPrimaryRecordId),
               new Parameter("@conItemNumber", vendDcLocationContact.ConItemNumber),
               new Parameter("@conContactMSTRID", vendDcLocationContact.ContactMSTRID),
               new Parameter("@conCodeId", vendDcLocationContact.ConCodeId),
               new Parameter("@statusId", vendDcLocationContact.StatusId),
			   new Parameter("@conOrgId", 1),
			   new Parameter("@conContactTitle", vendDcLocationContact.ConTitle)
		   };
            return parameters;
        }

		/// <summary>
		/// Gets list of parameters required for the Customer DcLocation Contact Module
		/// </summary>
		/// <param name="vendDcLocationContact"></param>
		/// <returns></returns>
		private static List<Parameter> GetParameterForBatchEdit(VendDcLocationContact vendDcLocationContact)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@conVendDcLocationId", vendDcLocationContact.ConPrimaryRecordId),
			   new Parameter("@conItemNumber", vendDcLocationContact.ConItemNumber),
			   new Parameter("@conContactMSTRID", vendDcLocationContact.ContactMSTRID),
			   new Parameter("@conCodeId", vendDcLocationContact.ConCodeId),
			   new Parameter("@statusId", vendDcLocationContact.StatusId),
                                           
               //Related to Contact
               new Parameter("@conTitleId", vendDcLocationContact.ConTitleId),
			   new Parameter("@conLastName", vendDcLocationContact.ConLastName),
			   new Parameter("@conFirstName", vendDcLocationContact.ConFirstName),
			   new Parameter("@conMiddleName", vendDcLocationContact.ConMiddleName),
			   new Parameter("@conJobTitle", vendDcLocationContact.ConTitle),
			   new Parameter("@conOrgId", vendDcLocationContact.ConOrgId),
			   new Parameter("@conTypeId", vendDcLocationContact.ConTypeId),
			   new Parameter("@conTableTypeId", vendDcLocationContact.ConTableTypeId),
			   new Parameter("@conEmailAddress", vendDcLocationContact.ConEmailAddress),
			   new Parameter("@conEmailAddress2", vendDcLocationContact.ConEmailAddress2),
			   new Parameter("@conBusinessPhone", vendDcLocationContact.ConBusinessPhone),
			   new Parameter("@conBusinessPhoneExt", vendDcLocationContact.ConBusinessPhoneExt),
			   new Parameter("@conMobilePhone", vendDcLocationContact.ConMobilePhone),
			   new Parameter("@conCompanyId", vendDcLocationContact.ConCompanyId),
		   };
			return parameters;
		}
	}
}
