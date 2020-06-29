﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgRefAttributeDefaultCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgRefAttributeDefaultCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgRefAttributeDefaultCommands;

namespace M4PL.Business.Program
{
    public class PrgRefAttributeDefaultCommands : BaseCommands<PrgRefAttributeDefault>, IPrgRefAttributeDefaultCommands
    {
        /// <summary>
        /// Gets list of prgRefAttributeDefault data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgRefAttributeDefault> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgRefAttributeDefault record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgRefAttributeDefault Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgRefAttributeDefault record
        /// </summary>
        /// <param name="prgRefAttributeDefault"></param>
        /// <returns></returns>

        public PrgRefAttributeDefault Post(PrgRefAttributeDefault prgRefAttributeDefault)
        {
            return _commands.Post(ActiveUser, prgRefAttributeDefault);
        }

        /// <summary>
        /// Updates an existing prgRefAttributeDefault record
        /// </summary>
        /// <param name="prgRefAttributeDefault"></param>
        /// <returns></returns>

        public PrgRefAttributeDefault Put(PrgRefAttributeDefault prgRefAttributeDefault)
        {
            return _commands.Put(ActiveUser, prgRefAttributeDefault);
        }

        /// <summary>
        /// Deletes a specific prgRefAttributeDefault record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgRefAttributeDefault record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public PrgRefAttributeDefault Patch(PrgRefAttributeDefault entity)
        {
            throw new NotImplementedException();
        }
    }
}