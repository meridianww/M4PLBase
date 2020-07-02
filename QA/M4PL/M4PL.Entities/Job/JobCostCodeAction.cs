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
	public class JobCostCodeAction
	{
		public long CostCodeId { get; set; }
		public string CostCode { get; set; }
		public string CostTitle { get; set; }
		public string CostActionCode { get; set; }
	}
}