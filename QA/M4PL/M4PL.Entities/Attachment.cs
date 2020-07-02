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
	public class Attachment : BaseModel
	{
		public string AttTableName { get; set; }
		public long? AttPrimaryRecordID { get; set; }
		public int? AttItemNumber { get; set; }
		public string AttTitle { get; set; }
		public int AttTypeId { get; set; }
		public string AttFileName { get; set; }
		public byte[] AttData { get; set; }
		public DateTime? AttDownloadedDate { get; set; }
		public string AttDownloadedBy { get; set; }

		/// <summary>
		/// To update the Parent tables attachment count update
		/// </summary>
		public string PrimaryTableFieldName { get; set; }

		public string DocumentType { get; set; }
	}
}