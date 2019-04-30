/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnOrderOSDsController
//Purpose:                                      End point to interact with ScnOrderOSD
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnOrderOSDs")]
    public class ScnOrderOSDsController : BaseApiController<ScnOrderOSD>
    {
        private readonly IScnOrderOSDCommands _ScnOrderOSDCommands;

        /// <summary>
        /// Function to get the ScnOrderOSD details
        /// </summary>
        /// <param name="scnOrderOSDCommands"></param>
        public ScnOrderOSDsController(IScnOrderOSDCommands scnOrderOSDCommands)
            : base(scnOrderOSDCommands)
        {
            _ScnOrderOSDCommands = scnOrderOSDCommands;
        }
    }
}