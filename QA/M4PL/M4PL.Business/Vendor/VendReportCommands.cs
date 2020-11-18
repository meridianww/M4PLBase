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
// Program Name:                                 VendReportCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendReportCommands
//====================================================================================================================
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendReportCommands;

namespace M4PL.Business.Vendor
{
	public class VendReportCommands : BaseCommands<VendReport>, IVendReportCommands
	{
		/// <summary>
		/// Get list of memu driver data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<VendReport> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific VendReport record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public VendReport Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new VendReport record
		/// </summary>
		/// <param name="vendReport"></param>
		/// <returns></returns>

		public VendReport Post(VendReport vendReport)
		{
			return _commands.Post(ActiveUser, vendReport);
		}

		/// <summary>
		/// Updates an existing VendReport record
		/// </summary>
		/// <param name="vendReport"></param>
		/// <returns></returns>

		public VendReport Put(VendReport vendReport)
		{
			return _commands.Put(ActiveUser, vendReport);
		}

		/// <summary>
		/// Deletes a specific VendReport record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of VendReport record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public VendReport Patch(VendReport entity)
		{
			throw new NotImplementedException();
		}
	}
}