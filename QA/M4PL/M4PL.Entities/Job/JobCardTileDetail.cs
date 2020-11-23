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
	/// Model class for Job Card Tile Details
	/// </summary>
	public class JobCardTileDetail : BaseModel
	{
		/// <summary>
		/// Gets or Sets DashboardCategoryRelationId
		/// </summary>
		public long DashboardCategoryRelationId { get; set; }
		/// <summary>
		/// Gets or Sets Record Count
		/// </summary>
		public long RecordCount { get; set; }
		/// <summary>
		/// Gets or Sets Dashboard Name
		/// </summary>
		public string DashboardName { get; set; }
		/// <summary>
		/// Gets or Sets Dashboard Category DisplayName e.g. Not Scheduled
		/// </summary>
		public string DashboardCategoryDisplayName { get; set; }
		/// <summary>
		/// Gets or Sets Dashboard SubCategory DisplayName e.g. In Transit
		/// </summary>
		public string DashboardSubCategoryDisplayName { get; set; }
		/// <summary>
		/// Gets or Sets Back GroundColor
		/// </summary>
		public string BackGroundColor { get; set; }
		/// <summary>
		/// Gets or Sets Font Color
		/// </summary>
		public string FontColor { get; set; }
		/// <summary>
		/// Gets or Sets Dashboard CategoryName
		/// </summary>
		public string DashboardCategoryName { get; set; }
		/// <summary>
		/// Gets or Sets Dashboard SubCategory Name
		/// </summary>
		public string DashboardSubCategoryName { get; set; }
		/// <summary>
		/// Gets or Sets Sort Order
		/// </summary>
		public int SortOrder { get; set; }

	}
}