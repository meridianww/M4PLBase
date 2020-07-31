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
// Program Name:                                 NavCostCodeCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavCostCodeCommands
//==============================================================================================================
using M4PL.Business.Common;
using M4PL.Entities.Document;
using M4PL.Entities.Finance.CostCode;
using M4PL.Entities.Finance.OrderItem;
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
using _commands = M4PL.DataAccess.Finance.NavCostCodeCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _orderItemCommands = M4PL.DataAccess.Finance.NAVOrderItemCommands;

namespace M4PL.Business.Finance.CostCode
{
	public class NavCostCodeCommands : BaseCommands<NavCostCode>, INavCostCodeCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavCostCode> GetAllCostCode()
		{
			List<NavCostCode> navCostCodeList = null;
			if (!M4PBusinessContext.ComponentSettings.NavRateReadFromItem)
			{
				navCostCodeList = GetNavCostCodeData();
				if (navCostCodeList != null && navCostCodeList.Count > 0)
				{
					_commands.Put(ActiveUser, navCostCodeList);
				}
			}
			else
			{
				NAVOrderItemResponse navOrderItemResponse = CommonCommands.GetNAVOrderItemResponse();
				if (navOrderItemResponse?.OrderItemList?.Count > 0)
				{
					_orderItemCommands.UpdateNavCostCode(ActiveUser, navOrderItemResponse.OrderItemList);
					navCostCodeList = new List<NavCostCode>();
				}
			}

			return navCostCodeList;
		}

		public NavCostCode Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavCostCode> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Patch(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Post(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Put(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		private List<NavCostCode> GetNavCostCodeData()
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			NavCostCodeResponse navCostCodeResponse = null;
			try
			{
				string serviceCall = string.Format("{0}('{1}')/PurchasePrices", navAPIUrl, "Meridian");
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
							navCostCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavCostCodeResponse>(responceString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "Error is occurring when getting the Nav Cost code data.", "GetNavCostCodeData", Utilities.Logger.LogType.Error);
			}

			return (navCostCodeResponse?.CostCodeList?.Count > 0) ?
					navCostCodeResponse.CostCodeList :
					new List<NavCostCode>();
		}

		public DocumentData GetCostCodeReportByJobId(string jobId)
		{
			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			List<Task> tasks = new List<Task>();
			NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderPostedInvoiceResponse = CommonCommands.GetCachedNavPurchaseOrderValues();
			NavPurchaseOrderItemResponse navPurchaseOrderItemResponse = CommonCommands.GetCachedNavPurchaseOrderItemValues();
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			foreach (var currentJobId in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var currentNavSalesOrder = navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJobId);
					if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
					{
						var currentPurchaseLineItem = navPurchaseOrderItemResponse.NavPurchaseOrderItem.Where(x => x.Document_No.Equals(currentNavSalesOrder.No, StringComparison.OrdinalIgnoreCase));
						if (currentPurchaseLineItem.Any() && currentPurchaseLineItem.Count() > 0)
						{
							documentDataList.Add(GetPriceCodeReportDataByJobId(currentJobId, currentPurchaseLineItem.ToList()));
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

		public DocumentData GetPriceCodeReportDataByJobId(long jobId, List<NavPurchaseOrderItem> navPurchaseOrderItem)
		{
			DocumentData documentData = null;
			DataTable tblResultLocal = GetJobPriceReportDataTable(ActiveUser, jobId, navPurchaseOrderItem);
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

		public DocumentStatus IsCostCodeDataPresentForJobInNAV(string jobId)
		{
			if (string.IsNullOrEmpty(jobId))
			{
				return new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			}

			List<long> selectedJobId = jobId.Split(',').Select(Int64.Parse).ToList();
			List<Task> tasks = new List<Task>();
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			NavPurchaseOrderPostedInvoiceResponse navPurchaseOrderPostedInvoiceResponse = CommonCommands.GetCachedNavPurchaseOrderValues();
			NavPurchaseOrderItemResponse navPurchaseOrderItemResponse = CommonCommands.GetCachedNavPurchaseOrderItemValues();
			if (navPurchaseOrderPostedInvoiceResponse == null || (navPurchaseOrderPostedInvoiceResponse != null && navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder == null) || (navPurchaseOrderPostedInvoiceResponse != null && navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder != null && navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder.Count == 0))
			{
				return documentStatus;
			}
			else if (navPurchaseOrderItemResponse == null || (navPurchaseOrderItemResponse != null && navPurchaseOrderItemResponse.NavPurchaseOrderItem == null) || (navPurchaseOrderItemResponse != null && navPurchaseOrderItemResponse.NavPurchaseOrderItem != null && navPurchaseOrderItemResponse.NavPurchaseOrderItem.Count == 0))
			{
				return documentStatus;
			}

			foreach (var currentJob in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var currentNavSalesOrder = navPurchaseOrderPostedInvoiceResponse.NavPurchaseOrder.FirstOrDefault(x => x.M4PL_Job_ID.ToLong() == currentJob);
					if (currentNavSalesOrder != null && !string.IsNullOrEmpty(currentNavSalesOrder.No))
					{
						var currentSalesLineItem = navPurchaseOrderItemResponse.NavPurchaseOrderItem.Where(x => x.Document_No.Equals(currentNavSalesOrder.No, StringComparison.OrdinalIgnoreCase));
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

		public static DataTable GetJobPriceReportDataTable(ActiveUser activeUser, long jobId, List<NavPurchaseOrderItem> navPurchaseOrderItem)
		{
			Entities.Job.Job jobDetails = DataAccess.Job.JobCommands.GetJobByProgram(activeUser, jobId, 0);
			DataTable tblJobPriceReport = new DataTable();
			tblJobPriceReport.Columns.Add("Job ID");
			tblJobPriceReport.Columns.Add("Delivery Date Planned");
			tblJobPriceReport.Columns.Add("Arrival Date Planned");
			tblJobPriceReport.Columns.Add("Job Gateway Scheduled");
			tblJobPriceReport.Columns.Add("Site Code");
			tblJobPriceReport.Columns.Add("Contract #");
			tblJobPriceReport.Columns.Add("Plant Code");
			tblJobPriceReport.Columns.Add("Quantity Actual");
			tblJobPriceReport.Columns.Add("Parts Actual");
			tblJobPriceReport.Columns.Add("Cubes Unit");
			tblJobPriceReport.Columns.Add("Charge Code");
			tblJobPriceReport.Columns.Add("Title");
			tblJobPriceReport.Columns.Add("Rate");
			tblJobPriceReport.Columns.Add("Service Mode");
			tblJobPriceReport.Columns.Add("Customer Purchase Order");
			tblJobPriceReport.Columns.Add("Brand");
			tblJobPriceReport.Columns.Add("Status");
			tblJobPriceReport.Columns.Add("Delivery Site POC");
			tblJobPriceReport.Columns.Add("Delivery Site Phone");
			tblJobPriceReport.Columns.Add("Delivery Site POC 2");
			tblJobPriceReport.Columns.Add("Phone POC Email");
			tblJobPriceReport.Columns.Add("Site Name");
			tblJobPriceReport.Columns.Add("Delivery Site Name");
			tblJobPriceReport.Columns.Add("Delivery Address");
			tblJobPriceReport.Columns.Add("Delivery Address2");
			tblJobPriceReport.Columns.Add("Delivery City");
			tblJobPriceReport.Columns.Add("Delivery State");
			tblJobPriceReport.Columns.Add("Delivery Postal Code");
			tblJobPriceReport.Columns.Add("Delivery Date Actual");
			tblJobPriceReport.Columns.Add("Origin Date Actual");
			tblJobPriceReport.Columns.Add("Ordered Date");

			if (navPurchaseOrderItem?.Count > 0)
			{
				foreach (var purchaseOrderItem in navPurchaseOrderItem)
				{
					var row = tblJobPriceReport.NewRow();
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
					row["Charge Code"] = string.IsNullOrEmpty(purchaseOrderItem.Cross_Reference_No) ? purchaseOrderItem.No : purchaseOrderItem.Cross_Reference_No;
					row["Title"] = purchaseOrderItem.Description;
					row["Rate"] = purchaseOrderItem.Unit_Cost_LCY;
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
					tblJobPriceReport.Rows.Add(row);
					tblJobPriceReport.AcceptChanges();
				}
			}

			return tblJobPriceReport;
		}
	}
}