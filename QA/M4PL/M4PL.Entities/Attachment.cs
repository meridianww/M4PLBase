#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 Attachment
// Purpose:                                      Contains objects related to Attachment
//==========================================================================================================
using System;

namespace M4PL.Entities
{
	/// <summary>
	/// Model class of application Attachment
	/// </summary>
	public class Attachment : BaseModel
	{
		/// <summary>
		/// Get or Set for Attachment table name
		/// </summary>
		public string AttTableName { get; set; }

		/// <summary>
		/// Get or Set for Attachment Primary record Id
		/// </summary>
		public long? AttPrimaryRecordID { get; set; }
		/// <summary>
		/// Get or Set for Attachment item number
		/// </summary>
		public int? AttItemNumber { get; set; }
		/// <summary>
		/// Get or Set for Attachment title
		/// </summary>
		public string AttTitle { get; set; }
		/// <summary>
		/// Get or Set for Attachment type Id
		/// </summary>
		public int AttTypeId { get; set; }
		/// <summary>
		/// Get or Set for Attachment file name
		/// </summary>
		public string AttFileName { get; set; }
		/// <summary>
		/// Get or Set for Attachment data
		/// </summary>
		public byte[] AttData { get; set; }
		/// <summary>
		/// Get or Set for Attachment download date
		/// </summary>
		public DateTime? AttDownloadedDate { get; set; }
		/// <summary>
		/// Get or Set for Attachment table downloaded by
		/// </summary>
		public string AttDownloadedBy { get; set; }

		/// <summary>
		/// To update the Parent tables attachment count update
		/// </summary>
		public string PrimaryTableFieldName { get; set; }
		/// <summary>
		/// Get or Set for Attachment table document type to upload/download
		/// </summary>
		public string DocumentType { get; set; }
	}
}