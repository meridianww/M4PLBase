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
// Program Name:                                 ScrReportCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrReportCommands
//====================================================================================================================
using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrReportCommands;

namespace M4PL.Business.Scanner
{
	public class ScrReportCommands : BaseCommands<ScrReport>, IScrReportCommands
	{
		/// <summary>
		/// Get list of memu driver data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<ScrReport> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific ScrReport record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public ScrReport Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new ScrReport record
		/// </summary>
		/// <param name="ScrReport"></param>
		/// <returns></returns>

		public ScrReport Post(ScrReport ScrReport)
		{
			return _commands.Post(ActiveUser, ScrReport);
		}

		/// <summary>
		/// Updates an existing ScrReport record
		/// </summary>
		/// <param name="ScrReport"></param>
		/// <returns></returns>

		public ScrReport Put(ScrReport ScrReport)
		{
			return _commands.Put(ActiveUser, ScrReport);
		}

		/// <summary>
		/// Deletes a specific ScrReport record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of ScrReport record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public ScrReport Patch(ScrReport entity)
		{
			throw new NotImplementedException();
		}
	}
}