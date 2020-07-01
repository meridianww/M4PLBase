/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrInfoListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrInfoListCommands
===================================================================================================================*/

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrInfoListCommands;

namespace M4PL.Business.Scanner
{
    public class ScrInfoListCommands : BaseCommands<Entities.Scanner.ScrInfoList>, IScrInfoListCommands
    {
        /// <summary>
        /// Get list of ScrInfoLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrInfoList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScrInfoList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrInfoList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScrInfoList record
        /// </summary>
        /// <param name="scrInfoList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrInfoList Post(Entities.Scanner.ScrInfoList scrInfoList)
        {
            return _commands.Post(ActiveUser, scrInfoList);
        }

        /// <summary>
        /// Updates an existing ScrInfoList record
        /// </summary>
        /// <param name="scrInfoList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrInfoList Put(Entities.Scanner.ScrInfoList scrInfoList)
        {
            return _commands.Put(ActiveUser, scrInfoList);
        }

        /// <summary>
        /// Deletes a specific ScrInfoList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScrInfoLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public ScrInfoList Patch(ScrInfoList entity)
        {
            throw new NotImplementedException();
        }
    }
}