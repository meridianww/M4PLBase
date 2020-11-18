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
// Program Name:                                 ScnRouteListCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnRouteListCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnRouteListCommands;

namespace M4PL.Business.Scanner
{
	public class ScnRouteListCommands : BaseCommands<Entities.Scanner.ScnRouteList>, IScnRouteListCommands
	{
		/// <summary>
		/// Get list of ScnRouteLists data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Scanner.ScnRouteList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific ScnRouteList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnRouteList Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new ScnRouteList record
		/// </summary>
		/// <param name="scnRouteList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnRouteList Post(Entities.Scanner.ScnRouteList scnRouteList)
		{
			return _commands.Post(ActiveUser, scnRouteList);
		}

		/// <summary>
		/// Updates an existing ScnRouteList record
		/// </summary>
		/// <param name="scnRouteList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnRouteList Put(Entities.Scanner.ScnRouteList scnRouteList)
		{
			return _commands.Put(ActiveUser, scnRouteList);
		}

		/// <summary>
		/// Deletes a specific ScnRouteList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of ScnRouteLists records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScnRouteList Patch(ScnRouteList entity)
		{
			throw new NotImplementedException();
		}
	}
}