#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 CustDcLocationCommands
// Purpose:                                      Contains commands to perform CRUD on CustDcLocation
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustDcLocationCommands : BaseCommands<CustDcLocation>
    {
        /// <summary>
        /// Gets list of Customer DcLocation records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustDcLocation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustDcLocationView, EntitiesAlias.CustDcLocation);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static CustDcLocation Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustDcLocation);
        }

        /// <summary>
        /// Creates a new Customer DcLocation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDcLocation"></param>
        /// <returns></returns>

        public static CustDcLocation Post(ActiveUser activeUser, CustDcLocation custDcLocation)
        {
            custDcLocation.OrganizationId = activeUser.OrganizationId;
            var parameters = GetParameters(custDcLocation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(custDcLocation));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustDcLocation);
        }

        /// <summary>
        /// Updates the existing Customer DcLocation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="custDcLocation"></param>
        /// <returns></returns>

        public static CustDcLocation Put(ActiveUser activeUser, CustDcLocation custDcLocation)
        {

            custDcLocation.OrganizationId = activeUser.OrganizationId;
            var parameters = GetParameters(custDcLocation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(custDcLocation.Id, custDcLocation));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustDcLocation);
        }

        /// <summary>
        /// Deletes a specific Customer DcLocation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomerDcLocation);
            return 0;
        }

        /// <summary>
        /// Deletes list of Customer DcLocation records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustDcLocation, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer DcLocation Module
        /// </summary>
        /// <param name="custDcLocation"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(CustDcLocation custDcLocation)
        {
            var parameters = new List<Parameter>
           {

               new Parameter("@conOrgId", custDcLocation.OrganizationId),
               new Parameter("@cdcCustomerId", custDcLocation.CdcCustomerID),
               new Parameter("@cdcItemNumber", custDcLocation.CdcItemNumber),
               new Parameter("@cdcLocationCode", custDcLocation.CdcLocationCode),
               new Parameter("@cdcCustomerCode", custDcLocation.CdcCustomerCode),
               new Parameter("@cdcLocationTitle", custDcLocation.CdcLocationTitle),
               new Parameter("@cdcContactMSTRId", custDcLocation.CdcContactMSTRID),
               new Parameter("@statusId", custDcLocation.StatusId),
           };
            return parameters;
        }
    }
}