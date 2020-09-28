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
using M4PL.Entities.Finance.VendorLedger;
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

namespace M4PL.Business.Finance.VendorLedger
{
	public class NavVendorLedgerCommands : BaseCommands<NavVendorLedger>, INavVendorLedgerCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public List<VendorCheckedInvoice> GetVendorCheckedInvoice(string postedInvoiceNumber)
		{
			List<VendorCheckedInvoice> resultPostedInvoices = null;
			var vendorLedgerData = GetNavVendorLedgerData(M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, postedInvoiceNumber);
			if (vendorLedgerData?.VendorLedger != null && !string.IsNullOrEmpty(vendorLedgerData.VendorLedger?.FirstOrDefault().Closed_by_Entry_No))
			{
				var result = GetNavVendorCheckedInvoice(M4PLBusinessConfiguration.NavAPIUrl, M4PLBusinessConfiguration.NavAPIUserName, M4PLBusinessConfiguration.NavAPIPassword, vendorLedgerData.VendorLedger.FirstOrDefault().Closed_by_Entry_No);
				resultPostedInvoices = result?.VendorCheckedInvoice;
			}

			return resultPostedInvoices;
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public NavVendorLedger Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavVendor> GetAllNavVendor()
		{
			throw new NotImplementedException();
		}

		public IList<NavVendorLedger> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavVendorLedger Patch(NavVendorLedger entity)
		{
			throw new NotImplementedException();
		}

		public NavVendorLedger Post(NavVendorLedger entity)
		{
			throw new NotImplementedException();
		}

		public NavVendorLedger Put(NavVendorLedger entity)
		{
			throw new NotImplementedException();
		}

		private NavVendorLedger GetNavVendorLedgerData(string navVendorUrl, string navAPIUserName, string navAPIPassword, string documentNumer)
		{
			NavVendorLedger navVendorLedgerResponse = null;
			string serviceCall = string.Format("{0}('{1}')/Vendor_ledger_Entries?$filter=Document_No eq '{2}'", navVendorUrl, "Meridian", documentNumer);
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
						navVendorLedgerResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavVendorLedger>(responceString);
					}
				}
			}

			return navVendorLedgerResponse;
		}

		private NavVendorCheckedInvoice GetNavVendorCheckedInvoice(string navVendorUrl, string navAPIUserName, string navAPIPassword, string documentNumer)
		{
			NavVendorCheckedInvoice navVendorCheckedInvoiceResponse = null;
			string serviceCall = string.Format("{0}('{1}')/Vendor_ledger_Entries?$filter=Entry_No eq {2}", navVendorUrl, "Meridian", documentNumer);
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
						navVendorCheckedInvoiceResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavVendorCheckedInvoice>(responceString);
					}
				}
			}

			return navVendorCheckedInvoiceResponse;
		}
	}
}
