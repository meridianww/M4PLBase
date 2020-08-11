#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 NavRateCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.NavRateCommands
//==============================================================================================================

using System;
using System.Collections.Generic;
using M4PL.Entities;
using M4PL.Entities.Finance.Customer;
using M4PL.Entities.Support;

namespace M4PL.Business.Finance.Gateway
{
	public class GatewayCommands : BaseCommands<Entities.Finance.Customer.Gateway>, IGatewayCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public StatusModel GenerateProgramGateway(List<Entities.Finance.Customer.Gateway> gatewayList)
		{
			return new StatusModel();
		}

		public Entities.Finance.Customer.Gateway Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<Entities.Finance.Customer.Gateway> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Patch(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Post(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Put(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}
	}
}