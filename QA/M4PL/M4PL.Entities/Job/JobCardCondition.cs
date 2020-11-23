#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Card Condition
	/// </summary>
	public class JobCardCondition
	{
		/// <summary>
		/// Gets or Sets Company Id
		/// </summary>
		public long CompanyId { get; set; }
		/// <summary>
		/// Gets or Sets Where Condition
		/// </summary>
		public string WhereCondition { get; set; }
	}
}