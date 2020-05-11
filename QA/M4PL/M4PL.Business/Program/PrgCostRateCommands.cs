/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like MenuDriverCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Administration.MenuDriverCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgCostRateCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgCostRateCommands : BaseCommands<PrgCostRate>, IPrgCostRateCommands
    {
        /// <summary>
        /// Gets list of prgcostrate data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgCostRate> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgcostrate record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgCostRate Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgcostrate record
        /// </summary>
        /// <param name="programCostRate"></param>
        /// <returns></returns>

        public PrgCostRate Post(PrgCostRate programCostRate)
        {
            return _commands.Post(ActiveUser, programCostRate);
        }

        /// <summary>
        /// Updates an existing prgcostrate record
        /// </summary>
        /// <param name="programCostRate"></param>
        /// <returns></returns>

        public PrgCostRate Put(PrgCostRate programCostRate)
        {
            return _commands.Put(ActiveUser, programCostRate);
        }

        /// <summary>
        /// Deletes a specific prgcostrate record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgcostrate record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<PrgCostRate> GetAllData()
        {
            throw new NotImplementedException();
        }

		public PrgCostRate Patch(PrgCostRate entity)
		{
			throw new NotImplementedException();
		}
	}
}