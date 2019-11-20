/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
=============================================================================================================*/
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using M4PL.Business.Common;
using System.Linq;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Business.Finance.PurchaseOrder;

namespace M4PL.Business.Finance.SalesOrder
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrder>, INavSalesOrderCommands
	{
		public string NavAPIUrl
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUrl; }
		}

		public string NavAPIUserName
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUserName; }
		}

		public string NavAPIPassword
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIPassword; }
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> Get()
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Patch(NavSalesOrder entity)
		{
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
			return NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, entity.No, entity.Quote_No, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
			return NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo, entity.Electronic_Invoice);
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder CreateSalesOrderForRollup(List<long> jobIdList)
		{
			Entities.Job.Job jobData = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
			return NavSalesOrderHelper.StartOrderCreationProcessForNAV(ActiveUser, jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice);
		}

		public NavSalesOrder UpdateSalesOrderForRollup(List<long> jobIdList)
		{
			Entities.Job.Job jobData = _jobCommands.GetJobByProgram(ActiveUser, jobIdList.FirstOrDefault(), 0);
			return NavSalesOrderHelper.StartOrderUpdationProcessForNAV(ActiveUser, jobIdList, jobData.JobSONumber, jobData.JobPONumber, NavAPIUrl, NavAPIUserName, NavAPIPassword, jobData.VendorERPId, jobData.JobElectronicInvoice);
		}
	}
}
