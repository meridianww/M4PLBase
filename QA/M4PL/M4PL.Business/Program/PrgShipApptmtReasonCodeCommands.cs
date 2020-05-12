/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipApptmtReasonCodeCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgShipApptmtReasonCodeCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgShipApptmtReasonCodeCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgShipApptmtReasonCodeCommands : BaseCommands<PrgShipApptmtReasonCode>, IPrgShipApptmtReasonCodeCommands
    {
        /// <summary>
        /// Gets list of PrgShipApptmtReasonCode data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgShipApptmtReasonCode> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific PrgShipApptmtReasonCode record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgShipApptmtReasonCode Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new PrgShipApptmtReasonCode record
        /// </summary>
        /// <param name="prgShipApptmtReasonCode"></param>
        /// <returns></returns>

        public PrgShipApptmtReasonCode Post(PrgShipApptmtReasonCode prgShipApptmtReasonCode)
        {
            prgShipApptmtReasonCode.PacOrgID = ActiveUser.OrganizationId;
            return _commands.Post(ActiveUser, prgShipApptmtReasonCode);
        }

        /// <summary>
        /// Updates an existing PrgShipApptmtReasonCode record
        /// </summary>
        /// <param name="prgShipApptmtReasonCode"></param>
        /// <returns></returns>

        public PrgShipApptmtReasonCode Put(PrgShipApptmtReasonCode prgShipApptmtReasonCode)
        {
            prgShipApptmtReasonCode.PacOrgID = ActiveUser.OrganizationId;
            return _commands.Put(ActiveUser, prgShipApptmtReasonCode);
        }

        /// <summary>
        /// Deletes a specific PrgShipApptmtReasonCode record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of PrgShipApptmtReasonCode record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public PrgShipApptmtReasonCode Patch(PrgShipApptmtReasonCode entity)
		{
			throw new NotImplementedException();
		}
	}
}