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
// Program Name:                                 NavCustomerCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.NavCustomerCommands
//==============================================================================================================
using M4PL.Entities;
using M4PL.Entities.Finance.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Finance.NavCustomerCommands;
using _customerCommands = M4PL.DataAccess.Customer.CustomerCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.Business.Finance.Customer
{
	public class NavCustomerCommands : BaseCommands<NavCustomer>, INavCustomerCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavCustomer> GetAllNavCustomer()
		{
			IList<NavCustomer> navOneToManyCustomerList = new List<NavCustomer>();
			List<NavCustomer> navOneToOneCustomerList = new List<NavCustomer>(); ;
			IList<NavCustomerData> navCustomerData = null;
			string navCustomerUrl = M4PLBusinessConfiguration.NavAPIUrl;
			string navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
			string navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
			IList<Entities.Customer.Customer> m4PLCustomerData = null;
			Task[] tasks = new Task[2];

			NavCustomer navCustomer = null;
			char[] splitchar = { ' ' };
			tasks[0] = Task.Factory.StartNew(() =>
			{
				try
				{
					m4PLCustomerData = _customerCommands.Get(ActiveUser);
				}
				catch (Exception exp)
				{
					_logger.Log(exp, "Error is occuring while getting the active customer list for NAV Customer Match.", "NAVCustomerCommands", Utilities.Logger.LogType.Error);
				}
			});
			tasks[1] = Task.Factory.StartNew(() =>
			{
				try
				{
					navCustomerData = GetNavCustomerData(navCustomerUrl, navAPIUserName, navAPIPassword);
				}
				catch (Exception exp)
				{
					_logger.Log(exp, "Error is occuring while getting the NAV Customer Data.", "NAVCustomerCommands", Utilities.Logger.LogType.Error);
				}
			});

			Task.WaitAll(tasks);
			IEnumerable<NavCustomerData> navCustomerMatchList = null;
			if (m4PLCustomerData.Any())
			{
				foreach (var customer in m4PLCustomerData)
				{
					string[] customerName = customer.CustTitle.Split(splitchar, StringSplitOptions.RemoveEmptyEntries);
					if (navCustomerData.Any())
					{
						navCustomerMatchList = navCustomerData.Where(customerData => customerData.Name.Replace(" ", string.Empty).ToUpper() == customer.CustTitle.Replace(" ", string.Empty).ToUpper()).Any() ?
										  navCustomerData.Where(customerData => customerData.Name.Replace(" ", string.Empty).ToUpper() == customer.CustTitle.Replace(" ", string.Empty).ToUpper()) :
										  navCustomerData.Where(x => x.Name.StartsWith(customerName[0], StringComparison.OrdinalIgnoreCase)).Any() ?
										  navCustomerData.Where(x => x.Name.Replace(" ", string.Empty).StartsWith(customerName[0], StringComparison.OrdinalIgnoreCase)) :
										  navCustomerData.Where(x => x.Name.Replace(" ", string.Empty).ToUpper().Contains(customerName[0].ToUpper())).Any() ?
										  navCustomerData.Where(x => x.Name.Replace(" ", string.Empty).ToUpper().Contains(customerName[0].ToUpper())) :
										  null;
					}

					if (navCustomerMatchList != null && navCustomerMatchList.Count() > 1)
					{
						navCustomer = new NavCustomer()
						{
							PBS_Customer_Code = customer.CustCode,
							Name = customer.CustTitle,
							M4PLCustomerId = customer.Id
						};

						navCustomer.MatchedCustomer = new List<MatchedCustomer>();
						foreach (var navCustomerMatch in navCustomerMatchList)
						{
							navCustomer.MatchedCustomer.Add(new MatchedCustomer()
							{
								CustomerCode = navCustomerMatch.PBS_Customer_Code,
								ERPId = navCustomerMatch.Id,
								CustomerName = navCustomerMatch.Name
							});
						}

						navOneToManyCustomerList.Add(navCustomer);
					}
					else
					{
						navOneToOneCustomerList.Add(new NavCustomer()
						{
							PBS_Customer_Code = customer.CustCode,
							Name = customer.SysRefName,
							M4PLCustomerId = customer.Id,
							ERPId = (navCustomerMatchList != null && navCustomerMatchList.Count() > 0) ? navCustomerMatchList.FirstOrDefault().Id : string.Empty
						});
					}
				}
			}

			if (navOneToOneCustomerList != null && navOneToOneCustomerList.Count > 0)
			{
				_commands.Put(ActiveUser, navOneToOneCustomerList);
			}

			return navOneToManyCustomerList;
		}

		public IList<NavCustomer> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		private IList<NavCustomerData> GetNavCustomerData(string navCustomerUrl, string navAPIUserName, string navAPIPassword)
		{
			NavCustomerResponse naveCustomerResponse = null;
			string serviceCall = string.Format("{0}('{1}')/CustomerList", navCustomerUrl, "Meridian");
			NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
			HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
			request.Credentials = myCredentials;
			request.KeepAlive = false;
			WebResponse response = request.GetResponse();

			using (Stream carrierServiceStream = response.GetResponseStream())
			{
				using (TextReader txtCarrierSyncReader = new StreamReader(carrierServiceStream))
				{
					string responceString = txtCarrierSyncReader.ReadToEnd();

					using (var stringReader = new StringReader(responceString))
					{
						naveCustomerResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavCustomerResponse>(responceString);
					}
				}
			}

			return (naveCustomerResponse != null && naveCustomerResponse.CustomerList != null && naveCustomerResponse.CustomerList.Count > 0) ?
					naveCustomerResponse.CustomerList :
					null;
		}

		public NavCustomer Post(NavCustomer entity)
		{
			throw new NotImplementedException();
		}

		public NavCustomer Put(NavCustomer entity)
		{
			List<NavCustomer> navCustomerList = new List<NavCustomer>();
			navCustomerList.Add(entity);
			return _commands.Put(ActiveUser, navCustomerList);
		}

		NavCustomer IBaseCommands<NavCustomer>.Get(long id)
		{
			throw new NotImplementedException();
		}

		public NavCustomer Patch(NavCustomer entity)
		{
			throw new NotImplementedException();
		}
	}
}