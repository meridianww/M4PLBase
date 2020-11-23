#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Document Attachment
	/// </summary>
	public class JobDocumentAttachment
	{
		/// <summary>
		/// Gets or Sets Document Code
		/// </summary>
		public string DocumentCode { get; set; }
		/// <summary>
		/// Gets or Sets Document Title
		/// </summary>
		public string DocumentTitle { get; set; }
		/// <summary>
		/// Gets or Sets List of Attachments
		/// </summary>
		public List<AttchmentData> AttchmentData { get; set; }
	}
	/// <summary>
	/// Model class for Attachment file
	/// </summary>
	public class AttchmentData
	{
		/// <summary>
		/// Gets or sets Attached file's Name
		/// </summary>
		public string AttchmentName { get; set; }
		/// <summary>
		/// Gets or Sets Title of attachment
		/// </summary>
		public string AttachmentTitle { get; set; }
		/// <summary>
		/// Gets or Sets Attachment file content in varbinary format
		/// </summary>
		public byte[] AttachmentData { get; set; }
	}
}