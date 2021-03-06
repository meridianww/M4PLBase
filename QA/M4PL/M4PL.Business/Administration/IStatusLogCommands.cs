﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Janardana
// Date Programmed:                              06/06/2018
// Program Name:                                 IStatusLogCommands
// Purpose:                                      Set of rules for StatusLogCommands
//==============================================================================================================

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
	/// <summary>
	/// Performs basic CRUD operation on the Delivery Status Entity
	/// </summary>
	public interface IStatusLogCommands : IBaseCommands<StatusLog>
	{
	}
}