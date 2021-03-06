﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.JobRollup
{
	public class RollupList
	{
		public long JobId { get; set; }
		public string ColumnValue { get; set; }
		public bool IsCompleted { get; set; }
	}
}