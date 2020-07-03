#region Copyright

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
//Program Name:                                 MenuAccessLevel
//Purpose:                                      End point to interact with Menu Access Level module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/MenuAccessLevels")]
	public class MenuAccessLevelsController : BaseApiController<MenuAccessLevel>
	{
		private readonly IMenuAccessLevelCommands _menuAccessLevelCommands;

		/// <summary>
		/// Function to get security module's menu acccess level details
		/// </summary>
		/// <param name="menuAccessLevelCommands"></param>
		public MenuAccessLevelsController(IMenuAccessLevelCommands menuAccessLevelCommands)
			: base(menuAccessLevelCommands)
		{
			_menuAccessLevelCommands = menuAccessLevelCommands;
		}
	}
}