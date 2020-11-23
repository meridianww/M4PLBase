#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Document
{
	/// <summary>
	/// Model class for Document Status
	/// </summary>
	public class DocumentStatus
	{
		/// <summary>
		/// Gets or Sets Flag for if an Attachment is Present
		/// </summary>
		public bool IsAttachmentPresent { get; set; }
		/// <summary>
		/// Gets or Sets Flag if POD present
		/// </summary>
		public bool IsPODPresent { get; set; }
		/// <summary>
		/// Gets or Sets Flag if the Histiry Present
		/// </summary>
		public bool IsHistoryPresent { get; set; }
	}
}