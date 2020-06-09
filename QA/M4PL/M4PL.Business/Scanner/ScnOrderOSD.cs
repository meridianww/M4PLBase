/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderOSDCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnOrderOSDCommands
===================================================================================================================*/

using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnOrderOSDCommands;

namespace M4PL.Business.Scanner
{
    public class ScnOrderOSDCommands : BaseCommands<Entities.Scanner.ScnOrderOSD>, IScnOrderOSDCommands
    {
        /// <summary>
        /// Get list of ScnOrderOSDs data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnOrderOSD> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnOrderOSD record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderOSD Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnOrderOSD record
        /// </summary>
        /// <param name="scnOrderOSD"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderOSD Post(Entities.Scanner.ScnOrderOSD scnOrderOSD)
        {
            return _commands.Post(ActiveUser, scnOrderOSD);
        }

        /// <summary>
        /// Updates an existing ScnOrderOSD record
        /// </summary>
        /// <param name="scnOrderOSD"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderOSD Put(Entities.Scanner.ScnOrderOSD scnOrderOSD)
        {
            return _commands.Put(ActiveUser, scnOrderOSD);
        }

        /// <summary>
        /// Deletes a specific ScnOrderOSD record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnOrderOSDs records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public ScnOrderOSD Patch(ScnOrderOSD entity)
        {
            throw new NotImplementedException();
        }
    }
}