/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnOrderCommands
===================================================================================================================*/

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnOrderCommands;

namespace M4PL.Business.Scanner
{
    public class ScnOrderCommands : BaseCommands<Entities.Scanner.ScnOrder>, IScnOrderCommands
    {
        /// <summary>
        /// Get list of ScnOrders data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnOrder> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnOrder record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrder Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnOrder record
        /// </summary>
        /// <param name="scnOrder"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrder Post(Entities.Scanner.ScnOrder scnOrder)
        {
            return _commands.Post(ActiveUser, scnOrder);
        }

        /// <summary>
        /// Updates an existing ScnOrder record
        /// </summary>
        /// <param name="scnOrder"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrder Put(Entities.Scanner.ScnOrder scnOrder)
        {
            return _commands.Put(ActiveUser, scnOrder);
        }

        /// <summary>
        /// Deletes a specific ScnOrder record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnOrders records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public ScnOrder Patch(ScnOrder entity)
        {
            throw new NotImplementedException();
        }
    }
}

