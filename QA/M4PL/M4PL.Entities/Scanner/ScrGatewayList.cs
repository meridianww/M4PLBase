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
// Program Name:                                 ScrGatewayList
// Purpose:                                      Contains objects related to ScrGatewayList
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Gateway List
	/// </summary>
	public class ScrGatewayList : BaseModel
	{
		/// <summary>
		/// Gets or Sets Gateway Status Id
		/// </summary>
		public long GatewayStatusID { get; set; }
		/// <summary>
		/// Gets or Sets Program ID
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or sets Gateway Code
		/// </summary>
		public string GatewayCode { get; set; }
	}
}