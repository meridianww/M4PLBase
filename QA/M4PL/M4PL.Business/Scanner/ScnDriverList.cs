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
// Program Name:                                 ScnDriverListCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnDriverListCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnDriverListCommands;

namespace M4PL.Business.Scanner
{
	public class ScnDriverListCommands : BaseCommands<Entities.Scanner.ScnDriverList>, IScnDriverListCommands
	{
		/// <summary>
		/// Get list of ScnDriverLists data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Scanner.ScnDriverList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific ScnDriverList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnDriverList Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new ScnDriverList record
		/// </summary>
		/// <param name="scnDriverList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnDriverList Post(Entities.Scanner.ScnDriverList scnDriverList)
		{
			return _commands.Post(ActiveUser, scnDriverList);
		}

		/// <summary>
		/// Updates an existing ScnDriverList record
		/// </summary>
		/// <param name="scnDriverList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScnDriverList Put(Entities.Scanner.ScnDriverList scnDriverList)
		{
			return _commands.Put(ActiveUser, scnDriverList);
		}

		/// <summary>
		/// Deletes a specific ScnDriverList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of ScnDriverLists records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScnDriverList Patch(ScnDriverList entity)
		{
			throw new NotImplementedException();
		}
	}
}