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
using M4PL.Entities.Document;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
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
			if (!M4PBusinessContext.ComponentSettings.NavRateReadFromItem)
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
			NavSalesOrderItemResponse navSalesOrderItemResponse = CommonCommands.GetCachedNavSalesOrderItemValues();
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			foreach (var currentJobId in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var currentNavSalesOrder = navSalesOrderPostedInvoiceResponse.NavSalesOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJobId);
					if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
					{
						var currentSalesLineItem = navSalesOrderItemResponse.NavSalesOrderItem.Where(x => x.Document_No.Equals(currentNavSalesOrder.No, StringComparison.OrdinalIgnoreCase));
						if (currentSalesLineItem.Any() && currentSalesLineItem.Count() > 0)
						{
							documentDataList.Add(GetCostCodeReportDataByJobId(currentJobId, currentSalesLineItem.ToList()));
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
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedCostCode");
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
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			NavPriceCodeResponse navPriceCodeResponse = null;
			try
			{
				string serviceCall = string.Format("{0}('{1}')/SalesPrices", navAPIUrl, "Meridian");
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

		public DocumentData GetCostCodeReportDataByJobId(long jobId, List<NavSalesOrderItem> navSalesOrderItem)
		{
			DocumentData documentData = null;
			DataTable tblResultLocal = GetJobCostReportDataTable(ActiveUser, jobId, navSalesOrderItem);
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
					documentData.DocumentName = string.Format("CostCode_{0}.csv", jobId);
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
			NavSalesOrderItemResponse navSalesOrderItemResponse = CommonCommands.GetCachedNavSalesOrderItemValues();
			if (navSalesOrderPostedInvoiceResponse == null || (navSalesOrderPostedInvoiceResponse != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder == null) || (navSalesOrderPostedInvoiceResponse != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder != null && navSalesOrderPostedInvoiceResponse.NavSalesOrder.Count == 0))
			{
				return documentStatus;
			}
			else if (navSalesOrderItemResponse == null || (navSalesOrderItemResponse != null && navSalesOrderItemResponse.NavSalesOrderItem == null) || (navSalesOrderItemResponse != null && navSalesOrderItemResponse.NavSalesOrderItem != null && navSalesOrderItemResponse.NavSalesOrderItem.Count == 0))
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
						var currentSalesLineItem = navSalesOrderItemResponse.NavSalesOrderItem.Where(x => x.Document_No.Equals(currentNavSalesOrder.No, StringComparison.OrdinalIgnoreCase));
						if (currentSalesLineItem.Any() && currentSalesLineItem.Count() > 0)
						{
							documentStatus.IsAttachmentPresent = true;
						}
					}
				}));
			}

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }

			return documentStatus;
		}

		public static DataTable GetJobCostReportDataTable(ActiveUser activeUser, long jobId, List<NavSalesOrderItem> navSalesOrderItem)
		{
			Entities.Job.Job jobDetails = DataAccess.Job.JobCommands.GetJobByProgram(activeUser, jobId, 0);
			DataTable tblJobCostReport = new DataTable();
			tblJobCostReport.Columns.Add("Job ID");
			tblJobCostReport.Columns.Add("Delivery Date Planned");
			tblJobCostReport.Columns.Add("Arrival Date Planned");
			tblJobCostReport.Columns.Add("Job Gateway Scheduled");
			tblJobCostReport.Columns.Add("Site Code");
			tblJobCostReport.Columns.Add("Contract #");
			tblJobCostReport.Columns.Add("Plant Code");
			tblJobCostReport.Columns.Add("Quantity Actual");
			tblJobCostReport.Columns.Add("Parts Actual");
			tblJobCostReport.Columns.Add("Cubes Unit");
			tblJobCostReport.Columns.Add("Charge Code");
			tblJobCostReport.Columns.Add("Title");
			tblJobCostReport.Columns.Add("Rate");
			tblJobCostReport.Columns.Add("Service Mode");
			tblJobCostReport.Columns.Add("Customer Purchase Order");
			tblJobCostReport.Columns.Add("Brand");
			tblJobCostReport.Columns.Add("Status");
			tblJobCostReport.Columns.Add("Delivery Site POC");
			tblJobCostReport.Columns.Add("Delivery Site Phone");
			tblJobCostReport.Columns.Add("Delivery Site POC 2");
			tblJobCostReport.Columns.Add("Phone POC Email");
			tblJobCostReport.Columns.Add("Site Name");
			tblJobCostReport.Columns.Add("Delivery Site Name");
			tblJobCostReport.Columns.Add("Delivery Address");
			tblJobCostReport.Columns.Add("Delivery Address2");
			tblJobCostReport.Columns.Add("Delivery City");
			tblJobCostReport.Columns.Add("Delivery State");
			tblJobCostReport.Columns.Add("Delivery Postal Code");
			tblJobCostReport.Columns.Add("Delivery Date Actual");
			tblJobCostReport.Columns.Add("Origin Date Actual");
			tblJobCostReport.Columns.Add("Ordered Date");

			if (navSalesOrderItem?.Count > 0)
			{
				foreach (var salesOrderItem in navSalesOrderItem)
				{
					var row = tblJobCostReport.NewRow();
					row["Job ID"] = jobDetails.Id;
					row["Delivery Date Planned"] = jobDetails.JobDeliveryDateTimePlanned;
					row["Arrival Date Planned"] = jobDetails.JobOriginDateTimePlanned;
					row["Job Gateway Scheduled"] = jobDetails.JobGatewayStatus;
					row["Site Code"] = jobDetails.JobSiteCode;
					row["Contract #"] = jobDetails.JobCustomerSalesOrder;
					row["Plant Code"] = jobDetails.PlantIDCode;
					row["Quantity Actual"] = jobDetails.JobQtyActual;
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
					tblJobCostReport.Rows.Add(row);
					tblJobCostReport.AcceptChanges();
				}
			}

			return tblJobCostReport;
		}
	}
}