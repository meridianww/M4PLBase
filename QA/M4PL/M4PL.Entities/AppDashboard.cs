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
	public class AppDashboard : BaseModel
	{
		public int DshMainModuleId { get; set; }

		public byte[] DshTemplate { get; set; }

		public string DshDescription { get; set; }

		public string DshName { get; set; }

		private bool? dshIsDefault;
		public bool? DshIsDefault { get { return dshIsDefault; } set { dshIsDefault = value == null ? false : value; } }
	}
}