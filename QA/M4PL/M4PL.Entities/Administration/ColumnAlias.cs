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
// Program Name:                                 ColumnAlias
// Purpose:                                      Contains objects related to ColumnAlias
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	///  Column Alias will contain objects related to table's column alias names in the screen
	/// </summary>
	public class ColumnAlias : SysRefModel
	{
		/// <summary>
		/// Gets or sets the selected table name.
		/// </summary>
		/// <value>
		/// The Column Table Name.
		/// </value>
		public string ColTableName { get; set; }

		/// <summary>
		/// Gets or sets the column name for the selected table.
		/// </summary>
		/// <value>
		/// The Column Table Name.
		/// </value>
		public string ColColumnName { get; set; }

		/// <summary>
		/// Gets or sets the alias name of the respective column.
		/// </summary>
		/// <value>
		/// The Column Alias Name.
		/// </value>
		public string ColAliasName { get; set; }

		/// <summary>
		/// Gets or sets the column look up name.
		/// </summary>
		/// <value>
		/// The Column Look Up Name.
		/// </value>
		public int? ColLookupId { get; set; }

		public string ColLookupCode { get; set; }

		/// <summary>
		/// Gets or sets the column caption.
		/// </summary>
		/// <value>
		/// The Column Caption.
		/// </value>
		public string ColCaption { get; set; }

		/// <summary>
		/// Gets or sets the column's description .
		/// </summary>
		/// <value>
		/// The Column Description.
		/// </value>
		public string ColDescription { get; set; }

		/// <summary>
		/// Gets or sets the column's sorting order.
		/// </summary>
		/// <value>
		/// The Column SortOrder.
		/// </value>
		public int ColSortOrder { get; set; }

		/// <summary>
		/// Gets or sets the column's should be readonly or editable.
		/// </summary>
		/// <value>
		/// The Column IsReadOnly.
		/// </value>
		public bool ColIsReadOnly { get; set; }

		/// <summary>
		/// Gets or sets the column visibility.
		/// </summary>
		/// <value>
		/// The ColIsVisible.
		/// </value>
		public bool ColIsVisible { get; set; }

		/// <summary>
		/// Gets or sets the column as default.
		/// </summary>
		/// <value>
		/// The Column Default.
		/// </value>
		public bool ColIsDefault { get; set; }

		/// <summary>
		/// Gets or sets the column's status.
		/// </summary>
		/// <value>
		/// The Column Status.
		/// </value>
		public int? StatusId { get; set; }

		/// <summary>
		/// Gets or sets the column's datatype on dropdown.
		/// </summary>
		public string DataType { get; set; }

		/// <summary>
		///
		/// </summary>
		public int MaxLength { get; set; }

		/// <summary>
		///
		/// </summary>
		public string ColDisplayFormat { get; set; }

		public bool ColAllowNegativeValue { get; set; }

		public bool IsGridColumn { get; set; }

		public string ColGridAliasName { get; set; }
	}
}