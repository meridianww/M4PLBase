#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              06/06/2018
// Program Name:                                 DeliveryStatusCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.DeliveryStatusCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.StatusLogCommands;

namespace M4PL.Business.Administration
{
    public class StatusLogCommands : BaseCommands<StatusLog>, IStatusLogCommands
    {
        /// <summary>
        /// Get list of StatusLog data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<StatusLog> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific StatusLog record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public StatusLog Get(long id)
        {
            return new StatusLog();// _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new StatusLog record
        /// </summary>
        /// <param name="StatusLog"></param>
        /// <returns></returns>

        public StatusLog Post(StatusLog StatusLog)
        {
            return new StatusLog();//_commands.Post(ActiveUser, StatusLog);
        }

        /// <summary>
        /// Updates an existing StatusLog record
        /// </summary>
        /// <param name="StatusLog"></param>
        /// <returns></returns>

        public StatusLog Put(StatusLog StatusLog)
        {
            return new StatusLog();//_commands.Put(ActiveUser, StatusLog);
        }

        /// <summary>
        /// Deletes a specific StatusLog record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return 0;//_commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of StatusLog record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return new List<IdRefLangName>();//_commands.Delete(ActiveUser, ids, statusId);
        }

        public StatusLog Patch(StatusLog entity)
        {
            throw new NotImplementedException();
        }
    }
}