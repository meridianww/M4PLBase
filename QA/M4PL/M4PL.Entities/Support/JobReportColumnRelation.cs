#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Support
{
	/// <summary>
	/// Medl class for Job Report Column Relation
	/// </summary>
	public class JobReportColumnRelation
	{
		/// <summary>
		/// Gets or Sets Id of Report
		/// </summary>
		public int ReportType { get; set; }
		/// <summary>
		/// Gets or Sets Id from Re options of the Column
		/// </summary>
		public long ColumnId { get; set; }
	}
}
