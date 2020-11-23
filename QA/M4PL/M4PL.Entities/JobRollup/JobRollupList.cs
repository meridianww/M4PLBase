#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.JobRollup
{
	/// <summary>
	/// Model class for Job Roll uo List
	/// </summary>
	public class JobRollupList
	{
		/// <summary>
		/// Gets or Sets Field value
		/// </summary>
		public string FieldValue { get; set; }
		/// <summary>
		/// Gets or Sets JobId
		/// </summary>
		public List<long> JobId { get; set; }
	}
}