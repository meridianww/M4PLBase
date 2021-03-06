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
// Program Name:                                 VendDcLocationCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendDcLocationCommands
//====================================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendDcLocationCommands;

namespace M4PL.Business.Vendor
{
	public class VendDcLocationCommands : BaseCommands<VendDcLocation>, IVendDcLocationCommands
	{
		/// <summary>
		/// Gets list of venddclocation data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<VendDcLocation> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific venddclocation record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public VendDcLocation Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new venddclocation record
		/// </summary>
		/// <param name="vendDcLocation"></param>
		/// <returns></returns>

		public VendDcLocation Post(VendDcLocation vendDcLocation)
		{
			return _commands.Post(ActiveUser, vendDcLocation);
		}

		/// <summary>
		/// Updates an existing venddclocation record
		/// </summary>
		/// <param name="vendDcLocation"></param>
		/// <returns></returns>

		public VendDcLocation Put(VendDcLocation vendDcLocation)
		{
			return _commands.Put(ActiveUser, vendDcLocation);
		}

		/// <summary>
		/// Deletes a specific venddclocation record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of venddclocation record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public VendDcLocation Patch(VendDcLocation entity)
		{
			throw new NotImplementedException();
		}
	}
}