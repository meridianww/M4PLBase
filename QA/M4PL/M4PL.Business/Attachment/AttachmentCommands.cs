/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              11/11/2017
Program Name:                                 AttachmentCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DataAccess.Attachment.AttachmentCommands;
===================================================================================================================*/

using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Attachment.AttachmentCommands;
using M4PL.Entities.Document;
using M4PL.DataAccess.SQLSerializer.Serializer;
using System.IO;
using M4PL.Utilities;
using System.Text;
using System.Data;
using System.Collections;
using System.Linq;

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

        public List<Entities.Attachment> GetAttachmentsByJobId(long jobId)
        {
            return _commands.GetAttachmentsByJobId(ActiveUser, jobId); 
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
				StringBuilder sb = new StringBuilder();
				using (StreamReader reader = new StreamReader(stream))
				{
					string line = string.Empty;
					while ((line = reader.ReadLine()) != null)
					{
						sb.Append(line);
					}
				}

				documentData.DocumentHtml = sb.ToString();
				documentData.DocumentName = string.Format("{0}.pdf", jobId);
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
				StringBuilder sb = new StringBuilder();
				using (StreamReader reader = new StreamReader(stream))
				{
					string line = string.Empty;
					while ((line = reader.ReadLine()) != null)
					{
						sb.Append(line);
					}
				}

				documentData.DocumentHtml = sb.ToString();
				documentData.DocumentName = string.Format("{0}.pdf", jobId);
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
					documentData.DocumentName = string.Format("{0}.csv", jobId);
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
					documentData.DocumentName = string.Format("{0}.csv", jobId);
				}
			}

			return documentData;
		}

		public DocumentStatus IsPriceCodeDataPresentForJob(long jobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			var priceCodeData = _commands.GetJobPriceReportData(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
			if (priceCodeData != null && priceCodeData.Count > 0)
			{
				documentStatus.IsAttachmentPresent = true;
			}

			return documentStatus;
		}

		public DocumentStatus IsCostCodeDataPresentForJob(long jobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent = false };
			var costCodeData = _commands.GetJobCostReportData(ActiveUser, M4PBusinessContext.ComponentSettings.ElectroluxCustomerId, jobId);
			if (costCodeData != null && costCodeData.Count > 0)
			{
				documentStatus.IsAttachmentPresent = true;
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
					documentData.DocumentName = string.Format("{0}.pdf", jobId);
				}
			}

			return documentData;
		}

		public DocumentStatus GetDocumentStatusByJobId(long jobId)
		{
			DocumentStatus documentStatus = new DocumentStatus() { IsAttachmentPresent = false, IsPODPresent= false };
			List<Entities.Attachment> attachments = _commands.GetAttachmentsByJobId(ActiveUser, jobId);
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
	}
}