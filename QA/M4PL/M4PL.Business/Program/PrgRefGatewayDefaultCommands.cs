/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgRefGatewayDefaultCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgRefGatewayDefaultCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgRefGatewayDefaultCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgRefGatewayDefaultCommands : BaseCommands<PrgRefGatewayDefault>, IPrgRefGatewayDefaultCommands
    {
        /// <summary>
        /// Gets list of prgrefgatewaydefault data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgRefGatewayDefault> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgrefgatewaydefault record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgRefGatewayDefault Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgrefgatewaydefault record
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>

        public PrgRefGatewayDefault Post(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            return _commands.Post(ActiveUser, prgRefGatewayDefault);
        }


        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>
        public PrgRefGatewayDefault PostWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
        {
            return _commands.PostWithSettings(ActiveUser, userSysSetting, prgRefGatewayDefault);
        }

        /// <summary>
        /// Updates an existingprgrefgatewaydefault record
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>

        public PrgRefGatewayDefault Put(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            return _commands.Put(ActiveUser, prgRefGatewayDefault);
        }

        /// <summary>
        /// Updates an existing job reference record
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>
        public PrgRefGatewayDefault PutWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
        {
            return _commands.PutWithSettings(ActiveUser, userSysSetting, prgRefGatewayDefault);
        }

        /// <summary>
        /// Deletes a specific prgrefgatewaydefault record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgrefgatewaydefault record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<PrgRefGatewayDefault> Get()
        {
            throw new NotImplementedException();
        }
    }
}