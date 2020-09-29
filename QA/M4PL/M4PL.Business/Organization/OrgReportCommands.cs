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
// Date Programmed:                              04/16/2018
// Program Name:                                 OrgReportCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Organization.OrgReportCommands
//====================================================================================================================
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgReportCommands;

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

		public OrgReport Patch(OrgReport entity)
		{
			throw new NotImplementedException();
		}
	}
}