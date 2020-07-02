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
using System.ComponentModel;

namespace M4PL.Entities.Job
{
	public class JobVOCReportRequest // : Support.MvcRoute
	{
		public List<string> Location { get; set; }

		[DisplayName("Start Date")]
		public DateTime? StartDate { get; set; }

		[DisplayName("End Date")]
		public DateTime? EndDate { get; set; }

		public long? CompanyId { get; set; }
		public bool IsPBSReport { get; set; }
	}
}