/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              08/21/2019
Program Name:                                 PrgEdiConditionCommands
Purpose:                                      Contains commands to call DAL logic
=============================================================================================================*/
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgEdiConditionCommands;

namespace M4PL.Business.Program
{
    public class PrgEdiConditionCommands: BaseCommands<PrgEdiCondition>, IPrgEdiConditionCommands
    {
        public IList<PrgEdiCondition> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific PrgEdiConditions record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgEdiCondition Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new PrgEdiConditions record
        /// </summary>
        /// <param name="PrgEdiConditions"></param>
        /// <returns></returns>

        public PrgEdiCondition Post(PrgEdiCondition programCostRate)
        {
            return _commands.Post(ActiveUser, programCostRate);
        }

        /// <summary>
        /// Updates an existing PrgEdiConditions record
        /// </summary>
        /// <param name="PrgEdiConditions"></param>
        /// <returns></returns>

        public PrgEdiCondition Put(PrgEdiCondition programCostRate)
        {
            return _commands.Put(ActiveUser, programCostRate);
        }

        /// <summary>
        /// Deletes a specific PrgEdiConditions record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of PrgEdiConditions record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public PrgEdiCondition Patch(PrgEdiCondition entity)
        {
            throw new NotImplementedException();
        }
    }
}
