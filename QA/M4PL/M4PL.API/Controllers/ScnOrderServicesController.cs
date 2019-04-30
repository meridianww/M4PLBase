/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnOrderServicesController
//Purpose:                                      End point to interact with ScnOrderService
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnOrderServices")]
    public class ScnOrderServicesController : BaseApiController<ScnOrderService>
    {
        private readonly IScnOrderServiceCommands _ScnOrderServiceCommands;

        /// <summary>
        /// Function to get the ScnOrderService details
        /// </summary>
        /// <param name="scnOrderServiceCommands"></param>
        public ScnOrderServicesController(IScnOrderServiceCommands scnOrderServiceCommands)
            : base(scnOrderServiceCommands)
        {
            _ScnOrderServiceCommands = scnOrderServiceCommands;
        }
    }
}