/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 MenuOptionLevelCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.MenuOptionLevelCommands
===================================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.MenuOptionLevelCommands;

namespace M4PL.Business.Administration
{
    public class MenuOptionLevelCommands : BaseCommands<MenuOptionLevel>, IMenuOptionLevelCommands
    {
        /// <summary>
        /// Get list of memu option data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<MenuOptionLevel> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific menu option record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public MenuOptionLevel Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new menu option record
        /// </summary>
        /// <param name="menuOptionLevel"></param>
        /// <returns></returns>

        public MenuOptionLevel Post(MenuOptionLevel menuOptionLevel)
        {
            return _commands.Post(ActiveUser, menuOptionLevel);
        }

        /// <summary>
        /// Updates an existing menu option record
        /// </summary>
        /// <param name="menuOptionLevel"></param>
        /// <returns></returns>

        public MenuOptionLevel Put(MenuOptionLevel menuOptionLevel)
        {
            return _commands.Put(ActiveUser, menuOptionLevel);
        }

        /// <summary>
        /// Deletes a specific menu option record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of menu option record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids);
        }

        public MenuOptionLevel Patch(MenuOptionLevel entity)
        {
            throw new NotImplementedException();
        }
    }
}