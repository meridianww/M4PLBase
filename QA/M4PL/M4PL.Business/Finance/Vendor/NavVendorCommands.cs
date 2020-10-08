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
// Program Name:                                 NavVendorCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavVendorCommands
//==============================================================================================================
using M4PL.Entities;
using M4PL.Entities.Finance.Vendor;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Finance.NavVendorCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _vendorCommands = M4PL.DataAccess.Vendor.VendorCommands;

namespace M4PL.Business.Finance.Vendor
{
	public class NavVendorCommands : BaseCommands<NavVendor>, INavVendorCommands
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

		public NavVendor Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavVendor> GetAllNavVendor()
		{
			IList<NavVendor> navOneToManyVendorList = new List<NavVendor>();
			List<NavVendor> navOneToOneVendorList = new List<NavVendor>(); ;
			IList<NavVendorData> navVendorData = null;
			string navVendorUrl = M4PLBusinessConfiguration.NavAPIUrl;
			string navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
			string navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
			IList<Entities.Vendor.Vendor> m4PLVendorData = null;
			Task[] tasks = new Task[2];

			NavVendor navVendor = null;
			char[] splitchar = { ' ' };
			tasks[0] = Task.Factory.StartNew(() =>
			{
				try
				{
					m4PLVendorData = _vendorCommands.Get(ActiveUser);
				}
				catch (Exception exp)
				{
					_logger.Log(exp, "Error is occuring while getting the active vendor list for NAV Vendor Match.", "NAVCustomerCommands", Utilities.Logger.LogType.Error);
				}
			});
			tasks[1] = Task.Factory.StartNew(() =>
			{
				try
				{
					navVendorData = GetNavVendorData(navVendorUrl, navAPIUserName, navAPIPassword);
				}
				catch (Exception exp)
				{
					_logger.Log(exp, "Error is occuring while getting the NAV Vendor List For Vendor Match.", "NAVCustomerCommands", Utilities.Logger.LogType.Error);
				}
			});

			Task.WaitAll(tasks);
			IEnumerable<NavVendorData> vendorMatchList = null;
			if (m4PLVendorData.Any())
			{
				foreach (var vendor in m4PLVendorData)
				{
					string[] vendorName = vendor.VendTitle.Split(splitchar, StringSplitOptions.RemoveEmptyEntries);
					if (navVendorData.Any())
					{
						vendorMatchList = navVendorData.Where(vendorData => vendorData.Name.Replace(" ", string.Empty).ToUpper() == vendor.VendTitle.Replace(" ", string.Empty).ToUpper()).Any() ?
										  navVendorData.Where(vendorData => vendorData.Name.Replace(" ", string.Empty).ToUpper() == vendor.VendTitle.Replace(" ", string.Empty).ToUpper()) :
										  navVendorData.Where(x => x.Name.StartsWith(vendorName[0], StringComparison.OrdinalIgnoreCase)).Any() ?
										  navVendorData.Where(x => x.Name.Replace(" ", string.Empty).StartsWith(vendorName[0], StringComparison.OrdinalIgnoreCase)) :
										  navVendorData.Where(x => x.Name.Replace(" ", string.Empty).ToUpper().Contains(vendorName[0].ToUpper())).Any() ?
										  navVendorData.Where(x => x.Name.Replace(" ", string.Empty).ToUpper().Contains(vendorName[0].ToUpper())) :
										  null;
					}

					if (vendorMatchList != null && vendorMatchList.Count() > 1)
					{
						navVendor = new NavVendor()
						{
							PBS_Vendor_Code = vendor.VendCode,
							Name = vendor.VendTitle,
							M4PLVendorId = vendor.Id
						};

						navVendor.MatchedVendor = new List<MatchedVendor>();
						foreach (var vendorMatch in vendorMatchList)
						{
							navVendor.MatchedVendor.Add(new MatchedVendor()
							{
								VendorCode = vendorMatch.PBS_Vendor_Code,
								ERPId = vendorMatch.Id,
								VendorName = vendorMatch.Name
							});
						}

						navOneToManyVendorList.Add(navVendor);
					}
					else
					{
						var matchedNavVendor = vendorMatchList != null && vendorMatchList.Count() > 0 ? vendorMatchList.FirstOrDefault() : null;
						navOneToOneVendorList.Add(new NavVendor()
						{
							PBS_Vendor_Code = vendor.VendCode,
							Name = vendor.SysRefName,
							M4PLVendorId = vendor.Id,
							ERPId = matchedNavVendor == null ? string.Empty : matchedNavVendor.Id
						});

						navVendorData.Remove(matchedNavVendor);
					}
				}
			}

			if (navOneToOneVendorList != null && navOneToOneVendorList.Count > 0)
			{
				_commands.Put(ActiveUser, navOneToOneVendorList);
			}

			return navOneToManyVendorList;
		}

		private IList<NavVendorData> GetNavVendorData(string navVendorUrl, string navAPIUserName, string navAPIPassword)
		{
			NavVendorResponse naveVendorResponse = null;
			string serviceCall = string.Format("{0}/VendorList", navVendorUrl);
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
						naveVendorResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavVendorResponse>(responceString);
					}
				}
			}

			return (naveVendorResponse != null && naveVendorResponse.VendorList != null && naveVendorResponse.VendorList.Count > 0) ?
					naveVendorResponse.VendorList :
					null;
		}

		public IList<NavVendor> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavVendor Post(NavVendor entity)
		{
			throw new NotImplementedException();
		}

		public NavVendor Put(NavVendor entity)
		{
			List<NavVendor> naveVendorList = new List<NavVendor>();
			naveVendorList.Add(entity);
			return _commands.Put(ActiveUser, naveVendorList);
		}

		public NavVendor Patch(NavVendor entity)
		{
			throw new NotImplementedException();
		}
	}
}