/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnCargosController
//Purpose:                                      End point to interact with ScnCargo
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnCargos")]
    public class ScnCargosController : BaseApiController<ScnCargo>
    {
        private readonly IScnCargoCommands _ScnCargoCommands;

        /// <summary>
        /// Function to get the ScnCargo details
        /// </summary>
        /// <param name="scnCargoCommands"></param>
        public ScnCargosController(IScnCargoCommands scnCargoCommands)
            : base(scnCargoCommands)
        {
            _ScnCargoCommands = scnCargoCommands;
        }
    }
}