/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnCargoDetailsController
//Purpose:                                      End point to interact with ScnCargoDetail
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnCargoDetails")]
    public class ScnCargoDetailsController : BaseApiController<ScnCargoDetail>
    {
        private readonly IScnCargoDetailCommands _ScnCargoDetailCommands;

        /// <summary>
        /// Function to get the ScnCargoDetail details
        /// </summary>
        /// <param name="scnCargoDetailCommands"></param>
        public ScnCargoDetailsController(IScnCargoDetailCommands scnCargoDetailCommands)
            : base(scnCargoDetailCommands)
        {
            _ScnCargoDetailCommands = scnCargoDetailCommands;
        }
    }
}