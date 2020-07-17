#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Janardana
// Date Programmed:                              11/11/2017
// Program Name:                                 AttachmentCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DataAccess.Attachment.AttachmentCommands;
//====================================================================================================================

using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Document;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Attachment.AttachmentCommands;

namespace M4PL.Business.Attachment
{
	public class AttachmentCommands : BaseCommands<Entities.Attachment>, IAttachmentCommands
	{
		/// <summary>
		/// Get list of contacts data
		/// </summary>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public IList<Entities.Attachment> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			return _commands.GetPagedData(ActiveUser, pagedDataInfo);
		}

		/// <summary>
		/// Gets specific contact record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public Entities.Attachment Get(long id)
		{
			return _commands.Get(ActiveUser, id);
		}

		public DocumentData GetAllAvaliableAttachmentsForJob(List<long> jobId)
		{
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var selectedJob in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					var attachmentList = _commands.GetAttachmentsByJobId(ActiveUser, selectedJob);
					if (attachmentList != null && attachmentList.Count > 0)
					{
						using (MemoryStream ms = new MemoryStream())
						{
							using (var archive = new System.IO.Compression.ZipArchive(ms, ZipArchiveMode.Create, true))
							{
								foreach (var file in attachmentList)
								{
									var entry = archive.CreateEntry(file.AttFileName, CompressionLevel.Fastest);
									using (var zipStream = entry.Open())
									{
										zipStream.Write(file.AttData, 0, file.AttData.Length);
									}
								}
							}

							documentDataList.Add(
								new DocumentData()
								{
									DocumentContent = ms.ToArray(),
									ContentType = "application/zip",
									DocumentName = string.Format("documents_{0}.zip", selectedJob)
								});
						}
					}
				}));
			}

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
			documentDataList = documentDataList.Where(x => x != null).Any() ? documentDataList.Where(x => x != null).ToList() : new List<DocumentData>();
			if (documentDataList != null && documentDataList.Count > 1)
			{
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
					{
						foreach (var jobDocument in documentDataList)
						{
							var entry = archive.CreateEntry(jobDocument.DocumentName, CompressionLevel.Fastest);
							using (var zipStream = entry.Open())
							{
								zipStream.Write(jobDocument.DocumentContent, 0, jobDocument.DocumentContent.Length);
							}
						}
					}

					documentData = new DocumentData();
					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedDocuments");
					documentData.ContentType = "application/zip";
				}
			}
			else if (documentDataList != null && documentDataList.Count == 1)
			{
				return documentDataList[0];
			}

			return documentData;
		}

		public DocumentData GetBOLDocumentByJobId(long jobId)
		{
			DocumentData documentData = null;
			SetCollection setcollection = _commands.GetBOLDocumentByJobId(ActiveUser, jobId);
			if (setcollection != null)
			{
				documentData = new DocumentData();
				Dictionary<string, string> args = new Dictionary<string, string> { { "ImagePath", M4PBusinessContext.ComponentSettings.M4PLApplicationURL + "Content/Images/M4plLogo.png" } };
				Stream stream = GenerateHtmlFile(setcollection, "JobBOLDS", AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\JobBOL.xslt", args);
				StringBuilder stringBuilder = new StringBuilder();
				using (StreamReader reader = new StreamReader(stream))
				{
					string line = string.Empty;
					while ((line = reader.ReadLine()) != null)
					{
						stringBuilder.Append(line);
					}
				}

				if (!string.IsNullOrEmpty(stringBuilder.ToString()))
				{
					using (MemoryStream memorystream = new System.IO.MemoryStream())
					{
						StringReader sr = new StringReader(stringBuilder.ToString());
						Document pdfDoc = new Document();
						PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memorystream);
						pdfDoc.Open();
						XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
						pdfDoc.Close();
						documentData.DocumentContent = memorystream.ToArray();
					}
				}

				documentData.DocumentHtml = stringBuilder.ToString();
				documentData.DocumentName = string.Format("BOL_{0}.pdf", jobId);
				documentData.ContentType = "application/pdf";
			}

			return documentData;
		}

		public DocumentData GetTrackingDocumentByJobId(long jobId)
		{
			DocumentData documentData = null;
			SetCollection setcollection = _commands.GetTrackingDocumentByJobId(ActiveUser, jobId);
			if (setcollection != null)
			{
				documentData = new DocumentData();
				Dictionary<string, string> args = new Dictionary<string, string> { { "ImagePath", M4PBusinessContext.ComponentSettings.M4PLApplicationURL + "Content/Images/M4plLogo.png" } };
				Stream stream = GenerateHtmlFile(setcollection, "JobTrackingDS", AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\JobTracking.xslt", args);
				StringBuilder stringBuilder = new StringBuilder();
				using (StreamReader reader = new StreamReader(stream))
				{
					string line = string.Empty;
					while ((line = reader.ReadLine()) != null)
					{
						stringBuilder.Append(line);
					}
				}

				if (!string.IsNullOrEmpty(stringBuilder.ToString()))
				{
					using (MemoryStream memorystream = new System.IO.MemoryStream())
					{
						StringReader sr = new StringReader(stringBuilder.ToString());
						Document pdfDoc = new Document();
						PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memorystream);
						pdfDoc.Open();
						XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
						pdfDoc.Close();
						documentData.DocumentContent = memorystream.ToArray();
					}
				}

				documentData.DocumentHtml = stringBuilder.ToString();
				documentData.DocumentName = string.Format("Tracking_{0}.pdf", jobId);
				documentData.ContentType = "application/pdf";
			}

			return documentData;
		}

		public DocumentData GetPriceCodeReportDocumentByJobId(long jobId)
		{
			DocumentData documentData = null;
			DataTable tblResult = _commands.GetJobPriceReportDataTable(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
			if (tblResult != null && tblResult.Rows.Count > 0)
			{
				documentData = new DocumentData();
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (StreamWriter writer = new StreamWriter(memoryStream))
					{
						WriteDataTable(tblResult, writer, true);
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("PriceCode_{0}.csv", jobId);
					documentData.ContentType = "text/csv";
				}
			}

			return documentData;
		}

		public DocumentData GetCostCodeReportDocumentByJobId(long jobId)
		{
			DocumentData documentData = null;
			DataTable tblResult = _commands.GetJobCostReportDataTable(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
			if (tblResult != null && tblResult.Rows.Count > 0)
			{
				documentData = new DocumentData();
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (StreamWriter writer = new StreamWriter(memoryStream))
					{
						WriteDataTable(tblResult, writer, true);
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("CostCode_{0}.csv", jobId);
					documentData.ContentType = "text/csv";
				}
			}

			return documentData;
		}

		public DocumentData GetHistoryReportByJobId(long jobId)
		{
			DocumentData documentData = null;
			IList<IdRefLangName> statusLookup = CoreCache.GetIdRefLangNames("EN", 39);
			IList<ColumnSetting> columnSetting = CoreCache.GetColumnSettingsByEntityAlias("EN", Entities.EntitiesAlias.Job);
			DataTable tblResult = _commands.GetJobHistoryDataTable(ActiveUser, jobId, columnSetting, statusLookup);
			if (tblResult != null && tblResult.Rows.Count > 0)
			{
				documentData = new DocumentData();
				using (MemoryStream memoryStream = new MemoryStream())
				{
					using (StreamWriter writer = new StreamWriter(memoryStream))
					{
						WriteDataTable(tblResult, writer, true);
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("JobHistory_{0}.csv", jobId);
					documentData.ContentType = "text/csv";
				}
			}

			return documentData;
		}

		public DocumentStatus IsPriceCodeDataPresentForJob(List<long> selectedJobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			var priceCodeData = _commands.GetMultipleJobPriceReportData(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, selectedJobId);
			if (priceCodeData != null && priceCodeData.Count > 0)
			{
				documentStatus.IsAttachmentPresent = true;
			}

			return documentStatus;
		}

		public DocumentStatus IsCostCodeDataPresentForJob(List<long> selectedJobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			var costCodeData = _commands.GetMultipleJobCostReportData(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, selectedJobId);
			if (costCodeData != null && costCodeData.Count > 0)
			{
				documentStatus.IsAttachmentPresent = true;
			}

			return documentStatus;
		}

		public DocumentStatus IsHistoryPresentForJob(List<long> selectedJobId)
		{
			IList<IdRefLangName> statusLookup = CoreCache.GetIdRefLangNames("EN", 39);
			IList<ColumnSetting> columnSetting = CoreCache.GetColumnSettingsByEntityAlias("EN", Entities.EntitiesAlias.Job);
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false, IsHistoryPresent = false };
			List<Task> tasks = new List<Task>();
			List<IList<JobHistory>> jobHistory = new List<IList<JobHistory>>();
			foreach (var currentJobId in selectedJobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					jobHistory.Add(DataAccess.Job.JobHistoryCommands.GetPagedData(ActiveUser, new PagedDataInfo() { RecordId = currentJobId }, columnSetting, statusLookup));
				}));
			}

			if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
			if (jobHistory?.Count > 0 && jobHistory.Where(x => x?.Count > 0).Any())
			{
				documentStatus.IsHistoryPresent = true;
			}

			return documentStatus;
		}

		public DocumentData GetPODDocumentByJobId(long jobId)
		{
			DocumentData documentData = null;
			List<Entities.Attachment> attachments = _commands.GetAttachmentsByJobId(ActiveUser, jobId);
			if (attachments != null && attachments.Where(x => x.DocumentType.Equals("POD", StringComparison.OrdinalIgnoreCase)).Any())
			{
				documentData = new DocumentData();
				List<byte[]> byteArrayList = null;
				byte[] fileBytes = null;
				var podFileAttachmentList = attachments.Where(x => x.DocumentType.Equals("POD", StringComparison.OrdinalIgnoreCase)).ToList();

				byteArrayList = new List<byte[]>();
				foreach (var fileAttachment in podFileAttachmentList)
				{
					fileBytes = GetFileByteArray(fileAttachment.AttData, fileAttachment.AttFileName);
					if (fileBytes != null) { byteArrayList.Add(fileBytes); }
				}

				if (byteArrayList?.Count > 0)
				{
					documentData.DocumentContent = PdfHelper.CombindMultiplePdf(byteArrayList);
					documentData.DocumentName = string.Format("POD_{0}.pdf", jobId);
					documentData.ContentType = "application/pdf";
				}
			}

			return documentData;
		}

		public DocumentStatus GetDocumentStatusByJobId(List<long> selectedJobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			List<Entities.Attachment> attachments = _commands.GetAttachmentsByMultipleJobId(ActiveUser, selectedJobId);
			if (attachments != null && attachments.Count > 0)
			{
				documentStatus.IsAttachmentPresent = true;
				documentStatus.IsPODPresent = attachments.Where(x => x.DocumentType.Equals("POD", StringComparison.OrdinalIgnoreCase)).Any();
			}

			return documentStatus;
		}

		/// <summary>
		/// Creates a new contact record
		/// </summary>
		/// <param name="contact"></param>
		/// <returns></returns>

		public Entities.Attachment Post(Entities.Attachment contact)
		{
			return _commands.Post(ActiveUser, contact);
		}

		/// <summary>
		/// Updates an existing contact record
		/// </summary>
		/// <param name="contact"></param>
		/// <returns></returns>

		public Entities.Attachment Put(Entities.Attachment contact)
		{
			return _commands.Put(ActiveUser, contact);
		}

		/// <summary>
		/// Deletes a specific contact record based on the userid
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>

		public int Delete(long id)
		{
			return _commands.Delete(ActiveUser, id);
		}

		/// <summary>
		/// Deletes a list of contacts records
		/// </summary>
		/// <param name="ids"></param>
		/// <returns></returns>

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			return _commands.Delete(ActiveUser, ids, statusId);
		}

		public IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName)
		{
			return _commands.DeleteAndUpdateAttachmentCount(ActiveUser, ids, statusId, parentTable, fieldName);
		}

		public Entities.Attachment Patch(Entities.Attachment entity)
		{
			throw new NotImplementedException();
		}

		private Stream GenerateHtmlFile(SetCollection data, string rootName, string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
		{
			if (data == null)
			{
				throw new ArgumentNullException("data");
			}

			using (DataSet ds = new DataSet(rootName))
			{
				ds.Locale = System.Globalization.CultureInfo.InvariantCulture;

				foreach (DictionaryEntry set in data)
				{
					var table = ds.Tables.Add(set.Key.ToString());

					foreach (IDictionary<string, object> item in (IList<dynamic>)set.Value)
					{
						if (table.Columns.Count == 0)
						{
							foreach (var prop in item)
							{
								table.Columns.Add(prop.Key, prop.Value.GetType() == typeof(DBNull) ? typeof(object) : prop.Value.GetType());
							}
						}

						DataRow row = table.NewRow();

						foreach (var prop in item)
						{
							row[prop.Key] = HtmlGenerator.CleanInvalidXmlChars(prop.Value.ToString());
						}

						table.Rows.Add(row);
					}
				}

				return HtmlGenerator.GenerateHtmlFile(ds, xsltFilePath, xsltArgumentsDictionary);
			}
		}

		public static void WriteDataTable(DataTable sourceTable, TextWriter writer, bool includeHeaders)
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

		private static string QuoteValue(string value)
		{
			return String.Concat("\"",
			value.Replace("\"", "\"\""), "\"");
		}

		public byte[] GetFileByteArray(byte[] fileBytes, string fileName)
		{
			string fileExtension = Path.GetExtension(fileName);
			var imageExtensionList = new string[] { ".JPG", ".PNG", ".GIF", ".WEBP", ".TIFF", ".PSD", ".RAW", ".BMP", ".HEIF", ".INDD", ".JPEG" };
			bool isImageType = imageExtensionList.Where(x => x.Equals(fileExtension, StringComparison.OrdinalIgnoreCase)).Any();
			if (isImageType)
			{
				return PdfHelper.ConvertImageToPdf(fileBytes);
			}
			else if (fileExtension.Equals(".pdf", StringComparison.OrdinalIgnoreCase))
			{
				return fileBytes;
			}

			return null;
		}

		public DocumentData GetBOLDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = new DocumentData();
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var currentJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetBOLDocumentByJobId(currentJobId));
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
						foreach (var bolDocument in documentDataList)
						{
							var entry = archive.CreateEntry(bolDocument.DocumentName, CompressionLevel.Fastest);
							using (var zipStream = entry.Open())
							{
								zipStream.Write(bolDocument.DocumentContent, 0, bolDocument.DocumentContent.Length);
							}
						}
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedBOL");
					documentData.ContentType = "application/zip";
				}
			}
			else
			{
				return documentDataList[0];
			}

			return documentData;
		}

		public DocumentData GetTrackingDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = new DocumentData();
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var currentJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetTrackingDocumentByJobId(currentJobId));
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

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedTracking");
					documentData.ContentType = "application/zip";
				}
			}
			else
			{
				return documentDataList[0];
			}

			return documentData;
		}

		public DocumentData GetPriceCodeReportDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var currentJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetPriceCodeReportDocumentByJobId(currentJobId));
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

		public DocumentData GetCostCodeReportDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var currentJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetCostCodeReportDocumentByJobId(currentJobId));
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

		public DocumentData GetHistoryReportDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = null;
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var currentJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetHistoryReportByJobId(currentJobId));
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
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedJobHistory");
					documentData.ContentType = "application/zip";
				}
			}
			else if (documentDataList?.Count == 1)
			{
				return documentDataList[0];
			}

			return documentData;
		}

		public DocumentData GetPODDocumentByJobId(List<long> jobId)
		{
			DocumentData documentData = new DocumentData();
			List<DocumentData> documentDataList = new List<DocumentData>();
			List<Task> tasks = new List<Task>();
			foreach (var selectedJobId in jobId)
			{
				tasks.Add(Task.Factory.StartNew(() =>
				{
					documentDataList.Add(GetPODDocumentByJobId(selectedJobId));
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
						foreach (var podDocument in documentDataList)
						{
							if (podDocument != null && podDocument.DocumentContent != null)
							{
								var entry = archive.CreateEntry(podDocument.DocumentName, CompressionLevel.Fastest);
								using (var zipStream = entry.Open())
								{
									zipStream.Write(podDocument.DocumentContent, 0, podDocument.DocumentContent.Length);
								}
							}
						}
					}

					documentData.DocumentContent = memoryStream.ToArray();
					documentData.DocumentName = string.Format("{0}.zip", "ConsolidatedPOD");
					documentData.ContentType = "application/zip";
				}
			}
			else
			{
				return documentDataList[0];
			}

			return documentData;
		}
	}
}