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
using M4PL.APIClient.ViewModels.Document;
using M4PL.Business.Common;
using M4PL.Entities.Document;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Finance.NavPriceCodeCommands;
using _attachmentCommands = M4PL.DataAccess.Attachment.AttachmentCommands;
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
            List<long> selectedJobId = !string.IsNullOrEmpty(jobId) ? jobId.Split(',').Select(Int64.Parse).ToList() : null;
            DocumentData documentData = null;
            List<DocumentData> documentDataList = new List<DocumentData>();
            List<Task> tasks = new List<Task>();
            if (selectedJobId != null)
            {
                foreach (var currentJobId in selectedJobId)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        documentDataList.Add(GetPriceCodeReportDataByJobId(currentJobId));
                    }));
                }
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



        public DocumentData GetPriceCodeReportDataByJobId(long jobId)
        {
            DocumentData documentData = null;
            DataTable tblResultNav = GetJobPriceReportDataTableFromNav(jobId);
            DataTable tblResultLocal = _attachmentCommands.GetJobPriceReportDataTable(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
            if (tblResultLocal != null && tblResultNav != null && tblResultLocal.Rows.Count == tblResultNav.Rows.Count)
            {
                for (int i = 0; i < tblResultNav.Rows.Count; i++)
                {
                    if (tblResultLocal.Rows[i]["Job ID"] == tblResultNav.Rows[i]["Job ID"])
                    {
                        tblResultLocal.Rows[i]["Title"] = tblResultNav.Rows[i]["Description"];
                        tblResultLocal.Rows[i]["Charge Code"] = tblResultNav.Rows[i]["No"];
                        tblResultLocal.Rows[i]["Rate"] = tblResultNav.Rows[i]["Line Amount"];
                    }
                }
            }
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


        private List<PurchaseLinePriceCode> GetJobPriceReportDataFromNav(long jobId)
        {

            string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
            string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
            string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
            PurchaseLinePriceCodeResponse navPurchaseLinePriceCode = null;
            try
            {
                string serviceCall = string.Format("{0}('{1}')/PurchaseLine?$filter=M4PL_Job_ID eq '{2}'", navAPIUrl, "Meridian", jobId);
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
                            navPurchaseLinePriceCode = Newtonsoft.Json.JsonConvert.DeserializeObject<PurchaseLinePriceCodeResponse>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
            }

            return (navPurchaseLinePriceCode?.PurchaseLinePriceCodeList?.Count > 0) ?
                    navPurchaseLinePriceCode.PurchaseLinePriceCodeList :
                    new List<PurchaseLinePriceCode>();
        }

        public DataTable GetJobPriceReportDataTableFromNav(long jobId)
        {
            List<PurchaseLinePriceCode> navPriceCodeList = GetJobPriceReportDataFromNav(jobId);
            using (var priceCodeUTT = new DataTable("PurchaseLinePriceCode"))
            {
                priceCodeUTT.Locale = CultureInfo.InvariantCulture;
                priceCodeUTT.Columns.Add("Job ID");
                priceCodeUTT.Columns.Add("Description");
                priceCodeUTT.Columns.Add("No");
                priceCodeUTT.Columns.Add("Line Amount");
                foreach (var priceCode in navPriceCodeList)
                {
                    var row = priceCodeUTT.NewRow();
                    row["Job Id"] = priceCode.M4PL_Job_ID;
                    row["Description"] = priceCode.Description;
                    row["No"] = priceCode.No;
                    row["Line Amount"] = priceCode.Line_Amount;
                    priceCodeUTT.Rows.Add(row);
                    priceCodeUTT.AcceptChanges();
                }
                return priceCodeUTT;
            }
        }
        private string QuoteValue(string value)
        {
            return String.Concat("\"",
            value.Replace("\"", "\"\""), "\"");
        }
        public DocumentStatus IsPriceCodeDataPresentForJobInNAV(string jobId)
        {
            string[] selectedJobId = !string.IsNullOrEmpty(jobId) ? jobId.Split(',').ToArray() : null;
            DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
            string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
            string filter = "";
            if (selectedJobId.Length > 1)
            {
                for (int i = 0; i < selectedJobId.Length; i++)
                {
                    if (i == 0)
                    {
                        filter += "M4PL_Job_ID eq '" + selectedJobId[i] + "'";
                        continue;
                    }
                    filter += " or M4PL_Job_ID eq '" + selectedJobId[i] + "'";
                }
            }
            else
            {
                filter = "M4PL_Job_ID eq '" + selectedJobId[0] + "'";
            }
            string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
            string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
            PurchaseLinePriceCodeResponse navPriceCodeResponse = null;
            try
            {
                string serviceCall = string.Format("{0}('{1}')/PurchaseLine?$filter={2}", navAPIUrl, "Meridian", filter);
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
                            navPriceCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<PurchaseLinePriceCodeResponse>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
            }
            if (navPriceCodeResponse != null && navPriceCodeResponse.PurchaseLinePriceCodeList.Count != 0)
            {
                documentStatus.IsAttachmentPresent = true;
            }
            return documentStatus;
        }

    }

}

