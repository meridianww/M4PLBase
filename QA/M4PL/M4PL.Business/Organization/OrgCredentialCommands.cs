/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgCredentialCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgCredentialCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgCredentialCommands;
using System;

namespace M4PL.Business.Organization
{
    public class OrgCredentialCommands : BaseCommands<OrgCredential>, IOrgCredentialCommands
    {
        /// <summary>
        /// Get list of OrgCredential data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgCredential> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific OrgCredential record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgCredential Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new OrgCredential record
        /// </summary>
        /// <param name="orgCredential"></param>
        /// <returns></returns>

        public OrgCredential Post(OrgCredential orgCredential)
        {
            return _commands.Post(ActiveUser, orgCredential);
        }

        /// <summary>
        /// Updates an existing OrgCredential record
        /// </summary>
        /// <param name="orgCredential"></param>
        /// <returns></returns>

        public OrgCredential Put(OrgCredential orgCredential)
        {
            return _commands.Put(ActiveUser, orgCredential);
        }

        /// <summary>
        /// Deletes a specific OrgCredential record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of OrgCredential record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public OrgCredential Patch(OrgCredential entity)
		{
			throw new NotImplementedException();
		}
	}
}