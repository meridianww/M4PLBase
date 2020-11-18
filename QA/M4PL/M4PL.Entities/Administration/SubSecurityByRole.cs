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
// Program Name:                                 SubSecurityByRole
// Purpose:                                      Contains objects related to SubSecurityByRole
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// Entities for SubSecurityByRole will contain objects related to SubSecurityByRole
	/// </summary>
	public class SubSecurityByRole : BaseModel
	{
		/// <summary>
		/// Gets or Sets Security By Role Id i.e. SYSTM000SecurityByRole table id which is referenced by Role table
		/// </summary>
		public long? SecByRoleId { get; set; }
		/// <summary>
		/// Gets or Sets Reference Table Name e.g. JobGateway
		/// </summary>
		public string RefTableName { get; set; }
		/// <summary>
		/// Gets or Sets Sub Menu Option Level ID e.g. 24 for Reports
		/// </summary>
		public int SubsMenuOptionLevelId { get; set; }
		/// <summary>
		/// Gets or Sets Sub Menu Access Level ID e.g. 18 for Edit Actuals
		/// </summary>
		public int SubsMenuAccessLevelId { get; set; }
	}
}