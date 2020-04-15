using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobXcblInfo
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
		/// Gets or Sets ColumnName
		/// </summary>
		public string ColumnName { get; set; }

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
