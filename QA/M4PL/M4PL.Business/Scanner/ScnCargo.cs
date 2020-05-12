/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnCargoCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnCargoCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnCargoCommands;
using M4PL.Entities.Scanner;
using System;

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