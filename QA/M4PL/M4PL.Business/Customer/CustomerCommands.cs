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
// Program Name:                                 CustomerCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer
//====================================================================================================================

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustomerCommands;

namespace M4PL.Business.Customer
{
	public class CustomerCommands : BaseCommands<Entities.Customer.Customer>, ICustomerCommands
	{
		/// <summary>
		/// Get list of memu driver data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Customer.Customer> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific customer record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Customer.Customer Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new customer record
		/// </summary>
		/// <param name="customer"></param>
		/// <returns></returns>

		public Entities.Customer.Customer Post(Entities.Customer.Customer customer)
		{
			return _commands.Post(ActiveUser, customer);
		}

		/// <summary>
		/// Updates an existing customer record
		/// </summary>
		/// <param name="customer"></param>
		/// <returns></returns>

		public Entities.Customer.Customer Put(Entities.Customer.Customer customer)
		{
			return _commands.Put(ActiveUser, customer);
		}

		/// <summary>
		/// Deletes a specific customer record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of customer record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public Entities.Customer.Customer Patch(Entities.Customer.Customer entity)
		{
			return _commands.Patch(ActiveUser, entity);
		}

		public List<Entities.Customer.Customer> GetActiveCutomers()
		{
			return _commands.GetActiveCutomers();
		}
	}
}