/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrServiceListsController
//Purpose:                                      End point to interact with ScrServiceList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrServiceLists")]
    public class ScrServiceListsController : BaseApiController<ScrServiceList>
    {
        private readonly IScrServiceListCommands _scrServiceListCommands;

        /// <summary>
        /// Function to get the ScrServiceList details
        /// </summary>
        /// <param name="scrServiceListCommands"></param>
        public ScrServiceListsController(IScrServiceListCommands scrServiceListCommands)
            : base(scrServiceListCommands)
        {
            _scrServiceListCommands = scrServiceListCommands;
        }
    }
}