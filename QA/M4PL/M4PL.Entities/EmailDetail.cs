#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities
{
	public class EmailDetail
	{
		public EmailDetail()
		{
			Attachments = new List<EmailAttachment>();
		}

		public int Id { get; set; }
		public string FromAddress { get; set; }
		public string ToAddress { get; set; }
		public string ReplyToAddress { get; set; }
		public string CCAddress { get; set; }
		public string Subject { get; set; }
		public bool IsBodyHtml { get; set; }
		public string Body { get; set; }
		public byte EmailPriority { get; set; }
		public byte RetryAttempt { get; set; }
		public List<EmailAttachment> Attachments { get; set; }
	}
}