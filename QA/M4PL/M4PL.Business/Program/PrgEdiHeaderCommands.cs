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
// Program Name:                                 {Class name} like PrgEdiHeaderCommands
// Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgEdiHeaderCommands
//====================================================================================================================
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgEdiHeaderComments;

namespace M4PL.Business.Program
{
	public class PrgEdiHeaderCommands : BaseCommands<PrgEdiHeader>, IPrgEdiHeaderCommands
	{
		/// <summary>
		/// Gets list of prgediheader data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<PrgEdiHeader> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific prgediheader record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public PrgEdiHeader Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new prgediheader record
		/// </summary>
		/// <param name="prgEdiHeader"></param>
		/// <returns></returns>

		public PrgEdiHeader Post(PrgEdiHeader prgEdiHeader)
		{
			return _commands.Post(ActiveUser, prgEdiHeader);
		}

		/// <summary>
		/// Updates an existing prgediheader record
		/// </summary>
		/// <param name="prgEdiHeader"></param>
		/// <returns></returns>

		public PrgEdiHeader Put(PrgEdiHeader prgEdiHeader)
		{
			return _commands.Put(ActiveUser, prgEdiHeader);
		}

		/// <summary>
		/// Deletes a specific prgediheader record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of prgediheader record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

        public IList<TreeModel> EdiTree(ActiveUser activeUser, long? parentId, bool model)
        {
            return _commands.GetEdiTree(activeUser, parentId, model);
        }

        public PrgEdiHeader Patch(PrgEdiHeader entity)
		{
			throw new NotImplementedException();
		}

		public int GetProgramLevel(long id, long? programId)
		{
			return _commands.GetProgramLevel(id, programId);
		}
	}
}