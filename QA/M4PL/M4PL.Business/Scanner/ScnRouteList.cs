/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnRouteListCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnRouteListCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnRouteListCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScnRouteListCommands : BaseCommands<Entities.Scanner.ScnRouteList>, IScnRouteListCommands
    {
        /// <summary>
        /// Get list of ScnRouteLists data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnRouteList> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnRouteList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnRouteList Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnRouteList record
        /// </summary>
        /// <param name="scnRouteList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnRouteList Post(Entities.Scanner.ScnRouteList scnRouteList)
        {
            return _commands.Post(ActiveUser, scnRouteList);
        }

        /// <summary>
        /// Updates an existing ScnRouteList record
        /// </summary>
        /// <param name="scnRouteList"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnRouteList Put(Entities.Scanner.ScnRouteList scnRouteList)
        {
            return _commands.Put(ActiveUser, scnRouteList);
        }

        /// <summary>
        /// Deletes a specific ScnRouteList record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnRouteLists records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<ScnRouteList> Get()
        {
            throw new NotImplementedException();
        }
    }
}