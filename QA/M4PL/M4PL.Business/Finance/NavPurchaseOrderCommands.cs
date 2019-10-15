/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavPurchaseOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPurchaseOrderCommands
=============================================================================================================*/
using M4PL.Entities.Finance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using System.Net;
using System.IO;
using _commands = M4PL.DataAccess.Finance.NavPurchaseOrderCommands;

namespace M4PL.Business.Finance
{
	public class NavPurchaseOrderCommands : BaseCommands<NavPurchaseOrder>, INavPurchaseOrderCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavPurchaseOrder> Get()
		{
			throw new NotImplementedException();
		}

		public NavPurchaseOrder Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavPurchaseOrder> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavPurchaseOrder Patch(NavPurchaseOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavPurchaseOrder Post(NavPurchaseOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavPurchaseOrder Put(NavPurchaseOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavPurchaseOrder CreatePurchaseOrderForNAV(long jobId)
		{
			return new NavPurchaseOrder();
		}
	}
}
