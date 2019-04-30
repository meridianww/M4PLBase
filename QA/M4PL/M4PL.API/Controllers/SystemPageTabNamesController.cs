/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SystemPageTabNames
//Purpose:                                      End point to interact with SystemPageTabName module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SystemPageTabNames")]
    public class SystemPageTabNamesController : BaseApiController<SystemPageTabName>
    {
        private readonly ISystemPageTabNameCommands _systemPageTabNameCommands;

        /// <summary>
        /// Function to get Administraton's page tab name details
        /// </summary>
        /// <param name="systemPageTabNameCommands"></param>
        public SystemPageTabNamesController(ISystemPageTabNameCommands systemPageTabNameCommands)
            : base(systemPageTabNameCommands)
        {
            _systemPageTabNameCommands = systemPageTabNameCommands;
        }
    }
}