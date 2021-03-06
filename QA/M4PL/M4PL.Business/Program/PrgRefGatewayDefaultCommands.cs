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
// Program Name:                                 PrgRefGatewayDefaultCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgRefGatewayDefaultCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgRefGatewayDefaultCommands;

namespace M4PL.Business.Program
{
	public class PrgRefGatewayDefaultCommands : BaseCommands<PrgRefGatewayDefault>, IPrgRefGatewayDefaultCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		/// <summary>
		/// Gets list of prgrefgatewaydefault data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<PrgRefGatewayDefault> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific prgrefgatewaydefault record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public PrgRefGatewayDefault Get(long id)
		{
			var result = _commands.Get(ActiveUser, id);
			result.IsSpecificCustomer = result?.CustomerId == M4PLBusinessConfiguration.ElectroluxCustomerId.ToLong() ? true : false;
			return result;
		}

		/// <summary>
		/// Creates a new prgrefgatewaydefault record
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>

		public PrgRefGatewayDefault Post(PrgRefGatewayDefault prgRefGatewayDefault)
		{
			return _commands.Post(ActiveUser, prgRefGatewayDefault);
		}

		/// <summary>
		/// Updates an existing job reference record
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>
		public PrgRefGatewayDefault PostWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			return _commands.PostWithSettings(ActiveUser, userSysSetting, prgRefGatewayDefault);
		}

		/// <summary>
		/// Updates an existingprgrefgatewaydefault record
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>

		public PrgRefGatewayDefault Put(PrgRefGatewayDefault prgRefGatewayDefault)
		{
			return _commands.Put(ActiveUser, prgRefGatewayDefault);
		}

		/// <summary>
		/// Updates an existing job reference record
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>
		public PrgRefGatewayDefault PutWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault)
		{
			return _commands.PutWithSettings(ActiveUser, userSysSetting, prgRefGatewayDefault);
		}

		/// <summary>
		/// Deletes a specific prgrefgatewaydefault record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of prgrefgatewaydefault record
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public PrgRefGatewayDefault Patch(PrgRefGatewayDefault entity)
		{
			throw new NotImplementedException();
		}
	}
}