#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 SystemPageTabName
// Purpose:                                      Contains objects related to SystemPageTabName
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// Entities for SystemPageTabName will contain objects related to SystemPageTabName
	/// </summary>
	public class SystemPageTabName : BaseModel
	{
		/// <summary>
		/// Gets or sets the parent table name.
		/// </summary>
		/// <value>
		/// The  parent table name.
		/// </value>
		public string RefTableName { get; set; }

		/// <summary>
		/// Gets or sets the table sorting order.
		/// </summary>
		/// <value>
		/// The TabSortOrder.
		/// </value>
		public int? TabSortOrder { get; set; }

		/// <summary>
		/// Gets or sets the referenced table controller.
		/// </summary>
		/// <value>
		/// The tab controller.
		/// </value>
		public string TabTableName { get; set; }

		/// <summary>
		/// Gets or sets the referenced language name.
		/// </summary>
		/// <value>
		/// The RefTabName.
		/// </value>
		public string TabPageTitle { get; set; }

		/// <summary>
		/// Gets or sets the page URL.
		/// </summary>
		/// <value>
		/// The TabPageUrl.
		/// </value>
		public string TabExecuteProgram { get; set; }

		/// <summary>
		/// Gets or sets the page icon.
		/// </summary>
		/// <value>
		/// The TabPageIcon.
		/// </value>
		public byte[] TabPageIcon { get; set; }
	}
}