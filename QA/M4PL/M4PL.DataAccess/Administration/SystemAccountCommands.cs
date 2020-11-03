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
// Programmer:                                   Janardana
// Date Programmed:                              17/12/2017
// Program Name:                                 SystemAccountCommands
// Purpose:                                      Contains commands to perform CRUD on SystemAccount
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class SystemAccountCommands : BaseCommands<SystemAccount>
    {
        /// <summary>
        /// Gets list of SystemAccount records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<SystemAccount> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSystemAccountView, EntitiesAlias.SystemAccount, langCode: true);
        }

        /// <summary>
        /// Gets the specific SystemAccount record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static SystemAccount Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetSystemAccount, langCode: true);
        }

        /// <summary>
        /// Creates a new SystemAccount record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemAccount"></param>
        /// <returns></returns>

        public static SystemAccount Post(ActiveUser activeUser, SystemAccount systemAccount)
        {
            var parameters = GetParameters(systemAccount);
            parameters.AddRange(activeUser.PostDefaultParams(systemAccount));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertSystemAccount);
        }

        /// <summary>
        /// Updates the existing SystemAccount record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemAccount"></param>
        /// <returns></returns>

        public static SystemAccount Put(ActiveUser activeUser, SystemAccount systemAccount)
        {
            var parameters = GetParameters(systemAccount);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(systemAccount.Id, systemAccount));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateSystemAccount);
        }

        /// <summary>
        /// Deletes a specific SystemAccount record
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
        ///  Deletes list of SystemAccount records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.SystemAccount, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the SystemAccount Module
        /// </summary>
        /// <param name="systemAccount"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(SystemAccount systemAccount)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@sysUserContactID", systemAccount.SysUserContactID),
               new Parameter("@sysScreenName", systemAccount.SysScreenName),
               new Parameter("@sysPassword", systemAccount.SysPassword),
               new Parameter("@sysOrgId", systemAccount.SysOrgId),
               new Parameter("@actRoleId", systemAccount.SysOrgRefRoleId),
               new Parameter("@statusId", systemAccount.StatusId),
               new Parameter("@sysAttempts", systemAccount.SysAttempts),
               new Parameter("@isSysAdmin", systemAccount.IsSysAdmin),
               new Parameter("@NotScheduleInTransit", systemAccount.NotScheduleInTransit),
               new Parameter("@NotScheduleOnHand", systemAccount.NotScheduleOnHand),
               new Parameter("@NotScheduleOnTruck", systemAccount.NotScheduleOnTruck),
               new Parameter("@NotScheduleReturn", systemAccount.NotScheduleReturn),
               new Parameter("@SchedulePastDueInTransit", systemAccount.SchedulePastDueInTransit),
               new Parameter("@SchedulePastDueOnHand", systemAccount.SchedulePastDueOnHand),
               new Parameter("@SchedulePastDueOnTruck", systemAccount.SchedulePastDueOnTruck),
               new Parameter("@SchedulePastDueReturn", systemAccount.SchedulePastDueReturn),
               new Parameter("@ScheduleForTodayInTransit", systemAccount.ScheduleForTodayInTransit),
               new Parameter("@ScheduleForTodayOnHand", systemAccount.ScheduleForTodayOnHand),
               new Parameter("@ScheduleForTodayOnTruck", systemAccount.ScheduleForTodayOnTruck),
               new Parameter("@ScheduleForTodayReturn", systemAccount.ScheduleForTodayReturn),
               new Parameter("@xCBLAddressChanged", systemAccount.xCBLAddressChanged),
               new Parameter("@xCBL48HoursChanged", systemAccount.xCBL48HoursChanged),
               new Parameter("@NoPODCompletion", systemAccount.NoPODCompletion),
           };
            return parameters;
        }
    }
}