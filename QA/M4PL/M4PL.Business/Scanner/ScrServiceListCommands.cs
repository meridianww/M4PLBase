/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrServiceListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrServiceListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrServiceListCommands;

namespace M4PL.Business.Scanner
{
    public class ScrServiceListCommands : BaseCommands<Entities.Scanner.ScrServiceList>, IScrServiceListCommands
    {
        /// <summary>
        /// Get list of scrServiceLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrServiceList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific scrServiceList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrServiceList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new scrServiceList record
        /// </summary>
        /// <param name="scrServiceList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrServiceList Post(Entities.Scanner.ScrServiceList scrServiceList)
        {
            return _commands.Post(ActiveUser, scrServiceList);
        }

        /// <summary>
        /// Updates an existing scrServiceList record
        /// </summary>
        /// <param name="scrServiceList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrServiceList Put(Entities.Scanner.ScrServiceList scrServiceList)
        {
            return _commands.Put(ActiveUser, scrServiceList);
        }

        /// <summary>
        /// Deletes a specific scrServiceList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of scrServiceLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}