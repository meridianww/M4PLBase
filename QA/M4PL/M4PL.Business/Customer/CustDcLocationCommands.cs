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
// Program Name:                                 CustDcLocationCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustDcLocationCommands
//====================================================================================================================

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustDcLocationCommands;

namespace M4PL.Business.Customer
{
	public class CustDcLocationCommands : BaseCommands<CustDcLocation>, ICustDcLocationCommands
	{
		/// <summary>
		/// Get list of customer dclocation data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<CustDcLocation> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific customer dclocation record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public CustDcLocation Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new customer dclocation record
		/// </summary>
		/// <param name="custDcLocation"></param>
		/// <returns></returns>

		public CustDcLocation Post(CustDcLocation custDcLocation)
		{
			return _commands.Post(ActiveUser, custDcLocation);
		}

		/// <summary>
		/// Updates an existing customer dclocation record
		/// </summary>
		/// <param name="custDcLocation"></param>
		/// <returns></returns>

		public CustDcLocation Put(CustDcLocation custDcLocation)
		{
			return _commands.Put(ActiveUser, custDcLocation);
		}

		/// <summary>
		/// Deletes a specific customer dclocation record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of customer dclocation record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public CustDcLocation Patch(CustDcLocation entity)
		{
			throw new NotImplementedException();
		}
	}
}