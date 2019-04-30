/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnDriverListsController
//Purpose:                                      End point to interact with ScnDriverList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnDriverLists")]
    public class ScnDriverListsController : BaseApiController<ScnDriverList>
    {
        private readonly IScnDriverListCommands _ScnDriverListCommands;

        /// <summary>
        /// Function to get the ScnDriverList details
        /// </summary>
        /// <param name="scnDriverListCommands"></param>
        public ScnDriverListsController(IScnDriverListCommands scnDriverListCommands)
            : base(scnDriverListCommands)
        {
            _ScnDriverListCommands = scnDriverListCommands;
        }
    }
}