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
// Program Name:                                 OrgMarketSupportCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.OrgMarketSupportCommands
//====================================================================================================================

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System;
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

        public OrgMarketSupport Patch(OrgMarketSupport entity)
        {
            throw new NotImplementedException();
        }
    }
}