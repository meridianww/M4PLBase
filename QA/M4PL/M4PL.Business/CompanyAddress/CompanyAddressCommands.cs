/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/11/2019
//Program Name:                                 CompanyAddressCommands
//Purpose:                                     Contains commands to call DAL logic for M4PL.DAL.CompanyAddress.CompanyAddressCommands
//====================================================================================================================================================*/

using System;
using System.Collections.Generic;
using M4PL.Entities.CompanyAddress;
using M4PL.Entities.Support;

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

		public IList<Entities.CompanyAddress.CompanyAddress> Get()
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
