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
// Program Name:                                 SystemMessage
// Purpose:                                      Contains objects related to SystemMessage
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// Entities for SystemMessage will contain objects related to SystemMessage
	/// </summary>
	public class SystemMessage : BaseModel
	{
		/// <summary>
		/// Gets or sets the System message code. e.g. NavVendor
		/// </summary>
		/// <value>
		/// The SysMessageCode.
		/// </value>
		public string SysMessageCode { get; set; }

		/// <summary>
		/// Gets or sets the System message screen's title. e.g. Info
		/// </summary>
		/// <value>
		/// The SysMessageScreenTitle.
		/// </value>
		public string SysMessageScreenTitle { get; set; }

		/// <summary>
		/// Gets or sets the System message's title. e.g. Data Updated
		/// </summary>
		/// <value>
		/// The SysMessageScreenTitle.
		/// </value>
		public string SysMessageTitle { get; set; }

		/// <summary>
		/// Gets or sets the System message's description. e.g. Vendor records have been synced successfully with Dynamics NAV.
		/// </summary>
		/// <value>
		/// The SysMessageDescription.
		/// </value>
		public string SysMessageDescription { get; set; }

		/// <summary>
		/// Gets or sets the System message's instruction.
		/// </summary>
		/// <value>
		/// The SysMessageInstruction.
		/// </value>
		public string SysMessageInstruction { get; set; }

		/// <summary>
		/// Gets or sets the Message Selection of button presses. e.g. Ok or Ok, Cancel
		/// </summary>
		/// <value>
		/// The SysMessageButtonSelection.
		/// </value>
		public string SysMessageButtonSelection { get; set; }
	}
}