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
// Date Programmed:                              06/06/2018
// Program Name:                                 DeliveryStatusCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.DeliveryStatusCommands
//====================================================================================================================

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.DeliveryStatusCommands;

namespace M4PL.Business.Administration
{
	public class DeliveryStatusCommands : BaseCommands<DeliveryStatus>, IDeliveryStatusCommands
	{
		/// <summary>
		/// Get list of deliveryStatus data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<DeliveryStatus> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific deliveryStatus record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public DeliveryStatus Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		/// <summary>
		/// Creates a new deliveryStatus record
		/// </summary>
		/// <param name="deliveryStatus"></param>
		/// <returns></returns>

		public DeliveryStatus Post(DeliveryStatus deliveryStatus)
		{
			return _commands.Post(ActiveUser, deliveryStatus);
		}

		/// <summary>
		/// Updates an existing deliveryStatus record
		/// </summary>
		/// <param name="deliveryStatus"></param>
		/// <returns></returns>

		public DeliveryStatus Put(DeliveryStatus deliveryStatus)
		{
			return _commands.Put(ActiveUser, deliveryStatus);
		}

		/// <summary>
		/// Deletes a specific deliveryStatus record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of deliveryStatus record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public DeliveryStatus Patch(DeliveryStatus entity)
		{
			throw new NotImplementedException();
		}
	}
}