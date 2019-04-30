/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrOsdListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrOsdListCommands;

namespace M4PL.Business.Scanner
{
    public class ScrOsdListCommands : BaseCommands<Entities.Scanner.ScrOsdList>, IScrOsdListCommands
    {
        /// <summary>
        /// Get list of scrOsdLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrOsdList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific scrOsdList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new scrOsdList record
        /// </summary>
        /// <param name="scrOsdList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdList Post(Entities.Scanner.ScrOsdList scrOsdList)
        {
            return _commands.Post(ActiveUser, scrOsdList);
        }

        /// <summary>
        /// Updates an existing scrOsdList record
        /// </summary>
        /// <param name="scrOsdList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdList Put(Entities.Scanner.ScrOsdList scrOsdList)
        {
            return _commands.Put(ActiveUser, scrOsdList);
        }

        /// <summary>
        /// Deletes a specific scrOsdList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of scrOsdLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}