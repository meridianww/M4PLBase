/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrGatewayListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScrGatewayListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScrGatewayListCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScrGatewayListCommands : BaseCommands<Entities.Scanner.ScrGatewayList>, IScrGatewayListCommands
    {
        /// <summary>
        /// Get list of ScrGatewayLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScrGatewayList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScrGatewayList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrGatewayList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScrGatewayList record
        /// </summary>
        /// <param name="scrGatewayList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrGatewayList Post(Entities.Scanner.ScrGatewayList scrGatewayList)
        {
            return _commands.Post(ActiveUser, scrGatewayList);
        }

        /// <summary>
        /// Updates an existing ScrGatewayList record
        /// </summary>
        /// <param name="scrGatewayList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScrGatewayList Put(Entities.Scanner.ScrGatewayList scrGatewayList)
        {
            return _commands.Put(ActiveUser, scrGatewayList);
        }

        /// <summary>
        /// Deletes a specific ScrGatewayList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScrGatewayLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<ScrGatewayList> Get()
        {
            throw new NotImplementedException();
        }

		public ScrGatewayList Patch(ScrGatewayList entity)
		{
			throw new NotImplementedException();
		}
	}
}