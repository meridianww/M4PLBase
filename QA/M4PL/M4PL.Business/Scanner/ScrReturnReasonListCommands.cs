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
// Program Name:                                 ScrReturnReasonListCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrReturnReasonListCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrReturnReasonListCommands;

namespace M4PL.Business.Scanner
{
	public class ScrReturnReasonListCommands : BaseCommands<Entities.Scanner.ScrReturnReasonList>, IScrReturnReasonListCommands
	{
		/// <summary>
		/// Get list of scrReturnReasonLists data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Scanner.ScrReturnReasonList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific scrReturnReasonList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrReturnReasonList Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new scrReturnReasonList record
		/// </summary>
		/// <param name="scrReturnReasonList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrReturnReasonList Post(Entities.Scanner.ScrReturnReasonList scrReturnReasonList)
		{
			return _commands.Post(ActiveUser, scrReturnReasonList);
		}

		/// <summary>
		/// Updates an existing scrReturnReasonList record
		/// </summary>
		/// <param name="scrReturnReasonList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrReturnReasonList Put(Entities.Scanner.ScrReturnReasonList scrReturnReasonList)
		{
			return _commands.Put(ActiveUser, scrReturnReasonList);
		}

		/// <summary>
		/// Deletes a specific scrReturnReasonList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of scrReturnReasonLists records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScrReturnReasonList Patch(ScrReturnReasonList entity)
		{
			throw new NotImplementedException();
		}
	}
}