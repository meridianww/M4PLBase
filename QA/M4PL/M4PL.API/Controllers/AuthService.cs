﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 AuthService
//Purpose:                                      End point to handle Authentication of user's role and authroization
//====================================================================================================================================================*/

using M4PL.API.Models;
using M4PL.Entities.Support;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// AuthService for authentication
	/// </summary>
	public class AuthService
	{/// <summary>
	/// Get Current user details
	/// </summary>
	/// <returns></returns>
		internal ActiveUser GetCurrentUser()
		{
			return new ActiveUser { UserId = ApiContext.UserId };
		}
	}
}