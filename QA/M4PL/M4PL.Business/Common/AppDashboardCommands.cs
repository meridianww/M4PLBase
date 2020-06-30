/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 AppDashboardCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Common.AppDashboardCommands
===================================================================================================================*/
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Common.AppDashboardCommands;

namespace M4PL.Business.Common
{
    public class AppDashboardCommands : BaseCommands<AppDashboard>, IAppDashboardCommands
    {
        /// <summary>
        /// Get list of menu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<AppDashboard> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific menu driver record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public AppDashboard Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new menu driver record
        /// </summary>
        /// <param name="Dashboard"></param>
        /// <returns></returns>

        public AppDashboard Post(AppDashboard Dashboard)
        {
            return _commands.Post(ActiveUser, Dashboard);
        }

        /// <summary>
        /// Updates an existing menu driver record
        /// </summary>
        /// <param name="Dashboard"></param>
        /// <returns></returns>

        public AppDashboard Put(AppDashboard Dashboard)
        {
            return _commands.Put(ActiveUser, Dashboard);
        }

        /// <summary>
        /// Deletes a specific menu driver record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of menu driver record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public AppDashboard Patch(AppDashboard entity)
        {
            throw new NotImplementedException();
        }
    }
}