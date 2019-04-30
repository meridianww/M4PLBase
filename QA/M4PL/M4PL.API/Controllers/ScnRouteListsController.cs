/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnRouteListsController
//Purpose:                                      End point to interact with ScnRouteList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnRouteLists")]
    public class ScnRouteListsController : BaseApiController<ScnRouteList>
    {
        private readonly IScnRouteListCommands _ScnRouteListCommands;

        /// <summary>
        /// Function to get the ScnRouteList details
        /// </summary>
        /// <param name="scnRouteListCommands"></param>
        public ScnRouteListsController(IScnRouteListCommands scnRouteListCommands)
            : base(scnRouteListCommands)
        {
            _ScnRouteListCommands = scnRouteListCommands;
        }
    }
}