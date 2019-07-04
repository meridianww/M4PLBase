/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderServiceCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnOrderServiceCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnOrderServiceCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScnOrderServiceCommands : BaseCommands<Entities.Scanner.ScnOrderService>, IScnOrderServiceCommands
    {
        /// <summary>
        /// Get list of ScnOrderServices data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnOrderService> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnOrderService record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderService Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnOrderService record
        /// </summary>
        /// <param name="scnOrderService"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderService Post(Entities.Scanner.ScnOrderService scnOrderService)
        {
            return _commands.Post(ActiveUser, scnOrderService);
        }

        /// <summary>
        /// Updates an existing ScnOrderService record
        /// </summary>
        /// <param name="scnOrderService"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderService Put(Entities.Scanner.ScnOrderService scnOrderService)
        {
            return _commands.Put(ActiveUser, scnOrderService);
        }

        /// <summary>
        /// Deletes a specific ScnOrderService record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnOrderServices records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<ScnOrderService> Get()
        {
            throw new NotImplementedException();
        }
    }
}