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
// Program Name:                                 CustDocReferenceCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustDocReferenceCommands
//====================================================================================================================

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustDocReferenceCommands;

namespace M4PL.Business.Customer
{
	public class CustDocReferenceCommands : BaseCommands<CustDocReference>, ICustDocReferenceCommands
	{
		/// <summary>
		/// Get list of customer document reference data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<CustDocReference> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific customer document reference record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public CustDocReference Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new customer document reference record
		/// </summary>
		/// <param name="customerDocumentReference"></param>
		/// <returns></returns>

		public CustDocReference Post(CustDocReference customerDocumentReference)
		{
			return _commands.Post(ActiveUser, customerDocumentReference);
		}

		/// <summary>
		/// Updates an existingcustomer document reference record
		/// </summary>
		/// <param name="customerDocumentReference"></param>
		/// <returns></returns>

		public CustDocReference Put(CustDocReference customerDocumentReference)
		{
			return _commands.Put(ActiveUser, customerDocumentReference);
		}

		/// <summary>
		/// Deletes a specific customer document reference record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of customer document reference record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public CustDocReference Patch(CustDocReference entity)
		{
			throw new NotImplementedException();
		}
	}
}