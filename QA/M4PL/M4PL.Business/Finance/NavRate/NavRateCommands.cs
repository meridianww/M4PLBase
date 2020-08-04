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

namespace M4PL.Business.Finance.NavRate
{
	public class NavRateCommands : BaseCommands<Entities.Finance.Customer.NavRate>, INavRateCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public StatusModel GenerateProgramPriceCostCode(List<Entities.Finance.Customer.NavRate> navRateList)
		{
			return DataAccess.Finance.NavRateCommands.GenerateProgramPriceCostCode(navRateList, ActiveUser);
		}

		public Entities.Finance.Customer.NavRate Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<Entities.Finance.Customer.NavRate> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.NavRate Patch(Entities.Finance.Customer.NavRate entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.NavRate Post(Entities.Finance.Customer.NavRate entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.NavRate Put(Entities.Finance.Customer.NavRate entity)
		{
			throw new NotImplementedException();
		}
	}
}