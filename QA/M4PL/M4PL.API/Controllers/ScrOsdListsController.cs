/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrOsdListsController
//Purpose:                                      End point to interact with ScrOsdList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrOsdLists")]
    public class ScrOsdListsController : BaseApiController<ScrOsdList>
    {
        private readonly IScrOsdListCommands _scrOsdListCommands;

        /// <summary>
        /// Function to get the ScrOsdList details
        /// </summary>
        /// <param name="scrOsdListCommands"></param>
        public ScrOsdListsController(IScrOsdListCommands scrOsdListCommands)
            : base(scrOsdListCommands)
        {
            _scrOsdListCommands = scrOsdListCommands;
        }
    }
}