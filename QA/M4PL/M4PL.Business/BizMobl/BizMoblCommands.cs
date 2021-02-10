#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities;
using M4PL.Entities.BizMobl;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.Business.BizMobl
{
	public class BizMoblCommands : BaseCommands<BizMoblModel>, IBizMoblCommands
	{
		public StatusModel GenerateCSVByFileName(string fileName)
		{
			string fileExtension = Path.GetExtension(fileName);
			fileName = string.IsNullOrEmpty(fileExtension) ? fileName + ".csv" : fileName;
			fileExtension = string.IsNullOrEmpty(fileExtension) ? ".csv" : fileExtension;
			string directoryPath = ConfigurationManager.AppSettings["BizMoblFileDirectory"];
			if (!fileExtension.Equals(".csv", StringComparison.OrdinalIgnoreCase))
			{
				return new StatusModel() { AdditionalDetail = "File passed as input should be in csv Format.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
			}
			else if (string.IsNullOrEmpty(directoryPath))
			{
				return new StatusModel() { AdditionalDetail = "BizMoblFileDirectory key is missing in config.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
			}
			else if (!File.Exists(directoryPath + @"\" + fileName))
			{
				return new StatusModel() { AdditionalDetail = "There is no file present in the folder with the passed filename.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
			}

			string filePath = directoryPath + @"\" + fileName;
			DataTable tblcsvData = GetDataTableFromCsv(filePath, false);
			if (tblcsvData != null && tblcsvData.Rows != null && tblcsvData.Rows.Count > 0)
			{
				StringBuilder sb = new StringBuilder();
				foreach (DataRow row in tblcsvData.Rows)
				{
					IEnumerable<string> fields = row.ItemArray.Select(field => field.ToString());
					sb.AppendLine(string.Join(",", fields));
				}

				File.WriteAllText(directoryPath + @"\" + Path.GetFileNameWithoutExtension(fileName) + "_AsTrans.csv", sb.ToString());
			}
			else
			{
				return new StatusModel() { AdditionalDetail = "There is no data present in file for processing.", Status = "Failure", StatusCode = (int)HttpStatusCode.InternalServerError };
			}

			return new StatusModel() { Status = "Success", StatusCode = 200 };
		}

		public StatusModel UploadBizMoblCSVData(BizMoblCSVData bizMoblCSVData)
		{
			string inputString = bizMoblCSVData == null ? "null" : JsonConvert.SerializeObject(bizMoblCSVData);
			_logger.Log(new Exception(), string.Format("Input Request recieved from bizMoblCSVData is: {0}", inputString), "UploadBizMoblCSVData", Utilities.Logger.LogType.Informational);
			if (bizMoblCSVData == null)
            {
                return new StatusModel() { AdditionalDetail = "Request model can not be null.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
            }
            else if (bizMoblCSVData?.FileContent == null)
            {
                return new StatusModel() { AdditionalDetail = "File content can not be null.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
            }
            else if (string.IsNullOrEmpty(bizMoblCSVData?.DeviceId))
            {
                return new StatusModel() { AdditionalDetail = "DeviceId can not be null or empty.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
            }
            
            try
			{
				string directoryPath = ConfigurationManager.AppSettings["BizMoblFileDirectory"];
				if (string.IsNullOrEmpty(directoryPath))
				{
					_logger.Log(new Exception(), "BizMoblFileDirectory key is missing in config", "UploadBizMoblCSVData", Utilities.Logger.LogType.Informational);
					return new StatusModel() { AdditionalDetail = "BizMoblFileDirectory key is missing in config.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
				}

				string filePath = string.Format(@"{0}\{1}_AsTrans.csv", directoryPath, bizMoblCSVData.DeviceId);
				string trgFilePath = string.Format(@"{0}\{1}.trg", directoryPath, bizMoblCSVData.DeviceId);
				if (File.Exists(filePath))
				{
					File.Delete(filePath);
				}

				using (File.Create(filePath)) { }
				File.WriteAllBytes(filePath, bizMoblCSVData.FileContent);

				if (File.Exists(trgFilePath))
				{
					File.Delete(trgFilePath);
				}

				using (File.Create(trgFilePath)) { }

				return new StatusModel() { Status = "Success", StatusCode = 200 };
			}
			catch (Exception exp)
			{
				_logger.Log(exp, "There is some issue while uploading CSV file for BizMobl.", "UploadBizMoblCSVData", Utilities.Logger.LogType.Error);
				return new StatusModel() { StatusCode = 500, Status = "Failure", AdditionalDetail = exp.Message };
			}
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public BizMoblModel Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<BizMoblModel> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public BizMoblModel Patch(BizMoblModel entity)
		{
			throw new NotImplementedException();
		}

		public BizMoblModel Post(BizMoblModel entity)
		{
			throw new NotImplementedException();
		}

		public BizMoblModel Put(BizMoblModel entity)
		{
			throw new NotImplementedException();
		}

		public DataTable GetDataTableFromCsv(string path, bool isFirstRowHeader)
		{
			List<BizMoblModel> bizMoblDocumentList = new List<BizMoblModel>();
			string header = isFirstRowHeader ? "Yes" : "No";

			string pathOnly = Path.GetDirectoryName(path);
			string fileName = Path.GetFileName(path);
			bool idDriver32Bit = ConfigurationManager.AppSettings["Is32BitOLEDBDriver"] != null ? Convert.ToBoolean(ConfigurationManager.AppSettings["Is32BitOLEDBDriver"]) : false;
			string sql = @"SELECT * FROM [" + fileName + "]";
			string connString = idDriver32Bit ? @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + pathOnly +
					  ";Extended Properties=\"Text;HDR=" + header + "\"" :
					  @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + pathOnly +
					  ";Extended Properties=\"Text;HDR=" + header + "\"";
			using (OleDbConnection connection = new OleDbConnection(connString))
			using (OleDbCommand command = new OleDbCommand(sql, connection))
			{
				using (OleDbDataAdapter adapter = new OleDbDataAdapter(command))
				{
					using (DataTable dataTable = new DataTable())
					{
						dataTable.Locale = System.Globalization.CultureInfo.CurrentCulture;
						adapter.Fill(dataTable);
						if (dataTable != null && dataTable.Rows != null && dataTable.Rows.Count > 0)
						{
							List<string> list = dataTable.Rows.OfType<DataRow>().Select(dr => (string)dr["F1"]).ToList();
							if (list != null && list.Count > 0)
							{
								list.ForEach(item => bizMoblDocumentList.Add(new BizMoblModel() { ParsedData = item.Split('|').ToList() }));
							}
						}
					}
				}
			}

			return bizMoblDocumentList?.Count > 0 ? CreateDataTable(bizMoblDocumentList) : null;
		}

		private DataTable CreateDataTable(IList<BizMoblModel> bizMoblDocumentList)
		{
			int countColumn = 0;
			using (DataTable dataTable = new DataTable())
			{
				bizMoblDocumentList.ToList().ForEach(x => { if (x.ParsedData != null && countColumn < x.ParsedData.Count) { countColumn = x.ParsedData.Count; } });
				for (int i = 0; i < countColumn; i++)
				{
					dataTable.Columns.Add(new DataColumn());
				}

				foreach (var entity in bizMoblDocumentList)
				{
					object[] values = new object[entity.ParsedData.Count];
					for (int i = 0; i < entity.ParsedData.Count; i++)
					{
						values[i] = entity.ParsedData[i];
					}

					dataTable.Rows.Add(values);
				}

				return dataTable;
			}
		}
	}
}