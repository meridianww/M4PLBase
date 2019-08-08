/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgReportCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgReportCommands
===================================================================================================================*/
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgReportCommands;
using System;

namespace M4PL.Business.Organization
{
    public class OrgReportCommands : BaseCommands<OrgReport>, IOrgReportCommands
    {
        /// <summary>
        /// Get list of memu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific OrgReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new OrgReport record
        /// </summary>
        /// <param name="orgReport"></param>
        /// <returns></returns>

        public OrgReport Post(OrgReport orgReport)
        {
            return _commands.Post(ActiveUser, orgReport);
        }

        /// <summary>
        /// Updates an existing OrgReport record
        /// </summary>
        /// <param name="orgReport"></param>
        /// <returns></returns>

        public OrgReport Put(OrgReport orgReport)
        {
            return _commands.Put(ActiveUser, orgReport);
        }

        /// <summary>
        /// Deletes a specific OrgReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of OrgReport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<OrgReport> Get()
        {
            throw new NotImplementedException();
        }

		public OrgReport Patch(OrgReport entity)
		{
			throw new NotImplementedException();
		}
	}
}