/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgMarketSupportCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.OrgMarketSupportCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgMarketSupportCommands;

namespace M4PL.Business.Organization
{
    public class OrgMarketSupportCommands : BaseCommands<OrgMarketSupport>, IOrgMarketSupportCommands
    {
        /// <summary>
        /// Gets list of orgmarketsupport data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgMarketSupport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific orgmarketsupport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgMarketSupport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new orgmarketsupport record
        /// </summary>
        /// <param name="orgMarketSupport"></param>
        /// <returns></returns>

        public OrgMarketSupport Post(OrgMarketSupport orgMarketSupport)
        {
            return _commands.Post(ActiveUser, orgMarketSupport);
        }

        /// <summary>
        /// Updates an existing orgmarketsupport record
        /// </summary>
        /// <param name="orgMarketSupport"></param>
        /// <returns></returns>

        public OrgMarketSupport Put(OrgMarketSupport orgMarketSupport)
        {
            return _commands.Put(ActiveUser, orgMarketSupport);
        }

        /// <summary>
        /// Deletes a specific orgmarketsupport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of orgmarketsupport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids);
        }
    }
}