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
// Program Name:                                 ScnCargoCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnCargoCommands
//====================================================================================================================

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnCargoCommands;

namespace M4PL.Business.Scanner
{
    public class ScnCargoCommands : BaseCommands<Entities.Scanner.ScnCargo>, IScnCargoCommands
    {
        /// <summary>
        /// Get list of ScnCargos data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnCargo> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnCargo record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargo Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnCargo record
        /// </summary>
        /// <param name="scnCargo"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargo Post(Entities.Scanner.ScnCargo scnCargo)
        {
            return _commands.Post(ActiveUser, scnCargo);
        }

        /// <summary>
        /// Updates an existing ScnCargo record
        /// </summary>
        /// <param name="scnCargo"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargo Put(Entities.Scanner.ScnCargo scnCargo)
        {
            return _commands.Put(ActiveUser, scnCargo);
        }

        /// <summary>
        /// Deletes a specific ScnCargo record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnCargos records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public ScnCargo Patch(ScnCargo entity)
        {
            throw new NotImplementedException();
        }
    }
}