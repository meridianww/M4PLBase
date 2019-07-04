/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScnOrderRequirementCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Scanner.ScnOrderRequirementCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Scanner.ScnOrderRequirementCommands;
using M4PL.Entities.Scanner;
using System;

namespace M4PL.Business.Scanner
{
    public class ScnOrderRequirementCommands : BaseCommands<Entities.Scanner.ScnOrderRequirement>, IScnOrderRequirementCommands
    {
        /// <summary>
        /// Get list of ScnOrderRequirements data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Scanner.ScnOrderRequirement> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ScnOrderRequirement record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderRequirement Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ScnOrderRequirement record
        /// </summary>
        /// <param name="scnOrderRequirement"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderRequirement Post(Entities.Scanner.ScnOrderRequirement scnOrderRequirement)
        {
            return _commands.Post(ActiveUser, scnOrderRequirement);
        }

        /// <summary>
        /// Updates an existing ScnOrderRequirement record
        /// </summary>
        /// <param name="scnOrderRequirement"></param>
        /// <returns></returns>

        public Entities.Scanner.ScnOrderRequirement Put(Entities.Scanner.ScnOrderRequirement scnOrderRequirement)
        {
            return _commands.Put(ActiveUser, scnOrderRequirement);
        }

        /// <summary>
        /// Deletes a specific ScnOrderRequirement record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ScnOrderRequirements records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<ScnOrderRequirement> Get()
        {
            throw new NotImplementedException();
        }
    }
}