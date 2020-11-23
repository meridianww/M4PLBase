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
	/// Model class for Job Cost Code Action
	/// </summary>
	public class JobCostCodeAction
	{
		/// <summary>
		/// Gets or Sets Cost Code Id
		/// </summary>
		public long CostCodeId { get; set; }
		/// <summary>
		/// Gets or Sets Cost Code
		/// </summary>
		public string CostCode { get; set; }
		/// <summary>
		/// Gets or Sets Cost Title
		/// </summary>
		public string CostTitle { get; set; }
		/// <summary>
		/// Gets or Sets Ast Action Code
		/// </summary>
		public string CostActionCode { get; set; }
	}
}