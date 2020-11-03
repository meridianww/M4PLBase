#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;

namespace M4PL.Business.Event
{
	public class EventBodyHelper
	{
		public static void CreateEventMailNotificationForCargoException(int eventId, long parentId, string contractNumber, string body)
		{
			var emailData = DataAccess.Event.EventCommands.GetEventEmailDetail(eventId, parentId);
			if (emailData != null)
			{
				EmailDetail emailDetail = new EmailDetail()
				{
					FromAddress = emailData.FromMail,
					Body = string.IsNullOrEmpty(body) ? emailData.Body : body,
					CCAddress = emailData.CcAddress,
					EmailPriority = 1,
					IsBodyHtml = true,
					Subject = string.Format(emailData.Subject, contractNumber),
					ToAddress = emailData.ToAddress
				};

				if (emailDetail != null && !string.IsNullOrEmpty(emailDetail.ToAddress))
				{
					DataAccess.Common.EmailCommands.InsertEmailDetail(emailDetail);
				}
				else
				{
					DataAccess.Logger.ErrorLogger.Log(new Exception(), "To Email address can not be empty to sent event Notification.", "CreateEventMailNotificationForCargoException", Utilities.Logger.LogType.Informational);
				}
			}
		}

		public static void CreateEventMailNotification(int eventId, long parentId, string subjectParams, string body)
		{
			var emailData = DataAccess.Event.EventCommands.GetEventEmailDetail(eventId, parentId);
			if (emailData != null)
			{
				EmailDetail emailDetail = new EmailDetail()
				{
					FromAddress = emailData.FromMail,
					Body = string.IsNullOrEmpty(body) ? emailData.Body : body,
					CCAddress = emailData.CcAddress,
					EmailPriority = 1,
					IsBodyHtml = true,
					Subject = string.Format(emailData.Subject, subjectParams),
					ToAddress = emailData.ToAddress
				};

				if (emailDetail != null && !string.IsNullOrEmpty(emailDetail.ToAddress))
				{
					DataAccess.Common.EmailCommands.InsertEmailDetail(emailDetail);
				}
				else
				{
					DataAccess.Logger.ErrorLogger.Log(new Exception(), "To Email address can not be empty to sent event Notification.", "CreateEventMailNotification", Utilities.Logger.LogType.Informational);
				}
			}
		}

		public static string GetCargoExceptionMailBody(ActiveUser activeUser, string exceptionCode, long jobId, string contractNo, DateTime createdDate, string comment, string cgoPartNumCode, string cgoitle, string cgoSerialNumber, string currentGateway)
		{
			SetCollection setcollection = new SetCollection();
			Dictionary<string, string> args = new Dictionary<string, string>
			{
				{ "ExceptionCode", exceptionCode },
				{ "JobId", jobId.ToString() },
				{ "ContractNo", contractNo },
				{ "CreatedDate", createdDate.ToString() },
				{ "Username", activeUser.UserName },
				{ "JobURL", string.Format("{0}?jobId={1}", ConfigurationManager.AppSettings["M4PLApplicationURL"], jobId) },
				{ "Comment", string.IsNullOrEmpty(comment) ? string.Empty : comment },
				{ "IsCommentPresent", string.IsNullOrEmpty(comment) ? "0" : "1" },
				{ "IsCargoDetailsPresent", string.IsNullOrEmpty(cgoPartNumCode) && string.IsNullOrEmpty(cgoitle) && string.IsNullOrEmpty(cgoSerialNumber) && string.IsNullOrEmpty(currentGateway)? "0" : "1" },
				{ "CgoPartNumCode", cgoPartNumCode??" " },
				{ "CgoTitle", cgoitle??" " },
				{ "CgoSerialNumber", cgoSerialNumber??" " },
				{ "CurrentGateway", currentGateway??" " },
			};

			Stream stream = GenerateHtmlFile(setcollection, "JobDS", AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\CargoException.xslt", args);
			StringBuilder stringBuilder = new StringBuilder();
			using (StreamReader reader = new StreamReader(stream))
			{
				string line = string.Empty;
				while ((line = reader.ReadLine()) != null)
				{
					stringBuilder.Append(line);
				}
			}

			return stringBuilder.ToString();
		}

		public static string GetJobReactivationMailBody(long JobId, string Date, string Time, string ContactNumber, string JobOriginDateTimePlanned, string JobDeliveryDateTimePlanned)
		{
			SetCollection setcollection = new SetCollection();
			Dictionary<string, string> args = new Dictionary<string, string>
			{
				{ "JobId", JobId.ToString() },
				{ "Date", Date },
				{ "Time", Time},
				{ "ContactNumber", ContactNumber },
				{ "JobURL", string.Format("{0}?jobId={1}", ConfigurationManager.AppSettings["M4PLApplicationURL"], JobId) },
				{ "JobOriginDateTimePlanned", JobOriginDateTimePlanned },
				{ "JobDeliveryDateTimePlanned", JobDeliveryDateTimePlanned },
			};

			Stream stream = GenerateHtmlFile(setcollection, "JobDS", AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\JobReactivation.xslt", args);
			StringBuilder stringBuilder = new StringBuilder();
			using (StreamReader reader = new StreamReader(stream))
			{
				string line = string.Empty;
				while ((line = reader.ReadLine()) != null)
				{
					stringBuilder.Append(line);
				}
			}

			return stringBuilder.ToString();
		}

		public static string GetJobCancellationMailBody(long JobId, string timeDifference, string ContactNumber, string userName)
		{
			SetCollection setcollection = new SetCollection();
			Dictionary<string, string> args = new Dictionary<string, string>
			{
				{ "JobId", JobId.ToString() },
				{ "Username", userName },
				{ "TimeDifference", timeDifference},
				{ "ContactNumber", ContactNumber },
				{ "JobURL", string.Format("{0}?jobId={1}", ConfigurationManager.AppSettings["M4PLApplicationURL"], JobId) },
			};

			Stream stream = GenerateHtmlFile(setcollection, "JobDS", AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\JobCancel.xslt", args);
			StringBuilder stringBuilder = new StringBuilder();
			using (StreamReader reader = new StreamReader(stream))
			{
				string line = string.Empty;
				while ((line = reader.ReadLine()) != null)
				{
					stringBuilder.Append(line);
				}
			}

			return stringBuilder.ToString();
		}

		public static string GetxCBLExceptionMailBody(int scenarioTypeId)
		{
			Stream stream;
			using (DataSet ds = new DataSet())
			{
				ds.Locale = System.Globalization.CultureInfo.InvariantCulture;
				ds.DataSetName = "xCBLExceptionDS";
				DataTable carrierInsauranceInfoData = DataAccess.XCBL.XCBLCommands.GetXcblExceptionInfo(scenarioTypeId);
				ds.Tables.Add(carrierInsauranceInfoData);
				ds.Tables[0].TableName = "ExceptionInfo";
				stream = HtmlGenerator.GenerateHtmlFile(ds, AppDomain.CurrentDomain.SetupInformation.ApplicationBase + @"bin\StyleSheets\xCBLException.xslt", null);
			}

			return GetHtmlData(stream);
		}

		public static void CreateEventMailNotificationForxCBLException(int eventId, string body)
		{
			var emailData = DataAccess.Event.EventCommands.GetEventEmailDetail(eventId, 0);
			if (emailData != null)
			{
				EmailDetail emailDetail = new EmailDetail()
				{
					FromAddress = emailData.FromMail,
					Body = string.IsNullOrEmpty(body) ? emailData.Body : body,
					CCAddress = emailData.CcAddress,
					EmailPriority = 1,
					IsBodyHtml = true,
					Subject = emailData.Subject,
					ToAddress = emailData.ToAddress
				};

				if (emailDetail != null && !string.IsNullOrEmpty(emailDetail.ToAddress))
				{
					DataAccess.Common.EmailCommands.InsertEmailDetail(emailDetail);
				}
				else
				{
					DataAccess.Logger.ErrorLogger.Log(new Exception(), "To Email address can not be empty to sent event Notification.", "CreateEventMailNotificationForCargoException", Utilities.Logger.LogType.Informational);
				}
			}
		}

		private static Stream GenerateHtmlFile(SetCollection data, string rootName, string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
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

		private static string GetHtmlData(Stream stream)
		{
			StringBuilder sb = new StringBuilder();
			using (StreamReader reader = new StreamReader(stream))
			{
				string line = string.Empty;
				while ((line = reader.ReadLine()) != null)
				{
					sb.Append(line);
				}
			}

			return sb.ToString();
		}
	}
}