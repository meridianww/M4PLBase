#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.Entities
{
	/// <summary>
	/// Model class for Job Change history
	/// </summary>
	public class ChangeHistoryData
	{
		/// <summary>
		/// Gets or Sets Field Name e.g. Delivery Date Planned
		/// </summary>
		public string FieldName { get; set; }
		/// <summary>
		/// Gets or Sets Old Value
		/// </summary>
		public string OldValue { get; set; }
		/// <summary>
		/// Gets or Sets New/Updated Value
		/// </summary>
		public string NewValue { get; set; }
		/// <summary>
		/// Gets or Sets Date when the record was updated
		/// </summary>
		public DateTime ChangedDate { get; set; }
		/// <summary>
		/// Gets or Sets Username who has updated the record
		/// </summary>
		public string ChangedBy { get; set; }
	}
}