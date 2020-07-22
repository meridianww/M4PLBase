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
// Program Name:                                 MenuDriver
// Purpose:                                      Contains objects related to MenuDriver
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// Menu Driver class alows the user to add menu's and ribbon's
	/// </summary>
	public class MenuDriver : BaseModel
	{
		/// <summary>
		///  Gets or sets the Main ModuleId which had referred.
		/// </summary>
		/// <value>
		/// The MnuModuleId.
		/// </value>
		public int? MnuModuleId { get; set; }

		/// <summary>
		/// Gets or sets the Table which had referred.
		/// </summary>
		/// <value>
		/// The MnuTableName.
		/// </value>
		public string MnuTableName { get; set; }

		/// <summary>
		/// Gets or sets the order of the table which has been referred.
		/// </summary>
		/// <value>
		/// The job MnuBreakDownStructure.
		/// </value>
		public string MnuBreakDownStructure { get; set; }

		/// <summary>
		/// Gets or sets the title for the referenced table.
		/// </summary>
		/// <value>
		/// TheMnuTitle.
		/// </value>
		public string MnuTitle { get; set; }

		/// <summary>
		/// Gets or sets the description for the referenced table.
		/// </summary>
		/// <value>
		/// The MnuDescription.
		/// </value>
		public byte[] MnuDescription { get; set; }

		/// <summary>
		/// Gets or sets the description for the referenced table.
		/// </summary>
		/// <value>
		/// The MnuTabOver.
		/// </value>
		public string MnuTabOver { get; set; }

		/// <summary>
		/// Gets or sets the icon of the menu - very small.
		/// </summary>
		/// <value>
		/// The MnuIconVerySmall.
		/// </value>
		public byte[] MnuIconVerySmall { get; set; }

		/// <summary>
		/// Gets or sets the icon of the menu - small.
		/// </summary>
		/// <value>
		/// The MnuIconSmall.
		/// </value>
		public byte[] MnuIconSmall { get; set; }

		/// <summary>
		/// Gets or sets the icon of the menu - Medium.
		/// </summary>
		/// <value>
		/// The MnuIconMedium.
		/// </value>
		public byte[] MnuIconMedium { get; set; }

		/// <summary>
		/// Gets or sets the icon of the menu - Large.
		/// </summary>
		/// <value>
		/// The MnuIconLarge.
		/// </value>
		public byte[] MnuIconLarge { get; set; }

		/// <summary>
		/// Gets or sets t.
		/// </summary>
		/// <value>
		/// The MnuMenuItem.
		/// </value>
		public bool MnuMenuItem { get; set; }

		/// <summary>
		/// Gets or sets whether the menu has to be created in the ribbon.
		/// </summary>
		/// <value>
		/// The MnuRibbon.
		/// </value>
		public bool MnuRibbon { get; set; }

		/// <summary>
		/// Gets or sets the name of the ribbon menu.
		/// </summary>
		/// <value>
		/// The MnuRibbonTabName.
		/// </value>
		public string MnuRibbonTabName { get; set; }

		public string MnuExecuteProgram { get; set; }

		/// <summary>
		/// Gets or sets the type of the program.
		/// </summary>
		/// <value>
		/// The MnuProgramTypeId.
		/// </value>
		public int? MnuProgramTypeId { get; set; }

		/// <summary>
		/// Gets or sets menu's classification identifier.
		/// </summary>
		/// <value>
		/// The MnuClassificationId identifier.
		/// </value>
		public int? MnuClassificationId { get; set; }

		/// <summary>
		/// Gets or sets menu option level identifier.
		/// </summary>
		/// <value>
		/// The MnuOptionLevel identifier.
		/// </value>
		public int? MnuOptionLevelId { get; set; }

		/// <summary>
		/// Gets or sets menu access level identifier.
		/// </summary>
		/// <value>
		/// The MnuAccessLevel identifier.
		/// </value>
		public int? MnuAccessLevelId { get; set; }

		public byte[] MnuHelpFile { get; set; }

		public string MnuHelpBookMark { get; set; }

		public int MnuHelpPageNumber { get; set; }

		public string RbnBreakdownStructure { get; set; }

		public string ModuleName { get; set; }
	}
}