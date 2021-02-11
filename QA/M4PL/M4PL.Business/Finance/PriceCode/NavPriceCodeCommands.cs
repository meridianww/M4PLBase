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
// Date Programmed:                              07/31/2019
// Program Name:                                 NavPriceCodeCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPriceCodeCommands
//==============================================================================================================
using M4PL.Business.Common;
using M4PL.Entities;
using M4PL.Entities.Document;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Finance.NavPriceCodeCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _orderItemCommands = M4PL.DataAccess.Finance.NAVOrderItemCommands;

namespace M4PL.Business.Finance.PriceCode
{
	public class NavPriceCodeCommands : BaseCommands<NavPriceCode>, INavPriceCodeCommands
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

		public IList<NavPriceCode> GetAllPriceCode()
		{
			List<NavPriceCode> navPriceCodeList = null;
			if (!M4PLBusinessConfiguration.NavRateReadFromItem.ToBoolean())
			{
				navPriceCodeList = GetNavPriceCodeData();
				if (navPriceCodeList != null && navPriceCodeList.Count > 0)
				{
					_commands.Put(ActiveUser, navPriceCodeList);
				}
			}
			else
			{
				NAVOrderItemResponse navOrderItemResponse = CommonCommands.GetNAVOrderItemResponse();
				if (navOrderItemResponse?.OrderItemList?.Count > 0)
				{
					_orderItemCommands.UpdateNavPriceCode(ActiveUser, navOrderItemResponse.OrderItemList);
					navPriceCodeList = new List<NavPriceCode>();
				}
			}

			return navPriceCodeList;
		}

		public DocumentData GetPriceCodeReportByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			List<Task> tasks = new List<Task>();
			NavSalesOrderPostedInvoiceResponse navSalesOrderPostedInvoiceResponse = CommonCommands.GetCachedNavSalesOrderValues();
			NavSalesOrderItemResponse navSalesOrderItemResponse = null;
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			foreach (var currentJobId in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var currentNavSalesOrder = navSalesOrderPostedInvoiceResponse.NavSalesOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJobId);
					if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
					{
						navSalesOrderItemResponse = CommonCommands.GetCachedNavSalesOrderItemValues(currentNavSalesOrder.No);
						var currentSalesLineItem = navSalesOrderItemResponse != null ? navSalesOrderItemResponse.NavSalesOrderItem : null;
						if (currentSalesLineItem != null && currentSalesLineItem.Count() > 0)
						{
							documentDataList.Add(GetPriceCodeReportDataByJobId(currentJobId, currentSalesLineItem.ToList()));
						}
					}
				}));
			}

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
			documentDataList = documentDataList.Where(x => x != null).Any() ? documentDataList.Where(x => x != null).ToList() : new List<DocumentData>();
			if (documentDataList?.Count > 1)
			{
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
					{
						foreach (var trackingDocument in documentDataList)
						{
							var entry = archive.CreateEntry(trackingDocument.DocumentName, CompressionLevel.Fastest);
							using (var zipStream = entry.Open())
							{
								zipStream.Write(trackingDocument.DocumentContent, 0, trackingDocument.DocumentContent.Length);
							}
						}
					}
					documentData = new DocumentData();
					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedPriceCode");
					documentData.ContentType = "application/zip";
				}
			}
			else if (documentDataList?.Count == 1)
			{
				return documentDataList[0];
			}

			return documentData;
		}

		public NavPriceCode Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavPriceCode> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavPriceCode Patch(NavPriceCode entity)
		{
			throw new NotImplementedException();
		}

		public NavPriceCode Post(NavPriceCode entity)
		{
			throw new NotImplementedException();
		}

		public NavPriceCode Put(NavPriceCode entity)
		{
			throw new NotImplementedException();
		}

		private List<NavPriceCode> GetNavPriceCodeData()
		{
            NavPriceCodeResponse navPriceCodeResponse = null;
            CustomerNavConfiguration currentCustomerNavConfiguration = null;
            string navAPIUserName;
            string navAPIUrl;
            string navAPIPassword;
            ////if (M4PLBusinessConfiguration.CustomerNavConfiguration != null && M4PLBusinessConfiguration.CustomerNavConfiguration.Count > 0)
            ////{
            ////    currentCustomerNavConfiguration = M4PLBusinessConfiguration.CustomerNavConfiguration.FirstOrDefault();
            ////    navAPIUrl = currentCustomerNavConfiguration.ServiceUrl;
            ////    navAPIUserName = currentCustomerNavConfiguration.ServiceUserName;
            ////    navAPIPassword = currentCustomerNavConfiguration.ServicePassword;
            ////}
            ////else
            ////{
                navAPIUrl = M4PLBusinessConfiguration.NavAPIUrl;
                navAPIUserName = M4PLBusinessConfiguration.NavAPIUserName;
                navAPIPassword = M4PLBusinessConfiguration.NavAPIPassword;
           //// }

            try
			{
				string serviceCall = string.Format("{0}/SalesPrices", navAPIUrl);
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				WebResponse response = request.GetResponse();

				using (Stream navPriceCodeResponseStream = response.GetResponseStream())
				{
					using (TextReader txtCarrierSyncReader = new StreamReader(navPriceCodeResponseStream))
					{
						string responceString = txtCarrierSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navPriceCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPriceCodeResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
			}

			return (navPriceCodeResponse?.PriceCodeList?.Count > 0) ?
					navPriceCodeResponse.PriceCodeList :
					new List<NavPriceCode>();
		}

		public DocumentData GetPriceCodeReportDataByJobId(long jobId, List<PostedSalesOrderLine> navSalesOrderItem)
		{
			DocumentData documentData = null;
			DataTable tblResultLocal = GetJobPriceCodeReportDataTable(ActiveUser, jobId, navSalesOrderItem);
			if (tblResultLocal != null && tblResultLocal.Rows.Count > 0)
			{
				documentData = new DocumentData();
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (StreamWriter writer = new StreamWriter(memoryStream))
					{
						WriteDataTable(tblResultLocal, writer, true);
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("PriceCode_{0}.csv", jobId);
					documentData.ContentType = "text/csv";
				}
			}

			return documentData;
		}

		public void WriteDataTable(DataTable sourceTable, TextWriter writer, bool includeHeaders)
		{
			if (includeHeaders)
			{
				IEnumerable<String> headerValues = sourceTable.Columns
					.OfType<DataColumn>()
					.Select(column => QuoteValue(column.ColumnName));

				writer.WriteLine(String.Join(",", headerValues));
			}
			IEnumerable<String> items = null;
			foreach (DataRow row in sourceTable.Rows)
			{
				items = row.ItemArray.Select(o => QuoteValue(o?.ToString() ?? String.Empty));
				writer.WriteLine(String.Join(",", items));
			}
			writer.Flush();
		}

		private string QuoteValue(string value)
		{
			return String.Concat("\"",
			value.Replace("\"", "\"\""), "\"");
		}

		public DocumentStatus IsPriceCodeDataPresentForJobInNAV(string jobId)
		{
			if (string.IsNullOrEmpty(jobId))
			{
				return new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			}

			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			List<Task> tasks = new List<Task>();
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			NavSalesOrderPostedInvoiceResponse navSalesOrderPostedInvoiceResponse = CommonCommands.GetCachedNavSalesOrderValues();
			NavSalesOrderItemResponse navSalesOrderItemResponse = null;
			if (navSalesOrderPostedInvoiceResponse == null || (navSalesOrderPostedInvoiceResponse != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder == null) || (navSalesOrderPostedInvoiceResponse != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder.Count == 0))
			{
				return documentStatus;
			}
			
			foreach (var currentJob in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var currentNavSalesOrder = navSalesOrderPostedInvoiceResponse.NavSalesOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJob);
					if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
					{
						navSalesOrderItemResponse = CommonCommands.GetCachedNavSalesOrderItemValues(currentNavSalesOrder.No);
						var currentSalesLineItem = navSalesOrderItemResponse != null ? navSalesOrderItemResponse.NavSalesOrderItem : null;
						if (currentSalesLineItem != null && currentSalesLineItem.Count() > 0)
						{
							documentStatus.IsAttachmentPresent = true;
						}
					}
				}));
			}

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }

			return documentStatus;
		}

		public static DataTable GetJobPriceCodeReportDataTable(ActiveUser activeUser, long jobId, List<PostedSalesOrderLine> navSalesOrderItem)
		{
			Entities.Job.Job jobDetails = DataAccess.Job.JobCommands.GetJobByProgram(activeUser, jobId, 0);
			DataTable tblJobPriceCodeReport = new DataTable();
			tblJobPriceCodeReport.Columns.Add("Job ID");
			tblJobPriceCodeReport.Columns.Add("Scheduled Delivery Date");
			tblJobPriceCodeReport.Columns.Add("Arrival Date Planned");
			tblJobPriceCodeReport.Columns.Add("Job Gateway Scheduled");
			tblJobPriceCodeReport.Columns.Add("Site Code");
			tblJobPriceCodeReport.Columns.Add("Contract #");
			tblJobPriceCodeReport.Columns.Add("Plant Code");
			tblJobPriceCodeReport.Columns.Add("Quantity Actual");
			tblJobPriceCodeReport.Columns.Add("Parts Actual");
			tblJobPriceCodeReport.Columns.Add("Cubes Unit");
			tblJobPriceCodeReport.Columns.Add("Charge Code");
			tblJobPriceCodeReport.Columns.Add("Title");
			tblJobPriceCodeReport.Columns.Add("Rate");
			tblJobPriceCodeReport.Columns.Add("Service Mode");
			tblJobPriceCodeReport.Columns.Add("Customer Purchase Order");
			tblJobPriceCodeReport.Columns.Add("Brand");
			tblJobPriceCodeReport.Columns.Add("Status");
			tblJobPriceCodeReport.Columns.Add("Delivery Site POC");
			tblJobPriceCodeReport.Columns.Add("Delivery Site Phone");
			tblJobPriceCodeReport.Columns.Add("Delivery Site POC 2");
			tblJobPriceCodeReport.Columns.Add("Phone POC Email");
			tblJobPriceCodeReport.Columns.Add("Site Name");
			tblJobPriceCodeReport.Columns.Add("Delivery Site Name");
			tblJobPriceCodeReport.Columns.Add("Delivery Address");
			tblJobPriceCodeReport.Columns.Add("Delivery Address2");
			tblJobPriceCodeReport.Columns.Add("Delivery City");
			tblJobPriceCodeReport.Columns.Add("Delivery State");
			tblJobPriceCodeReport.Columns.Add("Delivery Postal Code");
			tblJobPriceCodeReport.Columns.Add("Delivery Date Actual");
			tblJobPriceCodeReport.Columns.Add("Origin Date Actual");
			tblJobPriceCodeReport.Columns.Add("Ordered Date");

			if (navSalesOrderItem?.Count > 0)
			{
				foreach (var salesOrderItem in navSalesOrderItem)
				{
					var row = tblJobPriceCodeReport.NewRow();
					row["Job ID"] = jobDetails.Id;
					row["Scheduled Delivery Date"] = jobDetails.JobDeliveryDateTimePlanned;
					row["Arrival Date Planned"] = jobDetails.JobOriginDateTimePlanned;
					row["Job Gateway Scheduled"] = jobDetails.JobGatewayStatus;
					row["Site Code"] = jobDetails.JobSiteCode;
					row["Contract #"] = jobDetails.JobCustomerSalesOrder;
					row["Plant Code"] = jobDetails.PlantIDCode;
					row["Quantity Actual"] = salesOrderItem.Quantity;
					row["Parts Actual"] = jobDetails.JobPartsActual;
					row["Cubes Unit"] = jobDetails.JobTotalCubes;
					row["Charge Code"] = string.IsNullOrEmpty(salesOrderItem.Cross_Reference_No) ? salesOrderItem.No : salesOrderItem.Cross_Reference_No;
					row["Title"] = salesOrderItem.Description;
					row["Rate"] = salesOrderItem.Unit_Price;
					row["Service Mode"] = jobDetails.JobServiceMode;
					row["Customer Purchase Order"] = jobDetails.JobCustomerPurchaseOrder;
					row["Brand"] = jobDetails.JobCarrierContract;
					row["Status"] = jobDetails.StatusId == 1 ? "Active" : jobDetails.StatusId == 2 ? "InActive" : "Archive";
					row["Delivery Site POC"] = jobDetails.JobDeliverySitePOC;
					row["Delivery Site Phone"] = jobDetails.JobDeliverySitePOCPhone;
					row["Delivery Site POC 2"] = jobDetails.JobDeliverySitePOCPhone2;
					row["Phone POC Email"] = jobDetails.JobDeliverySitePOCEmail;
					row["Site Name"] = jobDetails.JobOriginSiteName;
					row["Delivery Site Name"] = jobDetails.JobDeliverySiteName;
					row["Delivery Address"] = jobDetails.JobDeliveryStreetAddress;
					row["Delivery Address2"] = jobDetails.JobDeliveryStreetAddress2;
					row["Delivery City"] = jobDetails.JobDeliveryCity;
					row["Delivery State"] = jobDetails.JobDeliveryState;
					row["Delivery Postal Code"] = jobDetails.JobDeliveryPostalCode;
					row["Delivery Date Actual"] = jobDetails.JobDeliveryDateTimeActual;
					row["Origin Date Actual"] = jobDetails.JobOriginDateTimeActual;
					row["Ordered Date"] = jobDetails.JobOrderedDate;
					tblJobPriceCodeReport.Rows.Add(row);
					tblJobPriceCodeReport.AcceptChanges();
				}
			}

			return tblJobPriceCodeReport;
		}
	}
}