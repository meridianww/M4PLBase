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
// Program Name:                                 VendDocReferenceCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendDocReferenceCommands
//====================================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendDocReferenceCommands;

namespace M4PL.Business.Vendor
{
	public class VendDocReferenceCommands : BaseCommands<VendDocReference>, IVendDocReferenceCommands
	{
		/// <summary>
		/// Gets list of venddocreference data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<VendDocReference> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific venddocreference record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public VendDocReference Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new venddocreference record
		/// </summary>
		/// <param name="vendDocReference"></param>
		/// <returns></returns>

		public VendDocReference Post(VendDocReference vendDocReference)
		{
			return _commands.Post(ActiveUser, vendDocReference);
		}

		/// <summary>
		/// Updates an existing venddocreference record
		/// </summary>
		/// <param name="vendDocReference"></param>
		/// <returns></returns>

		public VendDocReference Put(VendDocReference vendDocReference)
		{
			return _commands.Put(ActiveUser, vendDocReference);
		}

		/// <summary>
		/// Deletes a specific venddocreference record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of venddocreference record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public VendDocReference Patch(VendDocReference entity)
		{
			throw new NotImplementedException();
		}
	}
}