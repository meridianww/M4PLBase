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
	/// <summary>
	/// Model class for Email Details
	/// </summary>
	public class EmailDetail
	{
		/// <summary>
		/// Constructor
		/// </summary>
		public EmailDetail()
		{
			Attachments = new List<EmailAttachment>();
		}

		/// <summary>
		/// Gets or Sets Id
		/// </summary>
		public int Id { get; set; }
		/// <summary>
		/// Gets or Sets FromAddress
		/// </summary>
		public string FromAddress { get; set; }
		/// <summary>
		/// Gets or Sets ToAddress
		/// </summary>
		public string ToAddress { get; set; }
		/// <summary>
		/// Gets or Sets ReplyToAddress
		/// </summary>
		public string ReplyToAddress { get; set; }
		/// <summary>
		/// Gets or Sets CCAddress
		/// </summary>
		public string CCAddress { get; set; }
		/// <summary>
		/// Gets or Sets Subject
		/// </summary>
		public string Subject { get; set; }
		/// <summary>
		/// Gets or Sets IsBodyHtml
		/// </summary>
		public bool IsBodyHtml { get; set; }
		/// <summary>
		/// Gets or Sets Body
		/// </summary>
		public string Body { get; set; }
		/// <summary>
		/// Gets or Sets EmailPriority
		/// </summary>
		public byte EmailPriority { get; set; }
		/// <summary>
		/// Gets or Sets RetryAttempt
		/// </summary>
		public byte RetryAttempt { get; set; }
		/// <summary>
		/// Gets or Sets List of Email Attachments
		/// </summary>
		public List<EmailAttachment> Attachments { get; set; }

	}
}