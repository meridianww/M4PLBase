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
// Date Programmed:                              10/10/2017
// Program Name:                                 MenuAccessLevelCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.MenuAccessLevelCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.MenuAccessLevelCommands;

namespace M4PL.Business.Administration
{
	public class MenuAccessLevelCommands : BaseCommands<MenuAccessLevel>, IMenuAccessLevelCommands
	{
		/// <summary>
		/// Gets list of menu access level
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<MenuAccessLevel> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets menu access based on the user id for the specific user
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public MenuAccessLevel Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new menu access record
		/// </summary>
		/// <param name="menuAccessLevel"></param>
		/// <returns></returns>

		public MenuAccessLevel Post(MenuAccessLevel menuAccessLevel)
		{
			return _commands.Post(ActiveUser, menuAccessLevel);
		}

		/// <summary>
		/// Updates an existing menu access record
		/// </summary>
		/// <param name="menuAccessLevel"></param>
		/// <returns></returns>

		public MenuAccessLevel Put(MenuAccessLevel menuAccessLevel)
		{
			return _commands.Put(ActiveUser, menuAccessLevel);
		}

		/// <summary>
		/// Deletes specific menu acccess record based on the user id
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes list of menu access records based on the table name
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids);
		}

		public MenuAccessLevel Patch(MenuAccessLevel entity)
		{
			throw new NotImplementedException();
		}
	}
}