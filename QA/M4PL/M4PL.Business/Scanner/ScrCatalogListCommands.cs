/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrCatalogListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrCatalogListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrCatalogListCommands;

namespace M4PL.Business.Scanner
{
    public class ScrCatalogListCommands : BaseCommands<Entities.Scanner.ScrCatalogList>, IScrCatalogListCommands
    {
        /// <summary>
        /// Get list of scrCatalogLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrCatalogList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific scrCatalogList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrCatalogList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new scrCatalogList record
        /// </summary>
        /// <param name="scrCatalogList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrCatalogList Post(Entities.Scanner.ScrCatalogList scrCatalogList)
        {
            return _commands.Post(ActiveUser, scrCatalogList);
        }

        /// <summary>
        /// Updates an existing scrCatalogList record
        /// </summary>
        /// <param name="scrCatalogList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrCatalogList Put(Entities.Scanner.ScrCatalogList scrCatalogList)
        {
            return _commands.Put(ActiveUser, scrCatalogList);
        }

        /// <summary>
        /// Deletes a specific scrCatalogList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of scrCatalogLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}