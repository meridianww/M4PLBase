/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdReasonListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrOsdReasonListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrOsdReasonListCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScrOsdReasonListCommands : BaseCommands<Entities.Scanner.ScrOsdReasonList>, IScrOsdReasonListCommands
    {
        /// <summary>
        /// Get list of scrOsdReasonLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrOsdReasonList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific scrOsdReasonList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdReasonList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new scrOsdReasonList record
        /// </summary>
        /// <param name="scrOsdReasonList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdReasonList Post(Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
        {
            return _commands.Post(ActiveUser, scrOsdReasonList);
        }

        /// <summary>
        /// Updates an existing scrOsdReasonList record
        /// </summary>
        /// <param name="scrOsdReasonList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrOsdReasonList Put(Entities.Scanner.ScrOsdReasonList scrOsdReasonList)
        {
            return _commands.Put(ActiveUser, scrOsdReasonList);
        }

        /// <summary>
        /// Deletes a specific scrOsdReasonList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of scrOsdReasonLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public ScrOsdReasonList Patch(ScrOsdReasonList entity)
		{
			throw new NotImplementedException();
		}
	}
}