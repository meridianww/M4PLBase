﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgRoleCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgRoleCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgRoleCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgRoleCommands : BaseCommands<PrgRole>, IPrgRoleCommands
    {
        /// <summary>
        /// Gets list of prgrole data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgRole> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgrole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgRole Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgrole record
        /// </summary>
        /// <param name="programRole"></param>
        /// <returns></returns>

        public PrgRole Post(PrgRole programRole)
        {
            return _commands.Post(ActiveUser, programRole);
        }

        /// <summary>
        /// Updates an existing prgrole record
        /// </summary>
        /// <param name="programRole"></param>
        /// <returns></returns>

        public PrgRole Put(PrgRole programRole)
        {
            return _commands.Put(ActiveUser, programRole);
        }

        /// <summary>
        /// Deletes a specific prgrole record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgrole record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<PrgRole> GetAllData()
        {
            throw new NotImplementedException();
        }

		public PrgRole Patch(PrgRole entity)
		{
			throw new NotImplementedException();
		}
	}
}