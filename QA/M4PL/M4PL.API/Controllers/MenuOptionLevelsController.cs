/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MenuOptionLevel
//Purpose:                                      End point to interact with Menu Option Level module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/MenuOptionLevels")]
    public class MenuOptionLevelsController : BaseApiController<MenuOptionLevel>
    {
        private readonly IMenuOptionLevelCommands _menuOptionLevelCommands;

        /// <summary>
        /// Function to get Administration's security module- menu option details
        /// </summary>
        /// <param name="menuOptionLevelCommands"></param>
        public MenuOptionLevelsController(IMenuOptionLevelCommands menuOptionLevelCommands)
            : base(menuOptionLevelCommands)
        {
            _menuOptionLevelCommands = menuOptionLevelCommands;
        }
    }
}