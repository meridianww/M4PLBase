#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities
{
	/// <summary>
	/// Model class for Email Attachment
	/// </summary>
	public class EmailAttachment
	{
		/// <summary>
		/// Gets or Sets Id
		/// </summary>
		public int ID { get; set; }
		/// <summary>
		/// Gets or Sets Email Details Id
		/// </summary>
		public int EmailDetailID { get; set; }
		/// <summary>
		/// Gets or Sets Attachment file content in varbinary format
		/// </summary>
		public byte[] AttachmentData { get; set; }
		/// <summary>
		/// Gets or Sets Attachment file name
		/// </summary>
		public string AttachmentName { get; set; }
	}
}