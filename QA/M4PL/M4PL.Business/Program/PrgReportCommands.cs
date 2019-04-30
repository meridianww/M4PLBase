/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like PrgReportCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgReportCommands
===================================================================================================================*/
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgReportCommands;

namespace M4PL.Business.Program
{
    public class PrgReportCommands : BaseCommands<PrgReport>, IPrgReportCommands
    {
        /// <summary>
        /// Get list of memu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific PrgReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new PrgReport record
        /// </summary>
        /// <param name="prgReport"></param>
        /// <returns></returns>

        public PrgReport Post(PrgReport prgReport)
        {
            return _commands.Post(ActiveUser, prgReport);
        }

        /// <summary>
        /// Updates an existing PrgReport record
        /// </summary>
        /// <param name="prgReport"></param>
        /// <returns></returns>

        public PrgReport Put(PrgReport prgReport)
        {
            return _commands.Put(ActiveUser, prgReport);
        }

        /// <summary>
        /// Deletes a specific PrgReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of PrgReport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}