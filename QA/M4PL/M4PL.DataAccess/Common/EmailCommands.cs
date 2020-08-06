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
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System;

namespace M4PL.DataAccess.Common
{
	public static class EmailCommands
	{
		public static bool InsertEmailDetail(EmailDetail emaildetail)
		{
			Parameter[] parameters = new Parameter[]
			{
				new Parameter("@FromAddress", emaildetail.FromAddress),
				new Parameter("@ToAddress", emaildetail.ToAddress),
				new Parameter("@CCAddress", emaildetail.CCAddress),
				new Parameter("@Subject", emaildetail.Subject != null ? emaildetail.Subject : string.Empty),
				new Parameter("@IsBodyHtml", emaildetail.IsBodyHtml),
				new Parameter("@Body", ReplaceNonAsciiCharacters(emaildetail.Body != null ? emaildetail.Body : string.Empty)),
				new Parameter("@EmailAttachment", GetEmailAttachmentsTable(emaildetail.Attachments), "dbo.uttEmailAttachment")
			};

			SqlSerializer.Default.Execute(StoredProceduresConstant.InsertEmailDetail, parameters, true);

			return true;
		}

		public static bool UpdateEmailStatus(int id, short emailStatus, short retryAttampts)
		{
			Parameter[] parameters = new Parameter[]
			{
				new Parameter("@id", id),
				new Parameter("@emailStatus", emailStatus),
				new Parameter("@retryAttampts", retryAttampts),
			};

			SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateEmailStatus, parameters, true);

			return true;
		}

		public static SMTPEmailDetail GetSMTPEmailDetail(int emailCount, int toHours, int fromHours)
		{
			SMTPEmailDetail smtpEmailDetail = null;
			SetCollection sets = new SetCollection();
			Parameter[] parameters = new Parameter[]
			{
				new Parameter("@emailCount", emailCount),
				new Parameter("@ToHours", toHours),
				new Parameter("@FromHours", fromHours)
			};

			sets.AddSet<EmailDetail>("EmailDetail");
			sets.AddSet<SMTPServerDetail>("SMTPServerDetail");
			sets.AddSet<EmailAttachment>("EmailAttachment");
			SqlSerializer.Default.DeserializeMultiSets(sets, StoredProceduresConstant.GetEmailDetail, parameters, storedProcedure: true);
			var emailDetail = sets.GetSet<EmailDetail>("EmailDetail");
			var smtpServerDetail = sets.GetSet<SMTPServerDetail>("SMTPServerDetail");
			var emailAttachment = sets.GetSet<EmailAttachment>("EmailAttachment");
			if (emailDetail != null && emailDetail.Count > 0)
			{
				smtpEmailDetail = new SMTPEmailDetail();
				smtpEmailDetail.EmailDetail = emailDetail;
				if (emailAttachment != null && emailAttachment.Count > 0)
				{
					foreach (var currentEmailDetail in smtpEmailDetail.EmailDetail)
					{
						currentEmailDetail.Attachments = emailAttachment.Where(x => x.EmailDetailID == currentEmailDetail.Id).Any() ?
							emailAttachment.Where(x => x.EmailDetailID == currentEmailDetail.Id).ToList() : null;
					}
				}

				smtpEmailDetail.SMTPServerDetail = smtpServerDetail != null && smtpServerDetail.Count > 0 ? smtpServerDetail : null;
			}

			return smtpEmailDetail;
		}

		private static string ReplaceNonAsciiCharacters(string sourceString)
		{
			return System.Text.RegularExpressions.Regex.Replace(sourceString, @"[^\u0000-\u007F]", "&nbsp;");
		}

		private static DataTable GetEmailAttachmentsTable(List<EmailAttachment> emailAttachmentList)
		{
			using (DataTable returnTable = new DataTable())
			{
				returnTable.Locale = System.Globalization.CultureInfo.CurrentCulture;

				returnTable.Columns.Add("AttachmentName", typeof(string));
				returnTable.Columns.Add("Attachment", System.Type.GetType("System.Byte[]"));

				if (emailAttachmentList != null)
				{
					foreach (EmailAttachment emailAttachment in emailAttachmentList)
					{
						object[] currentRow = new object[2];

						currentRow[0] = emailAttachment.AttachmentName;
						currentRow[1] = emailAttachment.AttachmentData;

						returnTable.Rows.Add(currentRow);
					}
				}

				return returnTable;
			}
		}
	}
}