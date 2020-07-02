#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 {Class name} like PrgMvocCommands
// Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Program.PrgMvocCommands
//====================================================================================================================
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgMvocCommands;

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

        public PrgMvoc Patch(PrgMvoc entity)
        {
            throw new NotImplementedException();
        }
    }
}