/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like MenuDriverCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgShipStatusReasonCodeCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgShipStatusReasonCodeCommands;

namespace M4PL.Business.Program
{
    public class PrgShipStatusReasonCodeCommands : BaseCommands<PrgShipStatusReasonCode>, IPrgShipStatusReasonCodeCommands
    {
        /// <summary>
        /// Gets list of prgshipstatusreasoncode data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgShipStatusReasonCode> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgshipstatusreasoncode record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgShipStatusReasonCode Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgshipstatusreasoncode record
        /// </summary>
        /// <param name="prgShipStatusReasonCode"></param>
        /// <returns></returns>

        public PrgShipStatusReasonCode Post(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            prgShipStatusReasonCode.PscOrgID = ActiveUser.OrganizationId;
            return _commands.Post(ActiveUser, prgShipStatusReasonCode);
        }

        /// <summary>
        /// Updates an existing prgshipstatusreasoncode record
        /// </summary>
        /// <param name="prgShipStatusReasonCode"></param>
        /// <returns></returns>

        public PrgShipStatusReasonCode Put(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            prgShipStatusReasonCode.PscOrgID = ActiveUser.OrganizationId;
            return _commands.Put(ActiveUser, prgShipStatusReasonCode);
        }

        /// <summary>
        /// Deletes a specific prgshipstatusreasoncode record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgshipstatusreasoncode record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public PrgShipStatusReasonCode Patch(PrgShipStatusReasonCode entity)
        {
            throw new NotImplementedException();
        }
    }
}