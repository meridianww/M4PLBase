/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MenuDrivers
//Purpose:                                      End point to interact with Menu Driver module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/MenuDrivers")]
    public class MenuDriversController : BaseApiController<MenuDriver>
    {
        private readonly IMenuDriverCommands _menuDriverCommands;

        /// <summary>
        /// Function to get Administration's menu driver details
        /// </summary>
        /// <param name="menuDriverCommands"></param>
        public MenuDriversController(IMenuDriverCommands menuDriverCommands)
            : base(menuDriverCommands)
        {
            _menuDriverCommands = menuDriverCommands;
        }
    }
}