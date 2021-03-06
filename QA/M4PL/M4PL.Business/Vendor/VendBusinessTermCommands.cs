﻿#region Copyright

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
// Program Name:                                 VendBusinessTermCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendBusinessTermCommands
//====================================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendBusinessTermCommands;

namespace M4PL.Business.Vendor
{
	public class VendBusinessTermCommands : BaseCommands<VendBusinessTerm>, IVendBusinessTermCommands
	{
		/// <summary>
		/// Gets list of vendbusinessterm data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<VendBusinessTerm> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific vendbusinessterm record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public VendBusinessTerm Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new vendbusinessterm record
		/// </summary>
		/// <param name="vendBusinessTerm"></param>
		/// <returns></returns>

		public VendBusinessTerm Post(VendBusinessTerm vendBusinessTerm)
		{
			return _commands.Post(ActiveUser, vendBusinessTerm);
		}

		/// <summary>
		/// Updates an existing vendbusinessterm record
		/// </summary>
		/// <param name="vendBusinessTerm"></param>
		/// <returns></returns>

		public VendBusinessTerm Put(VendBusinessTerm vendBusinessTerm)
		{
			return _commands.Put(ActiveUser, vendBusinessTerm);
		}

		/// <summary>
		/// Deletes a specific vendbusinessterm record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of vendbusinessterm record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public VendBusinessTerm Patch(VendBusinessTerm entity)
		{
			throw new NotImplementedException();
		}
	}
}