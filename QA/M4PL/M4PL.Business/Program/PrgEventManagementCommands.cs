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
// Program Name:                                 ProgramCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.ProgramCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgEventManagementCommands;

namespace M4PL.Business.Program
{
	public class PrgEventManagementCommands : BaseCommands<Entities.Program.PrgEventManagement>, IPrgEventManagementCommands
	{
		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public PrgEventManagement Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		public IList<PrgEventManagement> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		public PrgEventManagement Patch(PrgEventManagement entity)
		{
			throw new NotImplementedException();
		}

		public PrgEventManagement Post(PrgEventManagement entity)
		{
			return _commands.Post(ActiveUser, entity);
		}

		public PrgEventManagement Put(PrgEventManagement entity)
		{
			return _commands.Put(ActiveUser, entity);
		}
	}
}