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
// Program Name:                                 ScrOsdReasonListCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrOsdReasonListCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrOsdReasonListCommands;

namespace M4PL.Business.Scanner
{
	public class ScrOsdReasonListCommands : BaseCommands<Entities.Scanner.ScrOsdReasonList>, IScrOsdReasonListCommands
	{
		/// <summary>
		/// Get list of scrOsdReasonLists data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Scanner.ScrOsdReasonList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific scrOsdReasonList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrOsdReasonList Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new scrOsdReasonList record
		/// </summary>
		/// <param name="scrOsdReasonList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrOsdReasonList Post(Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
		{
			return _commands.Post(ActiveUser, scrOsdReasonList);
		}

		/// <summary>
		/// Updates an existing scrOsdReasonList record
		/// </summary>
		/// <param name="scrOsdReasonList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrOsdReasonList Put(Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
		{
			return _commands.Put(ActiveUser, scrOsdReasonList);
		}

		/// <summary>
		/// Deletes a specific scrOsdReasonList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of scrOsdReasonLists records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScrOsdReasonList Patch(ScrOsdReasonList entity)
		{
			throw new NotImplementedException();
		}
	}
}