#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/11/2019
// Program Name:                                 CompanyAddressCommands
// Purpose:                                     Contains commands to call DAL logic for M4PL.DAL.CompanyAddress.CompanyAddressCommands
//=====================================================================================================================================================

using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.CompanyAddress
{
	public class CompanyAddressCommands : BaseCommands<Entities.CompanyAddress.CompanyAddress>, ICompanyAddressCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public Entities.CompanyAddress.CompanyAddress Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<Entities.CompanyAddress.CompanyAddress> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public Entities.CompanyAddress.CompanyAddress Post(Entities.CompanyAddress.CompanyAddress entity)
		{
			throw new NotImplementedException();
		}

		public Entities.CompanyAddress.CompanyAddress Put(Entities.CompanyAddress.CompanyAddress entity)
		{
			throw new NotImplementedException();
		}

		public Entities.CompanyAddress.CompanyAddress Patch(Entities.CompanyAddress.CompanyAddress entity)
		{
			throw new NotImplementedException();
		}
	}
}