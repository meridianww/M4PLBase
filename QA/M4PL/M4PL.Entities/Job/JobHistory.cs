#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job History
	/// </summary>
	public class JobHistory : SysRefModel
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
		/// Gets or Sets updated/new value
		/// </summary>
		public string NewValue { get; set; }
		/// <summary>
		/// Gets or Sets Changed Date
		/// </summary>
		public DateTime ChangedDate { get; set; }
		/// <summary>
		/// Gets or Sets Changed By User Name
		/// </summary>
		public string ChangedBy { get; set; }
		/// <summary>
		/// Gets or Sets Job Id
		/// </summary>
		public long JobID { get; set; }
	}
}