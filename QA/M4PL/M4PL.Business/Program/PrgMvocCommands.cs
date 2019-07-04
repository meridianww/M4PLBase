/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like PrgMvocCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgMvocCommands
===================================================================================================================*/
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgMvocCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgMvocCommands : BaseCommands<PrgMvoc>, IPrgMvocCommands
    {
        /// <summary>
        /// Gets list of prgmvoc data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgMvoc> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgmvoc record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgMvoc Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgmvoc record
        /// </summary>
        /// <param name="prgMVOC"></param>
        /// <returns></returns>

        public PrgMvoc Post(PrgMvoc prgMVOC)
        {
            return _commands.Post(ActiveUser, prgMVOC);
        }

        /// <summary>
        /// Updates an existing prgmvoc record
        /// </summary>
        /// <param name="prgMVOC"></param>
        /// <returns></returns>

        public PrgMvoc Put(PrgMvoc prgMVOC)
        {
            return _commands.Put(ActiveUser, prgMVOC);
        }

        /// <summary>
        /// Deletes a specific prgmvoc record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgmvoc record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<PrgMvoc> Get()
        {
            throw new NotImplementedException();
        }
    }
}