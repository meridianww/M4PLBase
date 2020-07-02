#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendReportCommands : BaseCommands<VendReport>
    {
        /// <summary>
        /// Gets list of Vendor records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<VendReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.VendReport);
        }

        /// <summary>
        /// Gets the specific Vendor record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static VendReport Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
        }

        /// <summary>
        /// Creates a new Vendor record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="vendReport"></param>
        /// <returns></returns>

        public static VendReport Post(ActiveUser activeUser, VendReport vendReport)
        {
            var parameters = GetParameters(vendReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(vendReport));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
        }

        /// <summary>
        /// Updates the existing Vendor record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="vendReport"></param>
        /// <returns></returns>

        public static VendReport Put(ActiveUser activeUser, VendReport vendReport)
        {
            var parameters = GetParameters(vendReport);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(vendReport.Id, vendReport));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
        }

        /// <summary>
        /// Deletes a specific Vendor record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            return Delete(activeUser, id, StoredProceduresConstant.DeleteVendor);
        }

        /// <summary>
        /// Deletes list of Vendor records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Vendor, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Vendor Module
        /// </summary>
        /// <param name="VendReport"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(VendReport VendReport)
        {
            var parameters = new List<Parameter>
            {
            };
            return parameters;
        }
    }
}