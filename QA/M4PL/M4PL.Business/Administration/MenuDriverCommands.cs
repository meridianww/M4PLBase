﻿#region Copyright

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
// Program Name:                                 MenuDriverCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.MenuDriverCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.MenuDriverCommands;

namespace M4PL.Business.Administration
{
	public class MenuDriverCommands : BaseCommands<MenuDriver>, IMenuDriverCommands
	{
		/// <summary>
		/// Get list of menu driver data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<MenuDriver> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific menu driver record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public MenuDriver Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new menu driver record
		/// </summary>
		/// <param name="menuDriver"></param>
		/// <returns></returns>

		public MenuDriver Post(MenuDriver menuDriver)
		{
			return _commands.Post(ActiveUser, menuDriver);
		}

		/// <summary>
		/// Updates an existing menu driver record
		/// </summary>
		/// <param name="menuDriver"></param>
		/// <returns></returns>

		public MenuDriver Put(MenuDriver menuDriver)
		{
			return _commands.Put(ActiveUser, menuDriver);
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

		public MenuDriver Patch(MenuDriver entity)
		{
			throw new NotImplementedException();
		}
	}
}