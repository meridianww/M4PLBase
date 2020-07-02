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
// Program Name:                                 PrgRoleCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgRoleCommands
//====================================================================================================================

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgRoleCommands;

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

        public PrgRole Patch(PrgRole entity)
        {
            throw new NotImplementedException();
        }
    }
}