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
// Program Name:                                 ApiResult
// Purpose:                                      Contains objects related to ApiResult
//==========================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities
{
	/// <summary>
	///
	/// </summary>
	/// <typeparam name="TView"></typeparam>
	public class ApiResult<TView>
	{
		public ApiResult()
		{
			Results = new List<TView>();
		}

		/// <summary>
		///     Response Content
		/// </summary>
		public IList<TView> Results { get; set; }

		/// <summary>
		/// Response status
		/// </summary>
		public bool Status { get; set; }

		public int TotalResults { get; set; }

		public int ReturnedResults { get; set; }
	}
}