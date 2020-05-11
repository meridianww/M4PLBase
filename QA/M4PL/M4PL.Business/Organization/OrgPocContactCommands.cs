/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgPocContactCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgPocContactCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgPocContactCommands;
using System;

namespace M4PL.Business.Organization
{
    public class OrgPocContactCommands : BaseCommands<OrgPocContact>, IOrgPocContactCommands
    {
        /// <summary>
        /// Get list of orgPocContact data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgPocContact> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific orgPocContact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgPocContact Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new menu driver record
        /// </summary>
        /// <param name="orgPocContact"></param>
        /// <returns></returns>

        public OrgPocContact Post(OrgPocContact orgPocContact)
        {
            return _commands.Post(ActiveUser, orgPocContact);
        }

        /// <summary>
        /// Updates an existing orgPocContact record
        /// </summary>
        /// <param name="orgPocContact"></param>
        /// <returns></returns>

        public OrgPocContact Put(OrgPocContact orgPocContact)
        {
            return _commands.Put(ActiveUser, orgPocContact);
        }

        /// <summary>
        /// Deletes a specific orgPocContact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of orgPocContact record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<OrgPocContact> GetAllData()
        {
            throw new NotImplementedException();
        }

		public OrgPocContact Patch(OrgPocContact entity)
		{
			throw new NotImplementedException();
		}
	}
}