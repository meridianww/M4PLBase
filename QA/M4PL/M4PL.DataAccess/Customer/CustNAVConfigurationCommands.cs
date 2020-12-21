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
// Programmer:                                   Kamal
// Date Programmed:                              17/12/2020
// Program Name:                                 CustNAVConfigurationCommands
// Purpose:                                      Set of rules for CustNAVConfigurationCommands
//==============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
    public class CustNAVConfigurationCommands : BaseCommands<CustNAVConfiguration>
    {

        /// <summary>
        /// Gets list of Customer Dc Location Contact records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<CustNAVConfiguration> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustNAVConfigurationView, EntitiesAlias.CustNAVConfiguration);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static CustNAVConfiguration Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetCustNAVConfiguration);
        }

        /// <summary>
        /// Gets the specific Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public static CustNAVConfiguration Get(ActiveUser activeUser, long id, long? parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            var result = SqlSerializer.Default.DeserializeSingleRecord<CustNAVConfiguration>(StoredProceduresConstant.GetCustNAVConfiguration, parameters.ToArray(), storedProcedure: true);
            return result ?? new CustNAVConfiguration();
        }

        /// <summary>
        /// Creates a new Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="CustNAVConfiguration"></param>
        /// <returns></returns>
        public static CustNAVConfiguration Post(ActiveUser activeUser, CustNAVConfiguration CustNAVConfiguration)
        {
            var parameters = GetParameters(CustNAVConfiguration);
            parameters.AddRange(activeUser.PostDefaultParams(CustNAVConfiguration));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertCustNAVConfiguration);
        }

        /// <summary>
        /// Updates the existing Customer DcLocation Contact record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="CustNAVConfiguration"></param>
        /// <returns></returns>
        public static CustNAVConfiguration Put(ActiveUser activeUser, CustNAVConfiguration CustNAVConfiguration)
        {
            List<Parameter> parameters = null;
            string spName = string.Empty;

            parameters = GetParameters(CustNAVConfiguration);
            spName = StoredProceduresConstant.UpdateCustNAVConfiguration;

            parameters.AddRange(activeUser.PutDefaultParams(CustNAVConfiguration.Id, CustNAVConfiguration));
            return Put(activeUser, parameters, spName);
        }

        /// <summary>
        /// Deletes a specific Customer NAV Configuration record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteCustNAVConfiguration);
            //return 0;
        }

        /// <summary>
        /// Deletes list of Customer NAVConfiguration records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.CustNAVConfiguration, statusId, ReservedKeysEnum.StatusId);
        }
        /// <summary>
		/// Gets list of parameters required for the Customer NAV Configuration Module
		/// </summary>
		/// <param name="custNAVConfiguration"></param>
		/// <returns></returns>
		private static List<Parameter> GetParameters(CustNAVConfiguration custNAVConfiguration)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@NAVConfigurationId", custNAVConfiguration.NAVConfigurationId),
               new Parameter("@ServiceUrl", custNAVConfiguration.ServiceUrl),
               new Parameter("@ServiceUserName", custNAVConfiguration.ServiceUserName),
               new Parameter("@CustomerId",custNAVConfiguration.CustomerId),
               new Parameter("@ServicePassword", custNAVConfiguration.ServicePassword),
               new Parameter("@statusId", custNAVConfiguration.StatusId),
           };

            return parameters;
        }
    }
}
