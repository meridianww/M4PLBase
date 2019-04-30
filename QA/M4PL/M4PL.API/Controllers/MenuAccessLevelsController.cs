﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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