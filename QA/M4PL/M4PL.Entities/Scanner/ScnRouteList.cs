﻿#region Copyright

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
// Program Name:                                 ScnRouteList
// Purpose:                                      Contains objects related to ScnRouteList
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Route List
	/// </summary>
	public class ScnRouteList : BaseModel
	{
		/// <summary>
		/// Gets or Sets Route Id
		/// </summary>
		public long RouteID { get; set; }
		/// <summary>
		/// Gets or Sets Route Name
		/// </summary>
		public string RouteName { get; set; }
		/// <summary>
		/// Gets or Sets Program Id
		/// </summary>
		public long? ProgramID { get; set; }
	}
}