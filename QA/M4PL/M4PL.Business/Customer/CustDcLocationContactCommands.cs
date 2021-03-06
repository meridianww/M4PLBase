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
// Date Programmed:                              09/25/2018
// Program Name:                                 CustDcLocationContactCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustDcLocationContactCommands
//====================================================================================================================
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustDcLocationContactCommands;

namespace M4PL.Business.Customer
{
	public class CustDcLocationContactCommands : BaseCommands<CustDcLocationContact>, ICustDcLocationContactCommands
	{
		/// <summary>
		/// Get list of customer dclocation data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<CustDcLocationContact> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific customer dclocation record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public CustDcLocationContact Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new customer dclocation contact record
		/// </summary>
		/// <param name="custDcLocationContact"></param>
		/// <returns></returns>

		public CustDcLocationContact Post(CustDcLocationContact custDcLocationContact)
		{
			return _commands.Post(ActiveUser, custDcLocationContact);
		}

		/// <summary>
		/// Updates an existing customer dclocation contact record
		/// </summary>
		/// <param name="custDcLocationContact"></param>
		/// <returns></returns>

		public CustDcLocationContact Put(CustDcLocationContact custDcLocationContact)
		{
			return _commands.Put(ActiveUser, custDcLocationContact);
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

		/// <summary>
		/// Gets specific customer dclocation record based on the userid
		/// </summary>
		/// <param name="activeuser"></param>
		/// <param name="id"></param>
		/// <param name="parentId"></param>
		/// <returns></returns>
		public CustDcLocationContact GetCustDcLocationContact(ActiveUser activeuser, long id, long? parentId)
		{
			return _commands.Get(activeuser, id, parentId);
		}

		public CustDcLocationContact Patch(CustDcLocationContact entity)
		{
			throw new NotImplementedException();
		}
	}
}