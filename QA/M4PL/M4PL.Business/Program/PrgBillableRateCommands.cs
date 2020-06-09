/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like PrgBillableRateCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgBillableRateCommands
===================================================================================================================*/
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgBillableRateCommands;

namespace M4PL.Business.Program
{
    public class PrgBillableRateCommands : BaseCommands<PrgBillableRate>, IPrgBillableRateCommands
    {
        /// <summary>
        /// Gets list of prgbillablerate data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgBillableRate> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgbillablerate record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgBillableRate Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgbillablerate record
        /// </summary>
        /// <param name="programBillableRate"></param>
        /// <returns></returns>

        public PrgBillableRate Post(PrgBillableRate programBillableRate)
        {
            return _commands.Post(ActiveUser, programBillableRate);
        }

        /// <summary>
        /// Updates an existing prgbillablerate record
        /// </summary>
        /// <param name="programBillableRate"></param>
        /// <returns></returns>

        public PrgBillableRate Put(PrgBillableRate programBillableRate)
        {
            return _commands.Put(ActiveUser, programBillableRate);
        }

        /// <summary>
        /// Deletes a specific prgbillablerate record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgbillablerate record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public PrgBillableRate Patch(PrgBillableRate entity)
        {
            throw new NotImplementedException();
        }
    }
}