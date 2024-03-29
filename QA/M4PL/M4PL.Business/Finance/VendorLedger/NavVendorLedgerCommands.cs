﻿#region Copyright

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
using M4PL.Business.Finance.SalesOrder;
using M4PL.Entities;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.Vendor;
using M4PL.Entities.Finance.VendorLedger;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace M4PL.Business.Finance.VendorLedger
{
	public class NavVendorLedgerCommands : BaseCommands<NavVendorLedger>, INavVendorLedgerCommands
	{
		public BusinessConfiguration M4PLBusinessConfiguration
		{
			get { return CoreCache.GetBusinessConfiguration("EN"); }
		}

		public List<CheckPostedInvoice> GetVendorCheckedInvoice(string checkNumber, ActiveUser activeUser = null)
		{
			List<CheckPostedInvoice> resultPostedInvoices = null;
			activeUser = activeUser == null ? ActiveUser : activeUser;
			string navAPIPassword;
			string navAPIUserName;
			string navAPIUrl;
			////CustomerNavConfiguration currentCustomerNavConfiguration = null;
			////if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
			////{
			////	currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
			////	navAPIUrl = currentCustomerNavConfiguration.ServiceUrl;
			////	navAPIUserName = currentCustomerNavConfiguration.ServiceUserName;
			////	navAPIPassword = currentCustomerNavConfiguration.ServicePassword;
			////}
			////else
			////{
				navAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
				navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
				navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
			////}

			var vendorLedgerData = GetNavVendorLedgerDataByCheckNumber(navAPIUrl, navAPIUserName, navAPIPassword, checkNumber);
			if (vendorLedgerData?.VendorLedger != null)
			{
				var vendorPaymentRecord = vendorLedgerData.VendorLedger.FirstOrDefault(x => !string.IsNullOrEmpty(x.Document_Type) && x.Document_Type.Equals("Payment", StringComparison.OrdinalIgnoreCase));
				bool isPermissionPresent = DataAccess.Vendor.VendorCommands.IsUserHasVendorPermission(vendorPaymentRecord?.Vendor_No, activeUser.UserId);
				string entryNumber = vendorPaymentRecord?.Entry_No;
				if (isPermissionPresent && !string.IsNullOrEmpty(entryNumber))
				{
					var result = GetNavVendorLedgerDataByClosedByEntryNumber(navAPIUrl, navAPIUserName, navAPIPassword, entryNumber);
					if (result?.VendorLedger?.Count > 0 && result.VendorLedger.Where(x => !string.IsNullOrEmpty(x.Document_Type) && x.Document_Type.Equals("Invoice", StringComparison.OrdinalIgnoreCase)).Any())
					{
						List<Task> tasks = new List<Task>();
						resultPostedInvoices = new List<CheckPostedInvoice>();
						var processingData = result.VendorLedger.Where(x => !string.IsNullOrEmpty(x.Document_Type) && x.Document_Type.Equals("Invoice", StringComparison.OrdinalIgnoreCase));
						foreach (var currentVendorLedger in processingData)
						{
							tasks.Add(Task.Factory.StartNew(() =>
							{
								var postedInvoice = NavSalesOrderHelper.GetNavPostedPurchaseInvoiceResponse(navAPIUserName, navAPIPassword, navAPIUrl, currentVendorLedger.Document_No);
								if (postedInvoice != null && postedInvoice.NavPurchaseOrder != null && postedInvoice.NavPurchaseOrder.Count > 0)
								{
									postedInvoice.NavPurchaseOrder.ForEach(x => resultPostedInvoices.Add(new CheckPostedInvoice()
									{
										No = x.No,
										M4PL_JobId = x.Vendor_Invoice_No,
										Document_Date = x.Document_Date,
										Vendor_Order_No = x.Vendor_Order_No,
										Amount = processingData.Where(z => z.Document_No == x.No).FirstOrDefault().Credit_Amount.ToDecimal()
									}));
								}
							}));
						}

						if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
					}
				}
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

		private NavVendorLedger GetNavVendorLedgerDataByCheckNumber(string navVendorUrl, string navAPIUserName, string navAPIPassword, string documentNumer)
		{
			NavVendorLedger navVendorLedgerResponse = null;
			string serviceCall = string.Format("{0}/Vendor_ledger_Entries?$filter=Document_No eq '{1}'", navVendorUrl, documentNumer);
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

		private NavVendorLedger GetNavVendorLedgerDataByClosedByEntryNumber(string navVendorUrl, string navAPIUserName, string navAPIPassword, string documentNumer)
		{
			NavVendorLedger navVendorLedgerResponse = null;
			string serviceCall = string.Format("{0}/Vendor_ledger_Entries?$filter=Closed_by_Entry_No eq {1}", navVendorUrl, documentNumer);
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
	}
}