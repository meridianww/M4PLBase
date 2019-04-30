/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              06/08/2018
Program Name:                                 StatusLog Db Commands
Purpose:                                      Contains objects related to StatusLog Db Execution
==========================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class StatusLogCommands : BaseCommands<StatusLog>
    {
        /// <summary>
        /// Gets list of deliveryStatus records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<StatusLog> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSystemStatusLogView, EntitiesAlias.StatusLog);
        }
    }
}
