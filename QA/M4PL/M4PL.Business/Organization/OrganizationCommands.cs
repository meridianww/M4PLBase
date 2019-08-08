/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrganizationCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.Organization.OrganizationCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrganizationCommands;
using M4PL.Entities.Organization;
using System;

namespace M4PL.Business.Organization
{
    public class OrganizationCommands : BaseCommands<Entities.Organization.Organization>, IOrganizationCommands
    {
        /// <summary>
        /// Get list of organization data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Organization.Organization> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific organization record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Organization.Organization Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new organization record
        /// </summary>
        /// <param name="organization"></param>
        /// <returns></returns>

        public Entities.Organization.Organization Post(Entities.Organization.Organization organization)
        {
            return _commands.Post(ActiveUser, organization);
        }

        /// <summary>
        /// Updates an existing organization record
        /// </summary>
        /// <param name="organization"></param>
        /// <returns></returns>

        public Entities.Organization.Organization Put(Entities.Organization.Organization organization)
        {
            return _commands.Put(ActiveUser, organization);
        }

        /// <summary>
        /// Deletes a specific organization record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of organization record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<Entities.Organization.Organization> Get()
        {
            throw new NotImplementedException();
        }

		public Entities.Organization.Organization Patch(Entities.Organization.Organization entity)
		{
			return _commands.Patch(ActiveUser, entity);
		}
	}
}