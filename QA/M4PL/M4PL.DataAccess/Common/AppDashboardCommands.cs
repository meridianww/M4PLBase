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
using System.Collections.Generic;

namespace M4PL.DataAccess.Common
{
    public class AppDashboardCommands : BaseCommands<AppDashboard>
    {
        /// <summary>
        /// Gets the list of Meudriver Details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<AppDashboard> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetDashboardView, EntitiesAlias.AppDashboard, langCode: true);
        }

        /// <summary>
        /// Gets the specific menu driver record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static AppDashboard Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetDashboard, langCode: true);
        }

        /// <summary>
        /// Creates a new record for menu driver in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="Dashboard"></param>
        /// <returns></returns>

        public static AppDashboard Post(ActiveUser activeUser, AppDashboard Dashboard)
        {
            var parameters = GetParameters(Dashboard);
            // parameters.Add(new Parameter("@langCode", Dashboard.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(Dashboard));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertDashboard);
        }

        /// <summary>
        /// updates the record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="Dashboard"></param>
        /// <returns></returns>

        public static AppDashboard Put(ActiveUser activeUser, AppDashboard Dashboard)
        {
            var parameters = GetParameters(Dashboard);
            // parameters.Add(new Parameter("@langCode", Dashboard.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(Dashboard.Id, Dashboard));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateDashboard);
        }

        /// <summary>
        /// Deletes a specific record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
            return 0;
        }

        /// <summary>
        /// Deletes a list of record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.AppDashboard, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the required parameters for the  menu driver Module
        /// </summary>
        /// <param name="Dashboard"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(AppDashboard Dashboard)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@orgId", Dashboard.OrganizationId),
                new Parameter("@mainModuleId", Dashboard.DshMainModuleId),
                new Parameter("@dashboardName", Dashboard.DshName),
                new Parameter("@dashboardDesc", Dashboard.DshDescription),
                new Parameter("@isDefault", Dashboard.DshIsDefault),
                new Parameter("@statusId", Dashboard.StatusId),
            };
            return parameters;
        }
    }
}