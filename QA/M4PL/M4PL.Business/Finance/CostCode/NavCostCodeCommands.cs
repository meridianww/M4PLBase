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
using M4PL.Entities.Finance;
using M4PL.Entities.Finance.CostCode;
using M4PL.Entities.Finance.OrderItem;
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
using _attachmentCommands = M4PL.DataAccess.Attachment.AttachmentCommands;
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
                        documentDataList.Add(GetCostCodeReportDataByJobId(currentJobId));
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


        public DocumentData GetCostCodeReportDataByJobId(long jobId)
        {
            DocumentData documentData = null;
            DataTable tblResultNav = GetJobCostReportDataTableFromNAV(jobId);
            DataTable tblResultLocal = _attachmentCommands.GetJobCostReportDataTable(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
            if (tblResultLocal != null && tblResultNav != null && tblResultLocal.Rows.Count == tblResultNav.Rows.Count)
            {
                for (int i = 0; i < tblResultLocal.Rows.Count; i++)
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

        private List<SalesLineCostCode> GetJobCostReportDataFromNav(long jobId)
        {
            string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
            string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
            string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
            SalesLineCostCodeResponse navSalesLineCostCode = null;
            try
            {
                string serviceCall = string.Format("{0}('{1}')/SalesLine?$filter=M4PL_Job_ID eq '{2}'", navAPIUrl, "Meridian", jobId);
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
                            navSalesLineCostCode = Newtonsoft.Json.JsonConvert.DeserializeObject<SalesLineCostCodeResponse>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
            }

            return (navSalesLineCostCode?.SalesLinePriceCodeList?.Count > 0) ?
                    navSalesLineCostCode.SalesLinePriceCodeList :
                    new List<SalesLineCostCode>();
        }

        public DataTable GetJobCostReportDataTableFromNAV(long jobId)
        {
            List<SalesLineCostCode> navCostCodeList = GetJobCostReportDataFromNav(jobId);
            using (var costCodeUTT = new DataTable("SalesLineCostCode"))
            {
                costCodeUTT.Locale = CultureInfo.InvariantCulture;
                costCodeUTT.Columns.Add("Job ID");
                costCodeUTT.Columns.Add("Description");
                costCodeUTT.Columns.Add("No");
                costCodeUTT.Columns.Add("Line Amount");
                foreach (var costCode in navCostCodeList)
                {
                    var row = costCodeUTT.NewRow();
                    row["Job ID"] = costCode.M4PL_Job_ID;
                    row["Description"] = costCode.Description;
                    row["No"] = costCode.No;
                    row["Line Amount"] = costCode.Line_Amount;
                    costCodeUTT.Rows.Add(row);
                    costCodeUTT.AcceptChanges();
                }
                return costCodeUTT;
            }
        }
        private string QuoteValue(string value)
        {
            return String.Concat("\"",
            value.Replace("\"", "\"\""), "\"");
        }
        public DocumentStatus IsCostCodeDataPresentForJobInNAV(string jobId)
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
            SalesLineCostCodeResponse navCostCodeResponse = null;
            try
            {
                string serviceCall = string.Format("{0}('{1}')/SalesLine?$filter={2}", navAPIUrl, "Meridian", filter);
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
                            navCostCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<SalesLineCostCodeResponse>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
            }

            if (navCostCodeResponse != null && navCostCodeResponse.SalesLinePriceCodeList.Count != 0)
            {
                documentStatus.IsAttachmentPresent = true;
            }
            return documentStatus;


        }
    }
}
