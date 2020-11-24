#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Attachments
	/// </summary>
	public class JobAttachment
	{
		/// <summary>
		/// Gets or Sets Attachment Name
		/// </summary>
		public string FileName { get; set; }
		/// <summary>
		/// Gets or Sets File Type
		/// </summary>
		public string FileType { get; set; }
		/// <summary>
		/// Gets or Sets File Content in Varbinary format
		/// </summary>
		public byte[] FileContent { get; set; }
	}
}