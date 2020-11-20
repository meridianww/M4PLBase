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
// Program Name:                                 AppDashboard
// Purpose:                                      Contains objects related to AppDashboard
//==========================================================================================================

namespace M4PL.Entities
{
	/// <summary>
	/// Model class of application Dashboard
	/// </summary>
	public class AppDashboard : BaseModel
	{
		/// <summary>
		/// Get or Set for Dashboard Main module Id
		/// </summary>
		public int DshMainModuleId { get; set; }
		/// <summary>
		/// Get or Set for Dashboard Template
		/// </summary>
		public byte[] DshTemplate { get; set; }
		/// <summary>
		/// Get or Set for Dashboard Description
		/// </summary>
		public string DshDescription { get; set; }
		/// <summary>
		/// Get or Set for Dashboard Name
		/// </summary>
		public string DshName { get; set; }
		/// <summary>
		/// private property of Dashboard is default or not
		/// </summary>
		private bool? dshIsDefault;
		/// <summary>
		/// Get or Set for Dashboard is default or not
		/// </summary>
		public bool? DshIsDefault { get { return dshIsDefault; } set { dshIsDefault = value == null ? false : value; } }
	}
}