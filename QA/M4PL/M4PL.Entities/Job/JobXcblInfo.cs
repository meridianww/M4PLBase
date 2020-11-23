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
	public class JobXcblInfo : BaseModel
	{
		/// <summary>
		/// Gets or Sets JobId
		/// </summary>
		public long JobId { get; set; }

		/// <summary>
		/// Gets or Sets CustomerSalesOrderNumber
		/// </summary>
		public string CustomerSalesOrderNumber { get; set; }

		/// <summary>
		/// ColumnMappingData
		/// </summary>
		public List<ColumnMappingData> ColumnMappingData { get; set; }

		/// <summary>
		/// IsAccepted
		/// </summary>
		public bool IsAccepted { get; set; }
		/// <summary>
		/// Gets or Sets Job Gateway ID
		/// </summary>
		public long JobGatewayId { get; set; }
	}

	/// <summary>
	/// ColumnMappingData mapping class
	/// </summary>
	public class ColumnMappingData
	{
		/// <summary>
		/// Gets or Sets ColumnName
		/// </summary>
		public string ColumnName { get; set; }

		/// <summary>
		/// Gets or Sets Column Alias for Column Name
		/// </summary>
        public string ColumnAlias { get; set; }

        /// <summary>
        /// Gets or Sets Existing value from Job Table
        /// </summary>
        public string ExistingValue { get; set; }

		/// <summary>
		/// Gets or Sets Existing value from xCBL Table
		/// </summary>
		public string UpdatedValue { get; set; }
	}
}