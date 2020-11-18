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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IPrgRefGatewayDefaultCommands
// Purpose:                                      Set of rules for PrgRefGatewayDefaultCommands
//==============================================================================================================

using M4PL.Entities.Program;
using M4PL.Entities.Support;

namespace M4PL.Business.Program
{
	/// <summary>
	/// Performs basic CRUD operation on the PrgRefGatewayDefault Entity
	/// </summary>
	public interface IPrgRefGatewayDefaultCommands : IBaseCommands<PrgRefGatewayDefault>
	{
		PrgRefGatewayDefault PutWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault);

		PrgRefGatewayDefault PostWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault);
	}
}