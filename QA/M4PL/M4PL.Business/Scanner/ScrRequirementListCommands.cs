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
// Program Name:                                 ScrRequirementListCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrRequirementListCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrRequirementListCommands;

namespace M4PL.Business.Scanner
{
	public class ScrRequirementListCommands : BaseCommands<Entities.Scanner.ScrRequirementList>, IScrRequirementListCommands
	{
		/// <summary>
		/// Get list of scrRequirementLists data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Scanner.ScrRequirementList> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific scrRequirementList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrRequirementList Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new scrRequirementList record
		/// </summary>
		/// <param name="scrRequirementList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrRequirementList Post(Entities.Scanner.ScrRequirementList scrRequirementList)
		{
			return _commands.Post(ActiveUser, scrRequirementList);
		}

		/// <summary>
		/// Updates an existing scrRequirementList record
		/// </summary>
		/// <param name="scrRequirementList"></param>
		/// <returns></returns>

		public Entities.Scanner.ScrRequirementList Put(Entities.Scanner.ScrRequirementList scrRequirementList)
		{
			return _commands.Put(ActiveUser, scrRequirementList);
		}

		/// <summary>
		/// Deletes a specific scrRequirementList record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of scrRequirementLists records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScrRequirementList Patch(ScrRequirementList entity)
		{
			throw new NotImplementedException();
		}
	}
}