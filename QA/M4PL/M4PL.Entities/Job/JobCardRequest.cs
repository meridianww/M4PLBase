﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	public class JobCardRequest
	{
		public long Count { get; set; }
		public string CardName { get; set; }

		public string CardType { get; set; }
		public string BackGroundColor { get; set; }
		public long DashboardCategoryRelationId { get; set; }
		public long? CustomerId { get; set; }
		public string DashboardCategoryName { get; set; }
		public string DashboardSubCategoryName { get; set; }
	}
}