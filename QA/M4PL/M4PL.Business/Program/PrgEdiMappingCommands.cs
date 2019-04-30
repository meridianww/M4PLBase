/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like PrgEdiMappingCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgEdiMappingCommands
===================================================================================================================*/
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgEdiMappingComments;

namespace M4PL.Business.Program
{
    public class PrgEdiMappingCommands : BaseCommands<PrgEdiMapping>, IPrgEdiMappingCommands
    {
        /// <summary>
        /// Gets list of prgedimapping data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgEdiMapping> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgedimapping record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgEdiMapping Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgedimapping record
        /// </summary>
        /// <param name="prgEdiMapping"></param>
        /// <returns></returns>

        public PrgEdiMapping Post(PrgEdiMapping prgEdiMapping)
        {
            return _commands.Post(ActiveUser, prgEdiMapping);
        }

        /// <summary>
        /// Updates an existing prgedimapping record
        /// </summary>
        /// <param name="prgEdiMapping"></param>
        /// <returns></returns>

        public PrgEdiMapping Put(PrgEdiMapping prgEdiMapping)
        {
            return _commands.Put(ActiveUser, prgEdiMapping);
        }

        /// <summary>
        /// Deletes a specific prgedimapping record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgedimapping record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}