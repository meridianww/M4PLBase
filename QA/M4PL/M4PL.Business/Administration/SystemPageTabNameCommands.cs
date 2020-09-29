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
// Program Name:                                 SystemPageTabNameCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.SystemPageTabNameCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.SystemPageTabNameCommands;

namespace M4PL.Business.Administration
{
	public class SystemPageTabNameCommands : BaseCommands<SystemPageTabName>, ISystemPageTabNameCommands
	{
		/// <summary>
		/// Get list of system page tab name data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<SystemPageTabName> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific system page tab name record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public SystemPageTabName Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new system page tab name driver record
		/// </summary>
		/// <param name="SystemPageTabName"></param>
		/// <returns></returns>

		public SystemPageTabName Post(SystemPageTabName SystemPageTabName)
		{
			return _commands.Post(ActiveUser, SystemPageTabName);
		}

		/// <summary>
		/// Updates an existing system page tab name record
		/// </summary>
		/// <param name="SystemPageTabName"></param>
		/// <returns></returns>

		public SystemPageTabName Put(SystemPageTabName SystemPageTabName)
		{
			return _commands.Put(ActiveUser, SystemPageTabName);
		}

		/// <summary>
		/// Deletes a specific system page tab name record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of system page tab name record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public SystemPageTabName Patch(SystemPageTabName entity)
		{
			throw new NotImplementedException();
		}
	}
}