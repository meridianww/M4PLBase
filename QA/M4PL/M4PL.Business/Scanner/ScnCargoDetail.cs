/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnCargoDetailCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnCargoDetailCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnCargoDetailCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScnCargoDetailCommands : BaseCommands<Entities.Scanner.ScnCargoDetail>, IScnCargoDetailCommands
    {
        /// <summary>
        /// Get list of ScnCargoDetails data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnCargoDetail> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnCargoDetail record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargoDetail Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnCargoDetail record
        /// </summary>
        /// <param name="scnCargoDetail"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargoDetail Post(Entities.Scanner.ScnCargoDetail scnCargoDetail)
        {
            return _commands.Post(ActiveUser, scnCargoDetail);
        }

        /// <summary>
        /// Updates an existing ScnCargoDetail record
        /// </summary>
        /// <param name="scnCargoDetail"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnCargoDetail Put(Entities.Scanner.ScnCargoDetail scnCargoDetail)
        {
            return _commands.Put(ActiveUser, scnCargoDetail);
        }

        /// <summary>
        /// Deletes a specific ScnCargoDetail record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnCargoDetails records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public ScnCargoDetail Patch(ScnCargoDetail entity)
		{
			throw new NotImplementedException();
		}
	}
}