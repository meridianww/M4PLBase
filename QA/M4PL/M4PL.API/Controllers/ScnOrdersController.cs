/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnOrdersController
//Purpose:                                      End point to interact with ScnOrder
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnOrders")]
    public class ScnOrdersController : BaseApiController<ScnOrder>
    {
        private readonly IScnOrderCommands _ScnOrderCommands;

        /// <summary>
        /// Function to get the ScnOrder details
        /// </summary>
        /// <param name="scnOrderCommands"></param>
        public ScnOrdersController(IScnOrderCommands scnOrderCommands)
            : base(scnOrderCommands)
        {
            _ScnOrderCommands = scnOrderCommands;
        }
    }
}